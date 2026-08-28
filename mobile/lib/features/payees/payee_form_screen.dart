import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../models/payee.dart';
import 'payees_screen.dart';

class PayeeFormScreen extends ConsumerStatefulWidget {
  const PayeeFormScreen({this.payee, super.key});
  final Payee? payee;

  @override
  ConsumerState<PayeeFormScreen> createState() => _PayeeFormScreenState();
}

class _PayeeFormScreenState extends ConsumerState<PayeeFormScreen> {
  late final _name = TextEditingController(text: widget.payee?.name ?? '');
  late final _email = TextEditingController(text: widget.payee?.email ?? '');
  late final _phone = TextEditingController(text: widget.payee?.phone ?? '');
  late final _address = TextEditingController(text: widget.payee?.address ?? '');
  late final _website = TextEditingController(text: widget.payee?.website ?? '');
  late final _notes = TextEditingController(text: widget.payee?.notes ?? '');
  String? _type;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _type = widget.payee?.type;
  }

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _address, _website, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(payeesRepositoryProvider);
    try {
      String? orNull(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
      if (widget.payee == null) {
        await repo.create(
          name: name,
          type: _type,
          email: orNull(_email),
          phone: orNull(_phone),
          address: orNull(_address),
          website: orNull(_website),
          notes: orNull(_notes),
        );
      } else {
        await repo.update(
          widget.payee!.id,
          name: name,
          type: _type,
          email: orNull(_email),
          phone: orNull(_phone),
          address: orNull(_address),
          website: orNull(_website),
          notes: orNull(_notes),
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
    return FormScreen(
      title: widget.payee == null ? 'New Payee' : 'Edit Payee',
      saving: _saving,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Name',
          child: TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'e.g. Amazon'),
          ),
        ),
        LabeledField(
          label: 'Type',
          child: SegmentedButton<String?>(
            segments: const [
              ButtonSegment(value: null, label: Text('Unknown')),
              ButtonSegment(value: 'person', label: Text('Person')),
              ButtonSegment(value: 'company', label: Text('Company')),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
        ),
        LabeledField(
          label: 'Email',
          child: TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        LabeledField(label: 'Phone', child: TextField(controller: _phone)),
        LabeledField(label: 'Address', child: TextField(controller: _address)),
        LabeledField(
          label: 'Website',
          child: TextField(controller: _website, keyboardType: TextInputType.url),
        ),
        LabeledField(
          label: 'Notes',
          child: TextField(controller: _notes, maxLines: 3),
        ),
      ],
    );
  }
}
