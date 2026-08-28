import '../../core/api/api_client.dart';
import '../../models/account.dart';

class AccountsRepository {
  AccountsRepository(this._api);

  final ApiClient _api;

  Future<List<Account>> list({bool includeClosed = false}) async {
    final data = await _api.get<List<dynamic>>(
      '/accounts',
      query: {'include_closed': includeClosed},
    );
    return data
        .map((e) => Account.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
