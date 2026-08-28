import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/bloc/resource_list_cubit.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/agent.dart';
import '../workspace/workspace_controller.dart';
import 'agent_chat_screen.dart';
import 'agent_form_screen.dart';
import 'agents_repository.dart';
import 'connections_screen.dart';
import 'conversation_history_screen.dart';
import 'conversations_repository.dart';

final agentsRepositoryProvider = Provider<AgentsRepository>(
  (ref) => AgentsRepository(ref.watch(apiClientProvider)),
);

final connectionsRepositoryProvider = Provider<ConnectionsRepository>(
  (ref) => ConnectionsRepository(ref.watch(apiClientProvider)),
);

final conversationsRepositoryProvider = Provider<ConversationsRepository>(
  (ref) => ConversationsRepository(ref.watch(apiClientProvider)),
);

class AgentsScreen extends ConsumerWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(agentsRepositoryProvider);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return ResourceListScreen<Agent>(
      title: 'Agents',
      fetch: repository.list,
      emptyIcon: Icons.smart_toy_outlined,
      emptyTitle: 'No agents yet',
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.settings_ethernet),
            tooltip: 'Connections',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ConnectionsScreen()),
            ),
          ),
        ),
        if (canEdit)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'New agent',
              onPressed: () async {
                final created =
                    await pushFormScreen<bool>(context, const AgentFormScreen());
                if (created == true && context.mounted) {
                  context.read<ResourceListCubit<Agent>>().load();
                }
              },
            ),
          ),
      ],
      itemBuilder: (context, agent) => _AgentTile(
        agent: agent,
        canEdit: canEdit,
        repository: repository,
      ),
    );
  }
}

class _AgentTile extends StatelessWidget {
  const _AgentTile({required this.agent, required this.canEdit, required this.repository});
  final Agent agent;
  final bool canEdit;
  final AgentsRepository repository;

  void _chat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => AgentChatScreen(agent: agent)),
    );
  }

  Future<void> _edit(BuildContext context) async {
    if (!canEdit) return;
    final saved = await pushFormScreen<bool>(context, AgentFormScreen(agent: agent));
    if (saved == true && context.mounted) {
      context.read<ResourceListCubit<Agent>>().load();
    }
  }

  void _history(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ConversationHistoryScreen(agent: agent)),
    );
  }

  Future<void> _delete(BuildContext context) async {
    if (!canEdit) return;
    final confirmed = await confirmDelete(
      context,
      title: 'Delete "${agent.name}"?',
      message: 'This agent will be removed permanently.',
    );
    if (!confirmed || !context.mounted) return;
    try {
      await repository.delete(agent.id);
      if (context.mounted) context.read<ResourceListCubit<Agent>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _openActions(BuildContext context) async {
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(agent.name),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('history'),
            child: const Text('Conversation history'),
          ),
          if (canEdit)
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop('edit'),
              child: const Text('Edit'),
            ),
          if (canEdit)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(context).pop('delete'),
              child: const Text('Delete'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
    if (!context.mounted || action == null) return;
    switch (action) {
      case 'history':
        _history(context);
      case 'edit':
        await _edit(context);
      case 'delete':
        await _delete(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Pressable(
      onTap: () => _chat(context),
      onLongPress: () => _openActions(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.smart_toy_outlined, size: 20, color: colors.mutedForeground),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (agent.description != null && agent.description!.isNotEmpty)
                    Text(
                      agent.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: colors.mutedForeground),
                    ),
                ],
              ),
            ),
            if (agent.isDefault)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'Default',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: colors.mutedForeground),
                ),
              ),
            Icon(Icons.chat_bubble_outline, size: 18, color: colors.mutedForeground),
          ],
        ),
      ),
    );
  }
}
