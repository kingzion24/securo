import '../../core/api/api_client.dart';
import '../../models/agent.dart';

class AgentsRepository {
  AgentsRepository(this._api);
  final ApiClient _api;

  Future<List<Agent>> list() async {
    final data = await _api.get<List<dynamic>>('/agents');
    return data.map((e) => Agent.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> create({
    required String name,
    String? description,
    String systemPrompt = '',
    String? connectionId,
    String? model,
    double temperature = 0.4,
    bool autoContext = true,
    bool isDefault = false,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/agents',
      body: {
        'name': name,
        'description': ?description,
        'system_prompt': systemPrompt,
        'connection_id': ?connectionId,
        'model': ?model,
        'temperature': temperature,
        'auto_context': autoContext,
        'is_default': isDefault,
      },
    );
  }

  Future<void> update(
    String id, {
    String? name,
    String? description,
    String? systemPrompt,
    String? connectionId,
    String? model,
    double? temperature,
    bool? autoContext,
    bool? isDefault,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/agents/$id',
      body: {
        'name': ?name,
        'description': ?description,
        'system_prompt': ?systemPrompt,
        'connection_id': ?connectionId,
        'model': ?model,
        'temperature': ?temperature,
        'auto_context': ?autoContext,
        'is_default': ?isDefault,
      },
    );
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/agents/$id');
}

class ConnectionsRepository {
  ConnectionsRepository(this._api);
  final ApiClient _api;

  Future<List<LlmConnection>> list() async {
    final data = await _api.get<List<dynamic>>('/agents/connections');
    return data.map((e) => LlmConnection.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> create({
    required String name,
    required String kind,
    String? baseUrl,
    String? apiKey,
    String? defaultModel,
    bool isDefault = false,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/agents/connections',
      body: {
        'name': name,
        'kind': kind,
        'base_url': ?baseUrl,
        'api_key': ?apiKey,
        'default_model': ?defaultModel,
        'is_default': isDefault,
      },
    );
  }

  Future<void> update(
    String id, {
    String? name,
    String? baseUrl,
    String? apiKey,
    String? defaultModel,
    bool? isDefault,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/agents/connections/$id',
      body: {
        'name': ?name,
        'base_url': ?baseUrl,
        'api_key': ?apiKey,
        'default_model': ?defaultModel,
        'is_default': ?isDefault,
      },
    );
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/agents/connections/$id');

  Future<ConnectionTestResult> test(String id) async {
    final data = await _api.post<Map<String, dynamic>>('/agents/connections/$id/test');
    return ConnectionTestResult.fromJson(data);
  }
}
