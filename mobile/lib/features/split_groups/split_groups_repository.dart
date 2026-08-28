import '../../core/api/api_client.dart';
import '../../models/group_member.dart';
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

  Future<void> create({
    required String name,
    String kind = 'social',
    String defaultCurrency = 'USD',
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/groups',
      body: {'name': name, 'kind': kind, 'default_currency': defaultCurrency},
    );
  }

  Future<void> update(String id, {String? name}) async {
    await _api.patch<Map<String, dynamic>>('/groups/$id', body: {'name': ?name});
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/groups/$id');

  Future<List<GroupMember>> members(String groupId) async {
    final data = await _api.get<List<dynamic>>('/groups/$groupId/members');
    return data
        .map((e) => GroupMember.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addMember(String groupId, {required String name, String? email}) async {
    await _api.post<Map<String, dynamic>>(
      '/groups/$groupId/members',
      body: {'name': name, 'email': ?email},
    );
  }

  Future<void> removeMember(String groupId, String memberId) =>
      _api.delete<dynamic>('/groups/$groupId/members/$memberId');

  Future<GroupBalances> balances(String groupId) async {
    final data = await _api.get<Map<String, dynamic>>('/groups/$groupId/balances');
    return GroupBalances.fromJson(data);
  }
}
