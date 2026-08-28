import '../../core/api/api_client.dart';
import '../../models/loan.dart';

class LoansRepository {
  LoansRepository(this._api);
  final ApiClient _api;

  Future<List<Loan>> list() async {
    final data = await _api.get<List<dynamic>>('/loans');
    return data.map((e) => Loan.fromJson(e as Map<String, dynamic>)).toList();
  }
}
