import 'package:dio/dio.dart';

import '../storage/secure_store.dart';
import 'api_exception.dart';

/// The default deployment this app talks to. Overridable in Settings so the
/// same build works against a second server without a rebuild.
const kDefaultBaseUrl = 'https://hyperion.tail730ecb.ts.net';

/// Everything the web app reaches under a relative `/api` lives under this
/// suffix, so the mobile client points at the same origin plus the prefix.
String apiBaseUrl(String origin) => '${origin.replaceAll(RegExp(r'/+$'), '')}/api';

/// Thin wrapper over Dio that mirrors the request/response interceptors in
/// `frontend/src/lib/api.ts`: a bearer token and an `X-Workspace-Id` header on
/// every request, and a forced sign-out on 401.
class ApiClient {
  ApiClient({required SecureStore store, Dio? dio})
      // Dart forbids a private initialising formal on a named parameter, so
      // the assignment has to be spelled out.
      // ignore: prefer_initializing_formals
      : _store = store,
        dio = dio ?? Dio() {
    this.dio.options
      ..connectTimeout = const Duration(seconds: 20)
      ..receiveTimeout = const Duration(seconds: 60)
      ..sendTimeout = const Duration(seconds: 60);

    this.dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await _store.readToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              final workspaceId = await _store.readWorkspaceId();
              if (workspaceId != null) {
                options.headers['X-Workspace-Id'] = workspaceId;
              }
              handler.next(options);
            },
            onError: (error, handler) async {
              if (error.response?.statusCode == 401) {
                // The web app drops the token and hard-redirects to /login.
                // Here the token is dropped and listeners are told, so the
                // router can send the user to the login route.
                await _store.clearToken();
                _onUnauthorized?.call();
              }
              handler.next(error);
            },
          ),
        );
  }

  final Dio dio;
  final SecureStore _store;
  void Function()? _onUnauthorized;

  set onUnauthorized(void Function() callback) => _onUnauthorized = callback;

  /// Points the client at [origin] (a bare scheme+host, no `/api` suffix).
  void setOrigin(String origin) => dio.options.baseUrl = apiBaseUrl(origin);

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) =>
      _send(() => dio.get<T>(path, queryParameters: _clean(query)));

  Future<T> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) =>
      _send(() => dio.post<T>(
            path,
            data: body,
            queryParameters: _clean(query),
            options: headers == null ? null : Options(headers: headers),
          ));

  Future<T> patch<T>(String path, {Object? body}) =>
      _send(() => dio.patch<T>(path, data: body));

  Future<T> put<T>(String path, {Object? body}) =>
      _send(() => dio.put<T>(path, data: body));

  Future<T> delete<T>(String path, {Object? body}) =>
      _send(() => dio.delete<T>(path, data: body));

  /// Form-encoded POST — the login endpoint takes an OAuth2 password form
  /// rather than JSON.
  Future<T> postForm<T>(String path, Map<String, dynamic> fields) => _send(
        () => dio.post<T>(
          path,
          data: fields,
          options: Options(contentType: Headers.formUrlEncodedContentType),
        ),
      );

  Future<T> _send<T>(Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (error) {
      throw ApiException.from(error);
    }
  }

  /// Dio serialises a null query value as an empty string, which the backend
  /// then reads as a real filter. Dropping nulls keeps optional filters
  /// genuinely optional.
  static Map<String, dynamic>? _clean(Map<String, dynamic>? query) {
    if (query == null) return null;
    final cleaned = {
      for (final entry in query.entries)
        if (entry.value != null) entry.key: entry.value,
    };
    return cleaned.isEmpty ? null : cleaned;
  }
}
