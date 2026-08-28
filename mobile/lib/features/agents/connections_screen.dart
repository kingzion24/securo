import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/bloc/resource_list_cubit.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/agent.dart';
import '../workspace/workspace_controller.dart';
import 'agents_repository.dart';
import 'agents_screen.dart';
import 'connection_form_screen.dart';

class ConnectionsScreen extends ConsumerWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(connectionsRepositoryProvider);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return ResourceListScreen<LlmConnection>(
      title: 'Connections',
      fetch: repository.list,
      emptyIcon: Icons.settings_ethernet,
      emptyTitle: 'No connections yet',
      actions: !canEdit
          ? null
          : [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'New connection',
                  onPressed: () async {
                    final created = await pushFormScreen<bool>(
                        context, const ConnectionFormScreen());
                    if (created == true && context.mounted) {
                      context.read<ResourceListCubit<LlmConnection>>().load();
                    }
                  },
                ),
              ),
            ],
      itemBuilder: (context, connection) => _ConnectionTile(
        connection: connection,
        canEdit: canEdit,
        repository: repository,
      ),
    );
  }
}

class _ConnectionTile extends StatelessWidget {
  const _ConnectionTile({
    required this.connection,
    required this.canEdit,
    required this.repository,
  });
  final LlmConnection connection;
  final bool canEdit;
  final ConnectionsRepository repository;

  Future<void> _edit(BuildContext context) async {
    if (!canEdit) return;
    final saved = await pushFormScreen<bool>(
        context, ConnectionFormScreen(connection: connection));
    if (saved == true && context.mounted) {
      context.read<ResourceListCubit<LlmConnection>>().load();
    }
  }

  Future<void> _delete(BuildContext context) async {
    if (!canEdit) return;
    final confirmed = await confirmDelete(
      context,
      title: 'Delete "${connection.name}"?',
      message: 'Agents using this connection will stop working.',
    );
    if (!confirmed || !context.mounted) return;
    try {
      await repository.delete(connection.id);
      if (context.mounted) context.read<ResourceListCubit<LlmConnection>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Pressable(
      onTap: () => _edit(context),
      onLongPress: () => _delete(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.dns_outlined, size: 20, color: colors.mutedForeground),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    connection.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    connection.kind,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.mutedForeground),
                  ),
                ],
              ),
            ),
            if (connection.isDefault)
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
            if (canEdit) Icon(Icons.chevron_right, size: 18, color: colors.mutedForeground),
          ],
        ),
      ),
    );
  }
}
