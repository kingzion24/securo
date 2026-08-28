import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../models/split_group.dart';
import 'split_groups_screen.dart';

const _kGroupKinds = ['social', 'cost_center', 'project', 'client', 'other'];

class GroupFormScreen extends ConsumerStatefulWidget {
  const GroupFormScreen({this.group, super.key});
  final SplitGroup? group;

  @override
  ConsumerState<GroupFormScreen> createState() => _GroupFormScreenState();
}

class _GroupFormScreenState extends ConsumerState<GroupFormScreen> {
  late final _name = TextEditingController(text: widget.group?.name ?? '');
  late String _kind = widget.group?.kind ?? _kGroupKinds.first;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(splitGroupsRepositoryProvider);
    try {
      if (widget.group == null) {
        await repo.create(name: name, kind: _kind);
      } else {
        await repo.update(widget.group!.id, name: name);
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
      title: widget.group == null ? 'New Group' : 'Edit Group',
      saving: _saving,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Name',
          child: TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'e.g. Roommates'),
          ),
        ),
        if (widget.group == null)
          LabeledField(
            label: 'Kind',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final kind in _kGroupKinds)
                  ChoiceChip(
                    label: Text(kind[0].toUpperCase() + kind.substring(1).replaceAll('_', ' ')),
                    selected: kind == _kind,
                    onSelected: (_) => setState(() => _kind = kind),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
