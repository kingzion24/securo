import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/format/display_settings.dart';
import '../../core/providers.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/resource_list_screen.dart';
import '../../models/account.dart';
import '../../models/import_log.dart';
import '../accounts/accounts_screen.dart' show accountsRepositoryProvider;
import 'import_repository.dart';

final importRepositoryProvider = Provider<ImportRepository>(
  (ref) => ImportRepository(ref.watch(apiClientProvider)),
);

class ImportScreen extends ConsumerWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(importRepositoryProvider);
    final locale = ref.watch(displayLocaleProvider);

    return ResourceListScreen<ImportLog>(
      title: 'Import',
      fetch: repository.logs,
      emptyIcon: Icons.upload_outlined,
      emptyTitle: 'Nothing imported yet',
      emptyMessage: 'Bring in a bank statement to add transactions in bulk.',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'New import',
          onPressed: () => _startImport(context, ref),
        ),
      ],
      itemBuilder: (context, log) => _ImportLogTile(log: log, locale: locale),
    );
  }

  Future<void> _startImport(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'ofx', 'qfx', 'qif'],
    );
    final file = result?.files.single;
    if (file?.path == null) return;
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ImportSheet(filePath: file!.path!, filename: file.name),
    );
  }
}

class _ImportLogTile extends StatelessWidget {
  const _ImportLogTile({required this.log, this.locale});

  final ImportLog log;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final created = DateTime.tryParse(log.createdAt);

    return Padding(
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
            child: Icon(Icons.description_outlined, size: 18, color: colors.mutedForeground),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.filename,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (log.accountName != null) log.accountName!,
                    '${log.transactionCount} transactions',
                    if (created != null) DateFormat.yMMMd(locale).format(created),
                  ].join(' · '),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: colors.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportSheet extends ConsumerStatefulWidget {
  const _ImportSheet({required this.filePath, required this.filename});
  final String filePath;
  final String filename;

  @override
  ConsumerState<_ImportSheet> createState() => _ImportSheetState();
}

class _ImportSheetState extends ConsumerState<_ImportSheet> {
  ImportPreview? _preview;
  String? _error;
  bool _loading = true;
  bool _importing = false;
  Account? _selectedAccount;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    try {
      final preview = await ref
          .read(importRepositoryProvider)
          .preview(widget.filePath, widget.filename);
      if (!mounted) return;
      setState(() {
        _preview = preview;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = '$error';
        _loading = false;
      });
    }
  }

  Future<void> _confirm() async {
    final preview = _preview;
    final account = _selectedAccount;
    if (preview == null || account == null) return;
    setState(() => _importing = true);
    try {
      final imported = await ref.read(importRepositoryProvider).confirm(
            accountId: account.id,
            transactions: preview.transactions,
            filename: widget.filename,
            detectedFormat: preview.detectedFormat,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imported $imported transactions')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = '$error';
        _importing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final accountsAsync = ref.watch(_importAccountsProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(SecuroRadius.xl)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.filename, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_error != null)
              Text(_error!, style: TextStyle(color: colors.destructive))
            else if (_preview != null) ...[
              Text(
                '${_preview!.transactions.length} transactions found'
                ' (${_preview!.detectedFormat})',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (_preview!.warnings.isNotEmpty) ...[
                const SizedBox(height: 8),
                for (final warning in _preview!.warnings)
                  Text(
                    warning,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.mutedForeground),
                  ),
              ],
              const SizedBox(height: 16),
              Text('Import into', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 8),
              accountsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text('$error'),
                data: (accounts) {
                  _selectedAccount ??= accounts.isNotEmpty ? accounts.first : null;
                  return DropdownButtonFormField<Account>(
                    initialValue: _selectedAccount,
                    items: [
                      for (final account in accounts)
                        DropdownMenuItem(value: account, child: Text(account.label)),
                    ],
                    onChanged: (value) => setState(() => _selectedAccount = value),
                  );
                },
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _preview!.transactions.isEmpty || _importing
                    ? null
                    : _confirm,
                child: _importing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Import'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final _importAccountsProvider = FutureProvider.autoDispose<List<Account>>((ref) {
  return ref.read(accountsRepositoryProvider).list();
});
