import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/color.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../core/widgets/pressable.dart';
import '../../models/account.dart';
import '../../models/collection.dart';
import '../accounts/accounts_screen.dart';
import 'collections_screen.dart';

const _kCollectionColors = [
  '#0071e3', '#32ade6', '#34c759', '#ff9500',
  '#ff3b30', '#ff2d55', '#5e5ce6', '#6e6e73',
];

/// Scoped to account membership — wallet (asset-group) membership stays a
/// web-only field on this form for now; the mobile app doesn't yet have an
/// asset-groups screen to pick from.
class CollectionFormScreen extends ConsumerStatefulWidget {
  const CollectionFormScreen({this.collection, super.key});
  final Collection? collection;

  @override
  ConsumerState<CollectionFormScreen> createState() => _CollectionFormScreenState();
}

class _CollectionFormScreenState extends ConsumerState<CollectionFormScreen> {
  late final _name = TextEditingController(text: widget.collection?.name ?? '');
  late String _color = widget.collection?.color ?? _kCollectionColors.first;
  final Set<String> _selectedAccountIds = {};
  bool _saving = false;
  bool _loadingAccounts = true;
  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    _selectedAccountIds.addAll(widget.collection?.accountIds ?? const []);
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      final accounts = await ref.read(accountsRepositoryProvider).list();
      if (!mounted) return;
      setState(() {
        _accounts = accounts;
        _loadingAccounts = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingAccounts = false);
      showAppToast(context, '$error', isError: true);
    }
  }

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
    final repo = ref.read(collectionsRepositoryProvider);
    try {
      if (widget.collection == null) {
        await repo.create(
          name: name,
          color: _color,
          accountIds: _selectedAccountIds.toList(),
        );
      } else {
        await repo.update(
          widget.collection!.id,
          name: name,
          color: _color,
          accountIds: _selectedAccountIds.toList(),
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
      title: widget.collection == null ? 'New Collection' : 'Edit Collection',
      saving: _saving,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Name',
          child: TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'e.g. Travel'),
          ),
        ),
        LabeledField(
          label: 'Color',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final hex in _kCollectionColors)
                Pressable(
                  onTap: () => setState(() => _color = hex),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: parseHexColor(hex),
                      shape: BoxShape.circle,
                      border: hex == _color
                          ? Border.all(color: colors.foreground, width: 2)
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
        LabeledField(
          label: 'Accounts',
          child: _loadingAccounts
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(),
                )
              : SecuroCardList(
                  children: [
                    for (final account in _accounts)
                      CheckboxListTile(
                        title: Text(account.label),
                        subtitle: Text(account.currency),
                        value: _selectedAccountIds.contains(account.id),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (checked) => setState(() {
                          if (checked == true) {
                            _selectedAccountIds.add(account.id);
                          } else {
                            _selectedAccountIds.remove(account.id);
                          }
                        }),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

/// A borderless list of tiles inside the theme's card surface — used here so
/// `CheckboxListTile`'s built-in row chrome doesn't have to be rebuilt by
/// hand just to sit on `SecuroCard`'s background.
class SecuroCardList extends StatelessWidget {
  const SecuroCardList({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(SecuroRadius.card),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}
