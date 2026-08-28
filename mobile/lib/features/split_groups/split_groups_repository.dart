import '../../core/api/api_client.dart';
import '../../models/split_group.dart';

class SplitGroupsRepository {
  SplitGroupsRepository(this._api);
  final ApiClient _api;

  Future<List<SplitGroup>> list() async {
    final data = await _api.get<List<dynamic>>('/groups');
    return data
        .map((e) => SplitGroup.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
