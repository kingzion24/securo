import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/bloc/resource_list_cubit.dart';
import '../../core/format/color.dart';
import '../../core/icons/lucide_icon_map.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/category.dart';
import '../workspace/workspace_controller.dart';
import 'categories_repository.dart';
import 'category_form_screen.dart';

final categoriesRepositoryProvider = Provider<CategoriesRepository>(
  (ref) => CategoriesRepository(ref.watch(apiClientProvider)),
);

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(categoriesRepositoryProvider);
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return ResourceListScreen<Category>(
      title: 'Categories',
      fetch: repository.list,
      emptyIcon: Icons.sell_outlined,
      emptyTitle: 'No categories yet',
      actions: !canEdit
          ? null
          : [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'New category',
                  onPressed: () async {
                    final created =
                        await pushFormScreen<bool>(context, const CategoryFormScreen());
                    if (created == true && context.mounted) {
                      context.read<ResourceListCubit<Category>>().load();
                    }
                  },
                ),
              ),
            ],
      itemBuilder: (context, category) => _CategoryTile(
        category: category,
        canEdit: canEdit,
        repository: repository,
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.canEdit,
    required this.repository,
  });
  final Category category;
  final bool canEdit;
  final CategoriesRepository repository;

  Future<void> _edit(BuildContext context) async {
    if (!canEdit || category.isSystem) return;
    final saved =
        await pushFormScreen<bool>(context, CategoryFormScreen(category: category));
    if (saved == true && context.mounted) {
      context.read<ResourceListCubit<Category>>().load();
    }
  }

  Future<void> _delete(BuildContext context) async {
    if (!canEdit || category.isSystem) return;
    final confirmed = await confirmDelete(
      context,
      title: 'Delete "${category.name}"?',
      message: 'Transactions in this category become uncategorized.',
    );
    if (!confirmed || !context.mounted) return;
    try {
      await repository.delete(category.id);
      if (context.mounted) context.read<ResourceListCubit<Category>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final color = parseHexColor(category.color) ?? colors.chart2;

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
              child: Icon(lucideIcon(category.icon), size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (category.isSystem)
              Text(
                'System',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: colors.mutedForeground),
              )
            else if (canEdit)
              Icon(Icons.chevron_right, size: 18, color: colors.mutedForeground),
          ],
        ),
      ),
    );
  }
}
