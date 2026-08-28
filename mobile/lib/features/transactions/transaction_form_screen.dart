import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../models/account.dart';
import '../../models/attachment.dart';
import '../../models/category.dart';
import '../../models/payee.dart';
import '../../models/transaction.dart';
import '../accounts/accounts_screen.dart';
import '../categories/categories_screen.dart';
import '../payees/payees_screen.dart';
import 'transactions_screen.dart';

/// Create (transaction == null) or edit an existing transaction. Scoped to
/// the fields the mobile app can usefully edit today — description, amount,
/// direction, date, account/category/payee, notes, and (once saved)
/// attachments. Installment series and splits stay web-only for now, same
/// restraint call as the Import screen's single-step flow. Transfers get
/// their own screen (`TransferFormScreen`) since they're a different shape
/// entirely — a linked debit/credit pair, not a single row.
class TransactionFormScreen extends ConsumerStatefulWidget {
  const TransactionFormScreen({this.transaction, this.defaultAccount, super.key});
  final Transaction? transaction;
  final Account? defaultAccount;

  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  late final _description =
      TextEditingController(text: widget.transaction?.description ?? '');
  late final _amount = TextEditingController(
    text: widget.transaction == null ? '' : widget.transaction!.amount.toString(),
  );
  late final _notes = TextEditingController(text: widget.transaction?.notes ?? '');
  late TransactionType _type = widget.transaction?.type ?? TransactionType.debit;
  late DateTime _date =
      DateTime.tryParse(widget.transaction?.date ?? '') ?? DateTime.now();
  Account? _account;
  Category? _category;
  Payee? _payee;
  bool _saving = false;
  bool _loadingPickers = true;

  List<Account> _accounts = [];
  List<Category> _categories = [];
  List<Payee> _payees = [];

  @override
  void initState() {
    super.initState();
    _account = widget.defaultAccount;
    _loadPickerData();
  }

  Future<void> _loadPickerData() async {
    try {
      final results = await Future.wait([
        ref.read(accountsRepositoryProvider).list(),
        ref.read(categoriesRepositoryProvider).list(),
        ref.read(payeesRepositoryProvider).list(),
      ]);
      if (!mounted) return;
      setState(() {
        _accounts = results[0] as List<Account>;
        _categories = results[1] as List<Category>;
        _payees = results[2] as List<Payee>;
        _account ??= _accounts.isNotEmpty ? _accounts.first : null;
        if (widget.transaction?.accountId != null) {
          _account = _accounts
              .where((a) => a.id == widget.transaction!.accountId)
              .firstOrNull ??
              _account;
        }
        if (widget.transaction?.categoryId != null) {
          _category = _categories
              .where((c) => c.id == widget.transaction!.categoryId)
              .firstOrNull;
        }
        if (widget.transaction?.payeeId != null) {
          _payee =
              _payees.where((p) => p.id == widget.transaction!.payeeId).firstOrNull;
        }
        _loadingPickers = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingPickers = false);
      showAppToast(context, '$error', isError: true);
    }
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime picked = _date;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 260,
        color: SecuroTheme.of(context).card,
        child: Column(
          children: [
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _date,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (value) => picked = value,
              ),
            ),
            SafeArea(
              top: false,
              child: CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
    setState(() => _date = picked);
  }

  Future<void> _save() async {
    final description = _description.text.trim();
    final amount = double.tryParse(_amount.text.trim());
    if (description.isEmpty) {
      showAppToast(context, 'Enter a description', isError: true);
      return;
    }
    if (amount == null || amount <= 0) {
      showAppToast(context, 'Enter a valid amount', isError: true);
      return;
    }
    if (_account == null) {
      showAppToast(context, 'Choose an account', isError: true);
      return;
    }

    setState(() => _saving = true);
    final repo = ref.read(transactionsRepositoryProvider);
    final dateStr = DateFormat('yyyy-MM-dd').format(_date);
    final notes = _notes.text.trim().isEmpty ? null : _notes.text.trim();
    try {
      if (widget.transaction == null) {
        await repo.create(
          description: description,
          amount: amount,
          date: dateStr,
          type: _type == TransactionType.credit ? 'credit' : 'debit',
          accountId: _account!.id,
          categoryId: _category?.id,
          payeeId: _payee?.id,
          notes: notes,
        );
      } else {
        await repo.update(
          widget.transaction!.id,
          description: description,
          amount: amount,
          date: dateStr,
          type: _type == TransactionType.credit ? 'credit' : 'debit',
          accountId: _account!.id,
          categoryId: _category?.id,
          payeeId: _payee?.id,
          notes: notes,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      showAppToast(context, '$error', isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);

    return FormScreen(
      title: widget.transaction == null ? 'New Transaction' : 'Edit Transaction',
      saving: _saving,
      canSave: !_loadingPickers,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Type',
          child: SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment(value: TransactionType.debit, label: Text('Expense')),
              ButtonSegment(value: TransactionType.credit, label: Text('Income')),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
        ),
        LabeledField(
          label: 'Description',
          child: TextField(
            controller: _description,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'e.g. Grocery run'),
          ),
        ),
        LabeledField(
          label: 'Amount',
          child: TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: '0.00'),
          ),
        ),
        LabeledField(
          label: 'Date',
          child: Pressable(
            onTap: _pickDate,
            child: _FieldBox(
              child: Text(
                DateFormat.yMMMd().format(_date),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        LabeledField(
          label: 'Account',
          child: Pressable(
            onTap: _loadingPickers
                ? null
                : () async {
                    final picked = await showPickerSheet<Account>(
                      context,
                      title: 'Account',
                      items: _accounts,
                      labelBuilder: (a) => a.label,
                      selected: _account,
                    );
                    if (picked != null) setState(() => _account = picked);
                  },
            child: _FieldBox(
              loading: _loadingPickers,
              child: Text(
                _account?.label ?? 'Choose an account',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _account == null ? colors.mutedForeground : null,
                    ),
              ),
            ),
          ),
        ),
        LabeledField(
          label: 'Category',
          child: Pressable(
            onTap: _loadingPickers
                ? null
                : () async {
                    final picked = await showPickerSheet<Category?>(
                      context,
                      title: 'Category',
                      items: _categories,
                      labelBuilder: (c) => c!.name,
                      selected: _category,
                      allowNone: true,
                    );
                    setState(() => _category = picked);
                  },
            child: _FieldBox(
              loading: _loadingPickers,
              child: Text(
                _category?.name ?? 'None',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _category == null ? colors.mutedForeground : null,
                    ),
              ),
            ),
          ),
        ),
        LabeledField(
          label: 'Payee',
          child: Pressable(
            onTap: _loadingPickers
                ? null
                : () async {
                    final picked = await showPickerSheet<Payee?>(
                      context,
                      title: 'Payee',
                      items: _payees,
                      labelBuilder: (p) => p!.name,
                      selected: _payee,
                      allowNone: true,
                    );
                    setState(() => _payee = picked);
                  },
            child: _FieldBox(
              loading: _loadingPickers,
              child: Text(
                _payee?.name ?? 'None',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _payee == null ? colors.mutedForeground : null,
                    ),
              ),
            ),
          ),
        ),
        LabeledField(
          label: 'Notes',
          child: TextField(controller: _notes, maxLines: 3),
        ),
        // Attachments need a transaction id to attach to, so this only shows
        // once one exists — matches the web app hiding the uploader on the
        // create form too.
        if (widget.transaction != null) _AttachmentsSection(transactionId: widget.transaction!.id),
      ],
    );
  }
}

class _AttachmentsSection extends ConsumerStatefulWidget {
  const _AttachmentsSection({required this.transactionId});
  final String transactionId;

