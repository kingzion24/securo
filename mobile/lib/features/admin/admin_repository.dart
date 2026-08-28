import '../../core/api/api_client.dart';
import '../../models/admin_user.dart';

class AdminRepository {
  AdminRepository(this._api);
  final ApiClient _api;

  Future<List<AdminUser>> listUsers({String? search}) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/admin/users',
      query: {'search': search, 'limit': 200},
    );
    return (data['items'] as List<dynamic>)
        .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createUser({
    required String email,
    required String password,
    bool isSuperuser = false,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/admin/users',
      body: {'email': email, 'password': password, 'is_superuser': isSuperuser},
    );
  }

  Future<void> updateUser(
    String id, {
    String? email,
    String? password,
    bool? isActive,
    bool? isSuperuser,
  }) async {
    await _api.patch<Map<String, dynamic>>(
      '/admin/users/$id',
      body: {
        'email': ?email,
        'password': ?password,
        'is_active': ?isActive,
        'is_superuser': ?isSuperuser,
      },
    );
  }

  Future<void> deleteUser(String id) => _api.delete<dynamic>('/admin/users/$id');

  /// 404 (never configured) means "use the documented default" — callers
  /// pass their own fallback rather than this throwing.
  Future<String?> getSetting(String key) async {
    try {
      final data = await _api.get<Map<String, dynamic>>('/admin/settings/$key');
      return data['value'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> setSetting(String key, String value) => _api.patch<Map<String, dynamic>>(
        '/admin/settings/$key',
        body: {'value': value},
      );
}
