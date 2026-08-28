import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace.freezed.dart';
part 'workspace.g.dart';

enum WorkspaceRole {
  @JsonValue('owner')
  owner,
  @JsonValue('editor')
  editor,
  @JsonValue('viewer')
  viewer,
  @JsonValue('manager')
  manager;

  /// Viewers get a read-only interface: every create/edit affordance is hidden.
  bool get canEdit => this != WorkspaceRole.viewer;
}

@freezed
class Workspace with _$Workspace {
  const factory Workspace({
    required String id,
    required String name,

    /// Widened to a plain String on purpose, matching the web types: a
    /// workspace stored before the current kind list still has to render.
    required String kind,
    @Default(false) bool isArchived,
    required String defaultCurrency,
    String? locale,
    String? taxJurisdiction,
    String? icon,
    String? color,
    String? createdAt,
    String? createdByUserId,
    String? managedByUserId,
    WorkspaceRole? role,

    /// Modules this workspace shows. Resolved server-side — the app never
    /// decides this locally, or the two copies drift and the user sees a
    /// module the server thinks is off.
    @Default(<String>[]) List<String> enabledModules,
  }) = _Workspace;

  const Workspace._();

  factory Workspace.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFromJson(json);

  bool hasModule(String module) => enabledModules.contains(module);

  bool get canEdit => role?.canEdit ?? true;

  /// Workspace settings (rename, invite/remove members, archive) are gated
  /// tighter than general editing — an `editor` can edit financial data but
  /// not the workspace itself, only `owner`/`manager` can.
  bool get canManage => role == WorkspaceRole.owner || role == WorkspaceRole.manager;
}

@freezed
class WorkspaceMember with _$WorkspaceMember {
  const factory WorkspaceMember({
    required String id,
    required String userId,
    required String email,
    String? displayName,
    required WorkspaceRole role,
    String? joinedAt,
  }) = _WorkspaceMember;

  factory WorkspaceMember.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceMemberFromJson(json);
}
