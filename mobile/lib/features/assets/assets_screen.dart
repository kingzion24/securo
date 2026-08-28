import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/bloc/resource_list_cubit.dart';
import '../../core/format/display_settings.dart';
import '../../core/format/money.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/asset.dart';
import '../workspace/workspace_controller.dart';
import 'asset_form_screen.dart';
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
    final canEdit = ref.watch(currentWorkspaceProvider).valueOrNull?.canEdit ?? true;

    return ResourceListScreen<Asset>(
      title: 'Assets',
      fetch: repository.list,
      emptyIcon: Icons.landscape_outlined,
      emptyTitle: 'No assets yet',
      emptyMessage: 'Investments and other holdings you track show up here.',
      actions: !canEdit
          ? null
          : [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'New asset',
                  onPressed: () async {
                    final created =
                        await pushFormScreen<bool>(context, const AssetFormScreen());
                    if (created == true && context.mounted) {
                      context.read<ResourceListCubit<Asset>>().load();
                    }
                  },
                ),
              ),
            ],
      itemBuilder: (context, asset) => _AssetTile(
        asset: asset,
        displayCurrency: displayCurrency,
        locale: locale,
        canEdit: canEdit,
        repository: repository,
      ),
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({
    required this.asset,
    required this.displayCurrency,
    required this.canEdit,
    required this.repository,
    this.locale,
  });

  final Asset asset;
  final String displayCurrency;
  final bool canEdit;
  final AssetsRepository repository;
  final String? locale;

  Future<void> _edit(BuildContext context) async {
    if (!canEdit) return;
    final saved = await pushFormScreen<bool>(context, AssetFormScreen(asset: asset));
    if (saved == true && context.mounted) {
      context.read<ResourceListCubit<Asset>>().load();
    }
  }

  Future<void> _delete(BuildContext context) async {
    if (!canEdit) return;
    final confirmed = await confirmDelete(context, title: 'Delete "${asset.name}"?');
    if (!confirmed || !context.mounted) return;
    try {
      await repository.delete(asset.id);
      if (context.mounted) context.read<ResourceListCubit<Asset>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _refreshPrice(BuildContext context) async {
    try {
      await repository.refreshPrice(asset.id);
      if (context.mounted) context.read<ResourceListCubit<Asset>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _recordTrade(BuildContext context) async {
    String kind = 'buy';
    final quantity = TextEditingController();
    final price = TextEditingController(
      text: asset.lastPrice != null ? asset.lastPrice!.toStringAsFixed(2) : '',
    );
    final result = await showAppDialog<bool>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AppDialog(
          title: 'Trade ${asset.ticker ?? asset.name}',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'buy', label: Text('Buy')),
                  ButtonSegment(value: 'sell', label: Text('Sell')),
                ],
                selected: {kind},
                onSelectionChanged: (s) => setDialogState(() => kind = s.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantity,
                autofocus: true,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(hintText: 'Quantity'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: price,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(hintText: 'Price per unit'),
              ),
            ],
          ),
          actions: [
            AppDialogAction(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(false),
            ),
            AppDialogAction(
              label: 'Record',
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
    if (result != true || !context.mounted) return;
    final q = double.tryParse(quantity.text.trim());
    final p = double.tryParse(price.text.trim());
    if (q == null || q <= 0 || p == null || p < 0) {
      showAppToast(context, 'Enter a valid quantity and price', isError: true);
      return;
    }
    try {
      await repository.recordTrade(
        asset.id,
        kind: kind,
        quantity: q,
        price: p,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      if (context.mounted) context.read<ResourceListCubit<Asset>>().load();
    } catch (error) {
      if (context.mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _openActions(BuildContext context) async {
    if (!canEdit) return;
    if (!asset.isMarketPriced) {
      await _delete(context);
      return;
    }
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(asset.name),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('trade'),
            child: const Text('Record a trade'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('refresh'),
            child: const Text('Refresh price'),
          ),
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
      case 'trade':
        await _recordTrade(context);
      case 'refresh':
        await _refreshPrice(context);
      case 'delete':
        await _delete(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final usingPrimary = asset.currentValuePrimary != null;
    final value = asset.currentValuePrimary ?? asset.currentValue ?? 0;
    final currency = usingPrimary ? displayCurrency : asset.currency;
    final gain = usingPrimary ? asset.gainLossPrimary : asset.gainLoss;

    return Pressable(
      onTap: () => _edit(context),
      onLongPress: () => _openActions(context),
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
                            color: colors.mutedForeground,
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
