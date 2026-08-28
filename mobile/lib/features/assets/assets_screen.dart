import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/display_settings.dart';
import '../../core/format/money.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/asset.dart';
import 'assets_repository.dart';

final assetsRepositoryProvider = Provider<AssetsRepository>(
  (ref) => AssetsRepository(ref.watch(apiClientProvider)),
);

class AssetsScreen extends ConsumerWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(assetsRepositoryProvider);
    final displayCurrency = ref.watch(displayCurrencyProvider);
    final locale = ref.watch(displayLocaleProvider);

    return ResourceListScreen<Asset>(
      title: 'Assets',
      fetch: repository.list,
      emptyIcon: Icons.landscape_outlined,
      emptyTitle: 'No assets yet',
      emptyMessage: 'Investments and other holdings you track show up here.',
      itemBuilder: (context, asset) => _AssetTile(
        asset: asset,
        displayCurrency: displayCurrency,
        locale: locale,
      ),
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({
    required this.asset,
    required this.displayCurrency,
    this.locale,
  });

  final Asset asset;
  final String displayCurrency;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final usingPrimary = asset.currentValuePrimary != null;
    final value = asset.currentValuePrimary ?? asset.currentValue ?? 0;
    final currency = usingPrimary ? displayCurrency : asset.currency;
    final gain = usingPrimary ? asset.gainLossPrimary : asset.gainLoss;

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
                color: colors.chart5.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(SecuroRadius.md),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.trending_up, size: 18, color: colors.chart5),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (gain != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      formatSignedMoney(gain, currency: currency, locale: locale),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: gain < 0 ? colors.destructive : colors.chart3,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              formatMoney(value, currency: currency, locale: locale),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