  @override
  ConsumerState<_AttachmentsSection> createState() => _AttachmentsSectionState();
}

class _AttachmentsSectionState extends ConsumerState<_AttachmentsSection> {
  List<Attachment>? _attachments;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list =
          await ref.read(attachmentsRepositoryProvider).list(widget.transactionId);
      if (mounted) setState(() => _attachments = list);
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  Future<void> _upload() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'heic', 'pdf'],
    );
    final file = result?.files.single;
    if (file?.path == null || !mounted) return;
    setState(() => _uploading = true);
    try {
      await ref
          .read(attachmentsRepositoryProvider)
          .upload(widget.transactionId, file!.path!, file.name);
      if (mounted) await _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _delete(Attachment attachment) async {
    final confirmed = await confirmDelete(context, title: 'Remove "${attachment.filename}"?');
    if (!confirmed || !mounted) return;
    try {
      await ref
          .read(attachmentsRepositoryProvider)
          .delete(widget.transactionId, attachment.id);
      if (mounted) await _load();
    } catch (error) {
      if (mounted) showAppToast(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return LabeledField(
      label: 'Attachments',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_attachments == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CupertinoActivityIndicator(),
            )
          else
            for (final attachment in _attachments!)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      attachment.isImage ? Icons.image_outlined : Icons.description_outlined,
                      size: 18,
                      color: colors.mutedForeground,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        attachment.filename,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Pressable(
                      onTap: () => _delete(attachment),
                      child: Icon(Icons.close, size: 16, color: colors.mutedForeground),
                    ),
                  ],
                ),
              ),
          OutlinedButton.icon(
            onPressed: _uploading ? null : _upload,
            icon: _uploading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.attach_file, size: 16),
            label: const Text('Add attachment'),
          ),
        ],
      ),
    );
  }
}

class _FieldBox extends StatelessWidget {
  const _FieldBox({required this.child, this.loading = false});
  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        border: Border.all(color: colors.input),
      ),
      child: Row(
        children: [
          Expanded(child: child),
          if (loading)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: colors.mutedForeground),
            )
          else
            Icon(Icons.unfold_more, size: 18, color: colors.mutedForeground),
        ],
      ),
    );
  }
}
