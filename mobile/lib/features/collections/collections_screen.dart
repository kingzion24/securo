import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/bloc/resource_list_cubit.dart';
import '../../core/format/color.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/collection.dart';
import '../workspace/workspace_controller.dart';
import 'collection_form_screen.dart';
import 'collections_repository.dart';

final collectionsRepositoryProvider = Provider<CollectionsRepository>(
  (ref) => CollectionsRepository(ref.watch(apiClientProvider)),
);

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(collectionsRepositoryProvider);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return ResourceListScreen<Collection>(
      title: 'Collections',
      fetch: repository.list,
      emptyIcon: Icons.folder_outlined,
      emptyTitle: 'No collections yet',
      emptyMessage: 'Group accounts into a filtered view — a trip, a project, a household.',
      actions: !canEdit
          ? null
          : [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'New collection',
                  onPressed: () async {
                    final created =
                        await pushFormScreen<bool>(context, const CollectionFormScreen());
                    if (created == true && context.mounted) {
                      context.read<ResourceListCubit<Collection>>().load();
                    }
                  },
                ),
              ),
            ],
      itemBuilder: (context, collection) => _CollectionTile(
        collection: collection,
        canEdit: canEdit,
        repository: repository,
      ),
    );
  }
}

class _CollectionTile extends StatelessWidget {
  const _CollectionTile({
    required this.collection,
    required this.canEdit,
    required this.repository,
  });
  final Collection collection;
  final bool canEdit;
  final CollectionsRepository repository;

  Future<void> _edit(BuildContext context) async {
    if (!canEdit) return;
    final saved =
        await pushFormScreen<bool>(context, CollectionFormScreen(collection: collection));
    if (saved == true && context.mounted) {
      context.read<ResourceListCubit<Collection>>().load();
    }
  }

  Future<void> _delete(BuildContext context) async {
    if (!canEdit) return;
    final confirmed = await confirmDelete(context, title: 'Delete "${collection.name}"?');
    if (!confirmed || !context.mounted) return;
    try {
      await repository.delete(collection.id);
      if (context.mounted) context.read<ResourceListCubit<Collection>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final color = parseHexColor(collection.color) ?? colors.chart1;

    return Pressable(
      onTap: () => _edit(context),
      onLongPress: () => _delete(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(SecuroRadius.md),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.folder, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                collection.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '${collection.accountIds.length} accounts',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: colors.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}
