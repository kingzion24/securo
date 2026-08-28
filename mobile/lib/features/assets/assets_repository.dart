import '../../core/api/api_client.dart';
import '../../models/asset.dart';

class AssetsRepository {
  AssetsRepository(this._api);
  final ApiClient _api;

  Future<List<Asset>> list() async {
    final data = await _api.get<List<dynamic>>('/assets');
    return data.map((e) => Asset.fromJson(e as Map<String, dynamic>)).toList();
  }
}
