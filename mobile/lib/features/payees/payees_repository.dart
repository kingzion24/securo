import '../../core/api/api_client.dart';
import '../../models/payee.dart';

class PayeesRepository {
  PayeesRepository(this._api);
  final ApiClient _api;

  Future<List<Payee>> list() async {
    final data = await _api.get<List<dynamic>>('/payees');
    return data.map((e) => Payee.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Payee> create({
    required String name,
    String? type,
    String? notes,
    String? email,
    String? phone,
    String? address,
    String? website,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/payees',
      body: {
        'name': name,
        'type': ?type,
        'notes': ?notes,
        'email': ?email,
        'phone': ?phone,
        'address': ?address,
        'website': ?website,
      },
    );
    return Payee.fromJson(data);
  }

  Future<Payee> update(
    String id, {
    String? name,
    String? type,
    String? notes,
    String? email,
    String? phone,
    String? address,
    String? website,
  }) async {
    final data = await _api.patch<Map<String, dynamic>>(
      '/payees/$id',
      body: {
        'name': ?name,
        'type': ?type,
        'notes': ?notes,
        'email': ?email,
        'phone': ?phone,
        'address': ?address,
        'website': ?website,
      },
    );
    return Payee.fromJson(data);
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/payees/$id');
}
