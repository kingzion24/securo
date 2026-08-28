import '../../core/api/api_client.dart';
import '../../models/payee.dart';

class PayeesRepository {
  PayeesRepository(this._api);
  final ApiClient _api;

  Future<List<Payee>> list() async {
    final data = await _api.get<List<dynamic>>('/payees');
    return data.map((e) => Payee.fromJson(e as Map<String, dynamic>)).toList();
  }
}
