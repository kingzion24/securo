import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../models/agent.dart';
import 'agents_screen.dart';

enum _Role { user, assistant, tool }

class _ChatBubble {
  _ChatBubble({required this.role, this.content = '', this.toolName});
  final _Role role;
  String content;
  String? toolName;
  bool streaming = false;
}

class AgentChatScreen extends ConsumerStatefulWidget {
  const AgentChatScreen({required this.agent, this.conversationId, super.key});
  final Agent agent;
  final String? conversationId;

  @override
  ConsumerState<AgentChatScreen> createState() => _AgentChatScreenState();
}

class _AgentChatScreenState extends ConsumerState<AgentChatScreen> {
  final _input = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatBubble> _bubbles = [];
  String? _conversationId;
  bool _sending = false;
  bool _loadingHistory = false;

  @override
  void initState() {
    super.initState();
    _conversationId = widget.conversationId;
    if (_conversationId != null) _loadHistory();
  }

  @override
  void dispose() {
    _input.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _loadingHistory = true);
    try {
      final messages =
          await ref.read(conversationsRepositoryProvider).messages(_conversationId!);
      if (!mounted) return;
      setState(() {
        _bubbles.addAll([
          for (final m in messages)
            if (m.role == 'user' || m.role == 'assistant')
              _ChatBubble(
                role: m.role == 'user' ? _Role.user : _Role.assistant,
                content: m.content ?? '',
              ),
        ]);
        _loadingHistory = false;
      });
      _scrollToEnd();
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingHistory = false);
      showAppToast(context, '$error', isError: true);
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    _input.clear();
    setState(() {
      _bubbles.add(_ChatBubble(role: _Role.user, content: text));
      _sending = true;
    });
    _scrollToEnd();

    final assistantBubble = _ChatBubble(role: _Role.assistant)..streaming = true;
    setState(() => _bubbles.add(assistantBubble));
    _scrollToEnd();

    try {
      final stream = ref.read(conversationsRepositoryProvider).streamChat(
            widget.agent.id,
            content: text,
            conversationId: _conversationId,
          );
      await for (final event in stream) {
        if (!mounted) return;
        switch (event.type) {
          case 'conversation':
            _conversationId = event.conversationId;
          case 'text_delta':
            setState(() => assistantBubble.content += event.text ?? '');
            _scrollToEnd();
          case 'tool_call':
            setState(() => _bubbles.add(
                  _ChatBubble(role: _Role.tool, toolName: event.toolName),
                ));
            _scrollToEnd();
          case 'error':
            setState(
              () => assistantBubble.content +=
                  '\n\n⚠ ${event.errorMessage ?? 'Something went wrong'}',
            );
        }
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => assistantBubble.content += '\n\n⚠ $error');
    } finally {
      if (mounted) {
        setState(() {
          assistantBubble.streaming = false;
          _sending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(widget.agent.name),
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_loadingHistory)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
            Expanded(
              child: _bubbles.isEmpty && !_loadingHistory
                  ? Center(
                      child: Text(
                        'Ask ${widget.agent.name} anything about your finances.',
                        style: TextStyle(color: colors.mutedForeground),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _bubbles.length,
                      itemBuilder: (context, i) => _BubbleView(bubble: _bubbles[i]),
                    ),
            ),
            _Composer(controller: _input, sending: _sending, onSend: _send),
          ],
        ),
      ),
    );
  }
}

class _BubbleView extends StatelessWidget {
  const _BubbleView({required this.bubble});
  final _ChatBubble bubble;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    if (bubble.role == _Role.tool) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(Icons.bolt, size: 14, color: colors.mutedForeground),
            const SizedBox(width: 6),
            Text(
              'Used ${bubble.toolName ?? 'a tool'}',
              style: TextStyle(color: colors.mutedForeground, fontSize: 12),
            ),
          ],
        ),
      );
    }

    final isUser = bubble.role == _Role.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? colors.primary : colors.card,
          borderRadius: BorderRadius.circular(SecuroRadius.xl2),
          border: isUser ? null : Border.all(color: colors.border),
        ),
        child: bubble.content.isEmpty && bubble.streaming
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isUser ? colors.primaryForeground : colors.mutedForeground,
                ),
              )
            : Text(
                bubble.content,
                style: TextStyle(
                  color: isUser ? colors.primaryForeground : colors.cardForeground,
                ),
              ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.sending, required this.onSend});
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Message',
                filled: true,
                fillColor: colors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SecuroRadius.pill),
                  borderSide: BorderSide(color: colors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: sending ? null : onSend,
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
