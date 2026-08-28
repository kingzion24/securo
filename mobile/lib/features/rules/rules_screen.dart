import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/rule.dart';
import 'rules_repository.dart';

final rulesRepositoryProvider = Provider<RulesRepository>(
  (ref) => RulesRepository(ref.watch(apiClientProvider)),
);

class RulesScreen extends ConsumerWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(rulesRepositoryProvider);
    return ResourceListScreen<Rule>(
      title: 'Rules',
      fetch: repository.list,
      emptyIcon: Icons.tune,
      emptyTitle: 'No rules yet',
      emptyMessage: 'Auto-categorize transactions as they come in.',
      itemBuilder: (context, rule) => _RuleTile(rule: rule),
    );
  }
}

class _RuleTile extends StatelessWidget {
  const _RuleTile({required this.rule});
  final Rule rule;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

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
                color: colors.muted,
                borderRadius: BorderRadius.circular(SecuroRadius.md),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.tune, size: 18, color: colors.mutedForeground),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${rule.conditions.length} '
                    '${rule.conditions.length == 1 ? 'condition' : 'conditions'} · '
                    '${rule.actions.length} ${rule.actions.length == 1 ? 'action' : 'actions'}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.mutedForeground),
                  ),
                ],
              ),
            ),
            Switch(value: rule.isActive, onChanged: null),
          ],
        ),
      ),
    );
  }
}
