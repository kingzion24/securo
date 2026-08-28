import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/large_title_scroll.dart';
import '../../core/widgets/panels.dart';
import '../../core/widgets/pressable.dart';
import '../../models/agent.dart';
import '../../models/agent_conversation.dart';
import 'agent_chat_screen.dart';
import 'agents_screen.dart';

class ConversationHistoryScreen extends ConsumerStatefulWidget {
  const ConversationHistoryScreen({required this.agent, super.key});
  final Agent agent;

  @override
  ConsumerState<ConversationHistoryScreen> createState() =>
      _ConversationHistoryScreenState();
}

class _ConversationHistoryScreenState extends ConsumerState<ConversationHistoryScreen> {
  List<AgentConversation>? _conversations;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list =
          await ref.read(conversationsRepositoryProvider).list(agentId: widget.agent.id);
      if (!mounted) return;
      setState(() => _conversations = list);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = '$error');
    }
  }

  Future<void> _delete(AgentConversation conversation) async {
    final confirmed = await confirmDelete(
      context,
      title: 'Delete "${conversation.title ?? 'this conversation'}"?',
    );
    if (!confirmed || !mounted) return;
    try {
      await ref.read(conversationsRepositoryProvider).delete(conversation.id);
      if (mounted) _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    return LargeTitleScrollView(
      title: 'History',
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          sliver: _conversations == null
              ? SliverToBoxAdapter(
                  child: _error != null
                      ? ErrorState(message: _error!, onRetry: _load)
                      : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                )
              : _conversations!.isEmpty
                  ? const SliverToBoxAdapter(
                      child: EmptyState(
                        icon: Icons.forum_outlined,
                        title: 'No conversations yet',
                      ),
                    )
                  : SliverList.separated(
                      itemCount: _conversations!.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final conversation = _conversations![i];
                        return Pressable(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => AgentChatScreen(
                                agent: widget.agent,
                                conversationId: conversation.id,
                              ),
                            ),
                          ),
                          onLongPress: () => _delete(conversation),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: colors.card,
                              border: Border.all(color: colors.border),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    conversation.title ?? 'Untitled conversation',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Icon(Icons.chevron_right, size: 18, color: colors.mutedForeground),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
