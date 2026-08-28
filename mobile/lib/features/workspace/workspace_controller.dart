import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/providers.dart';
import '../../models/workspace.dart';
import '../auth/auth_controller.dart';

class WorkspaceRepository {
  WorkspaceRepository(this._api);
  final ApiClient _api;

  Future<List<Workspace>> list() async {
    final data = await _api.get<List<dynamic>>('/workspaces');
    return data
        .map((e) => Workspace.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Workspace> current() async {
    final data = await _api.get<Map<String, dynamic>>('/workspaces/current');
    return Workspace.fromJson(data);
  }

  Future<Map<String, int>> stats(String workspaceId) async {
    final data = await _api.get<Map<String, dynamic>>('/workspaces/$workspaceId/stats');
    return data.map((k, v) => MapEntry(k, v as int));
  }

  Future<Workspace> update(
    String workspaceId, {
    String? name,
    String? icon,
    String? color,
    String? defaultCurrency,
    String? locale,
    String? taxJurisdiction,
  }) async {
    final data = await _api.patch<Map<String, dynamic>>(
      '/workspaces/$workspaceId',
      body: {
        'name': ?name,
        'icon': ?icon,
        'color': ?color,
        'default_currency': ?defaultCurrency,
        'locale': ?locale,
        'tax_jurisdiction': ?taxJurisdiction,
      },
    );
    return Workspace.fromJson(data);
  }

  Future<List<WorkspaceMember>> members(String workspaceId) async {
    final data = await _api.get<List<dynamic>>('/workspaces/$workspaceId/members');
    return data
        .map((e) => WorkspaceMember.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> invite(
    String workspaceId, {
    required String email,
    String role = 'editor',
    String? password,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/workspaces/$workspaceId/members',
      body: {'email': email, 'role': role, 'password': ?password},
    );
  }

  Future<void> updateMemberRole(String workspaceId, String userId, String role) =>
      _api.patch<Map<String, dynamic>>(
        '/workspaces/$workspaceId/members/$userId',
        body: {'role': role},
      );

  Future<void> removeMember(String workspaceId, String userId) =>
      _api.delete<dynamic>('/workspaces/$workspaceId/members/$userId');

  Future<void> archive(String workspaceId) =>
      _api.post<Map<String, dynamic>>('/workspaces/$workspaceId/archive');
}

final workspaceRepositoryProvider = Provider<WorkspaceRepository>(
  (ref) => WorkspaceRepository(ref.watch(apiClientProvider)),
);

/// Every workspace the signed-in user can reach.
final workspacesProvider = FutureProvider<List<Workspace>>((ref) async {
  // Re-fetch on sign-in/out rather than serving another user's list.
  ref.watch(authControllerProvider.select((s) => s.status));
  return ref.watch(workspaceRepositoryProvider).list();
});

/// The workspace the app is currently acting as.
///
/// The server resolves this from the `X-Workspace-Id` header the API client
/// attaches, falling back to the user's default when the header is absent — so
/// asking the server is more reliable than reconstructing it locally.
final currentWorkspaceProvider = FutureProvider<Workspace>((ref) async {
  ref.watch(authControllerProvider.select((s) => s.status));
  ref.watch(activeWorkspaceIdProvider);
  return ref.watch(workspaceRepositoryProvider).current();
});

/// Bumped when the user switches workspace, to invalidate the caches above.
final activeWorkspaceIdProvider = StateProvider<String?>((ref) => null);

/// Switches workspace: persists the id so the interceptor picks it up, then
/// invalidates everything scoped to a workspace.
Future<void> switchWorkspace(Ref ref, String workspaceId) async {
  await ref.read(secureStoreProvider).writeWorkspaceId(workspaceId);
  ref.read(activeWorkspaceIdProvider.notifier).state = workspaceId;
}
