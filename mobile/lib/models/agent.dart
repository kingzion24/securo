class Agent {
  const Agent({
    required this.id,
    required this.name,
    this.description,
    required this.systemPrompt,
    this.connectionId,
    this.model,
    required this.temperature,
    required this.autoContext,
    required this.isDefault,
    required this.isArchived,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        systemPrompt: json['system_prompt'] as String? ?? '',
        connectionId: json['connection_id'] as String?,
        model: json['model'] as String?,
        temperature: (json['temperature'] as num?)?.toDouble() ?? 0.4,
        autoContext: json['auto_context'] as bool? ?? true,
        isDefault: json['is_default'] as bool? ?? false,
        isArchived: json['is_archived'] as bool? ?? false,
      );

  final String id;
  final String name;
  final String? description;
  final String systemPrompt;
  final String? connectionId;
  final String? model;
  final double temperature;
  final bool autoContext;
  final bool isDefault;
  final bool isArchived;
}

class LlmConnection {
  const LlmConnection({
    required this.id,
    required this.name,
    required this.kind,
    this.baseUrl,
    this.defaultModel,
    required this.isDefault,
    required this.hasApiKey,
  });

  factory LlmConnection.fromJson(Map<String, dynamic> json) => LlmConnection(
        id: json['id'] as String,
        name: json['name'] as String,
        kind: json['kind'] as String,
        baseUrl: json['base_url'] as String?,
        defaultModel: json['default_model'] as String?,
        isDefault: json['is_default'] as bool? ?? false,
        hasApiKey: json['has_api_key'] as bool? ?? false,
      );

  final String id;
  final String name;
  final String kind;
  final String? baseUrl;
  final String? defaultModel;
  final bool isDefault;
  final bool hasApiKey;
}

class ConnectionTestResult {
  const ConnectionTestResult({required this.ok, required this.detail, this.models});

  factory ConnectionTestResult.fromJson(Map<String, dynamic> json) => ConnectionTestResult(
        ok: json['ok'] as bool? ?? false,
        detail: json['detail'] as String? ?? '',
        models: (json['models'] as List?)?.cast<String>(),
      );

  final bool ok;
  final String detail;
  final List<String>? models;
}
