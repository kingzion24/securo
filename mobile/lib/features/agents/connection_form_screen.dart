import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/form_screen.dart';
import '../../models/agent.dart';
import 'agents_screen.dart';

const _kConnectionKinds = ['ollama', 'openai', 'anthropic', 'openai_compatible'];

class ConnectionFormScreen extends ConsumerStatefulWidget {
  const ConnectionFormScreen({this.connection, super.key});
  final LlmConnection? connection;

  @override
  ConsumerState<ConnectionFormScreen> createState() => _ConnectionFormScreenState();
}

class _ConnectionFormScreenState extends ConsumerState<ConnectionFormScreen> {
  late final _name = TextEditingController(text: widget.connection?.name ?? '');
  late final _baseUrl = TextEditingController(text: widget.connection?.baseUrl ?? '');
  final _apiKey = TextEditingController();
  late final _defaultModel =
      TextEditingController(text: widget.connection?.defaultModel ?? '');
  late String _kind = widget.connection?.kind ?? _kConnectionKinds.first;
  late bool _isDefault = widget.connection?.isDefault ?? false;
  bool _saving = false;
  bool _testing = false;
  String? _testResult;

  @override
  void dispose() {
    _name.dispose();
    _baseUrl.dispose();
    _apiKey.dispose();
    _defaultModel.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    if (widget.connection == null) return;
    setState(() {
      _testing = true;
      _testResult = null;
    });
    try {
      final result =
          await ref.read(connectionsRepositoryProvider).test(widget.connection!.id);
      if (mounted) setState(() => _testResult = result.detail);
    } catch (error) {
      if (mounted) setState(() => _testResult = '$error');
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showAppToast(context, 'Enter a name', isError: true);
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(connectionsRepositoryProvider);
    final baseUrl = _baseUrl.text.trim().isEmpty ? null : _baseUrl.text.trim();
    final apiKey = _apiKey.text.trim().isEmpty ? null : _apiKey.text.trim();
    final model = _defaultModel.text.trim().isEmpty ? null : _defaultModel.text.trim();
    try {
      if (widget.connection == null) {
        await repo.create(
          name: name,
          kind: _kind,
          baseUrl: baseUrl,
          apiKey: apiKey,
          defaultModel: model,
          isDefault: _isDefault,
        );
      } else {
        await repo.update(
          widget.connection!.id,
          name: name,
          baseUrl: baseUrl,
          apiKey: apiKey,
          defaultModel: model,
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

    return FormScreen(
      title: widget.connection == null ? 'New Connection' : 'Edit Connection',
      saving: _saving,
      onSave: _save,
      children: [
        LabeledField(
          label: 'Name',
          child: TextField(controller: _name),
        ),
        LabeledField(
          label: 'Provider',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final kind in _kConnectionKinds)
                ChoiceChip(
                  label: Text(kind == 'openai_compatible' ? 'OpenAI-compatible' : kind),
                  selected: kind == _kind,
                  onSelected: widget.connection == null
                      ? (_) => setState(() => _kind = kind)
                      : null,
                ),
            ],
          ),
        ),
        LabeledField(
          label: 'Base URL',
          child: TextField(
            controller: _baseUrl,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(hintText: 'https://...'),
          ),
        ),
        LabeledField(
          label: widget.connection?.hasApiKey == true
              ? 'API key (configured — leave blank to keep)'
              : 'API key',
          child: TextField(controller: _apiKey, obscureText: true),
        ),
        LabeledField(
          label: 'Default model',
          child: TextField(controller: _defaultModel),
        ),
        LabeledField(
          label: 'Default connection',
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _isDefault,
            onChanged: (v) => setState(() => _isDefault = v),
            title: const Text('Use for new agents by default'),
          ),
        ),
        if (widget.connection != null) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _testing ? null : _test,
            icon: _testing
                ? const SizedBox(
                    width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.wifi_tethering, size: 16),
            label: const Text('Test connection'),
          ),
          if (_testResult != null) ...[
            const SizedBox(height: 8),
            Text(_testResult!, style: TextStyle(color: colors.mutedForeground)),
          ],
        ],
      ],
    );
  }
}
