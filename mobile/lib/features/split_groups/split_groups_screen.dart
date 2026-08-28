import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/color.dart';
import '../../core/icons/lucide_icon_map.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/split_group.dart';
import 'split_groups_repository.dart';

final splitGroupsRepositoryProvider = Provider<SplitGroupsRepository>(
  (ref) => SplitGroupsRepository(ref.watch(apiClientProvider)),
);

class SplitGroupsScreen extends ConsumerWidget {
  const SplitGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(splitGroupsRepositoryProvider);
    return ResourceListScreen<SplitGroup>(
      title: 'Groups',
      fetch: repository.list,
      emptyIcon: Icons.call_split,
      emptyTitle: 'No groups yet',
      emptyMessage: 'Split expenses with roommates, trips, or projects here.',
      itemBuilder: (context, group) => _GroupTile(group: group),
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({required this.group});
  final SplitGroup group;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final color = parseHexColor(group.color) ?? colors.chart4;

    return Pressable(
      onTap: () {},
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
              child: Icon(lucideIcon(group.icon), size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                group.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '${group.memberCount} ${group.memberCount == 1 ? 'member' : 'members'}',
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
