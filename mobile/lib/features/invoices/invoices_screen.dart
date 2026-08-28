import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/large_title_scroll.dart';

/// The web app doesn't have a real invoices ledger yet either — its
/// `/invoices` route is deliberately honest about being a placeholder rather
/// than showing fake data (see `frontend/src/pages/invoices.tsx`). This
/// mirrors that instead of inventing a feature that doesn't exist server-side.
class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return LargeTitleScrollView(
      title: 'Invoices',
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(SecuroRadius.lg),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.receipt_long_outlined,
                        size: 26, color: colors.primary),
                  ),
                  const SizedBox(height: 16),
                  Text('Invoices', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Bill your clients and keep track of what has been paid and '
                    'what is still open. This is the next thing being built.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: colors.mutedForeground),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
