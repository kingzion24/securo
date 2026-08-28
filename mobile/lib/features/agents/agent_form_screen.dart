import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../models/agent.dart';
import 'agents_screen.dart';

class AgentFormScreen extends ConsumerStatefulWidget {
  const AgentFormScreen({this.agent, super.key});
  final Agent? agent;

  @override
  ConsumerState<AgentFormScreen> createState() => _AgentFormScreenState();
}

class _AgentFormScreenState extends ConsumerState<AgentFormScreen> {
  late final _name = TextEditingController(text: widget.agent?.name ?? '');
  late final _description = TextEditingController(text: widget.agent?.description ?? '');
  late final _systemPrompt =
      TextEditingController(text: widget.agent?.systemPrompt ?? '');
  late final _model = TextEditingController(text: widget.agent?.model ?? '');
  late final _temperature =
      TextEditingController(text: (widget.agent?.temperature ?? 0.4).toString());

  String? _connectionId;
  List<LlmConnection> _connections = const [];
  bool _loadingConnections = true;
  late bool _autoContext = widget.agent?.autoContext ?? true;
  late bool _isDefault = widget.agent?.isDefault ?? false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _connectionId = widget.agent?.connectionId;
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    try {
      final list = await ref.read(connectionsRepositoryProvider).list();
      if (!mounted) return;
      setState(() {
        _connections = list;
        _loadingConnections = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingConnections = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _systemPrompt.dispose();
    _model.dispose();
    _temperature.dispose();
    super.dispose();
  }

  Future<void> _pickConnection() async {
    final current = _connections.where((c) => c.id == _connectionId).firstOrNull;
    final selected = await showPickerSheet<LlmConnection>(
      context,
      title: 'Connection',
      items: _connections,
      labelBuilder: (c) => c.name,
      selected: current,
      allowNone: true,
    );
    setState(() => _connectionId = selected?.id);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    final temperature = double.tryParse(_temperature.text.trim()) ?? 0.4;
    setState(() => _saving = true);
    final repo = ref.read(agentsRepositoryProvider);
    final description = _description.text.trim().isEmpty ? null : _description.text.trim();
    final model = _model.text.trim().isEmpty ? null : _model.text.trim();
    try {
      if (widget.agent == null) {
        await repo.create(
          name: name,
          description: description,
          systemPrompt: _systemPrompt.text,
          connectionId: _connectionId,
          model: model,
          temperature: temperature,
          autoContext: _autoContext,
          isDefault: _isDefault,
        );
      } else {
        await repo.update(
          widget.agent!.id,
          name: name,
          description: description,
          systemPrompt: _systemPrompt.text,
          connectionId: _connectionId,
          model: model,
          temperature: temperature,
          autoContext: _autoContext,
          isDefault: _isDefault,
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
    final connectionName = _connections.where((c) => c.id == _connectionId).firstOrNull?.name;

    return FormScreen(
      title: widget.agent == null ? 'New Agent' : 'Edit Agent',
      saving: _saving,
      onSave: _save,
      children: [
        LabeledField(label: 'Name', child: TextField(controller: _name)),
        LabeledField(label: 'Description', child: TextField(controller: _description)),
        LabeledField(
          label: 'System prompt',
          child: TextField(controller: _systemPrompt, minLines: 3, maxLines: 8),
        ),
        LabeledField(
          label: 'Connection',
          child: _loadingConnections
              ? const SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : GestureDetector(
                  onTap: _pickConnection,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          connectionName ?? 'None',
                          style: TextStyle(
                            color: connectionName == null ? colors.mutedForeground : null,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 18, color: colors.mutedForeground),
                    ],
                  ),
                ),
        ),
        LabeledField(
          label: 'Model override',
          child: TextField(
            controller: _model,
            decoration: const InputDecoration(hintText: 'Uses connection default if blank'),
          ),
        ),
        LabeledField(
          label: 'Temperature',
          child: TextField(
            controller: _temperature,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        LabeledField(
          label: 'Auto context',
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _autoContext,
            onChanged: (v) => setState(() => _autoContext = v),
            title: const Text('Automatically include workspace context'),
          ),
        ),
        LabeledField(
          label: 'Default agent',
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _isDefault,
            onChanged: (v) => setState(() => _isDefault = v),
            title: const Text('Use as the default agent'),
          ),
        ),
      ],
    );
  }
}
