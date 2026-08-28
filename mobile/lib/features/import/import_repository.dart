import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../models/import_log.dart';

class ImportPreview {
  const ImportPreview({
    required this.transactions,
    required this.detectedFormat,
    this.parseError,
    this.warnings = const [],
  });

  factory ImportPreview.fromJson(Map<String, dynamic> json) => ImportPreview(
        transactions:
            (json['transactions'] as List).cast<Map<String, dynamic>>(),
        detectedFormat: json['detected_format'] as String? ?? 'unknown',
        parseError: json['parse_error'] as String?,
        warnings: (json['warnings'] as List?)?.cast<String>() ?? const [],
      );

  final List<Map<String, dynamic>> transactions;
  final String detectedFormat;
  final String? parseError;
  final List<String> warnings;
}

class ImportRepository {
  ImportRepository(this._api);
  final ApiClient _api;

  Future<List<ImportLog>> logs() async {
    final data = await _api.get<List<dynamic>>('/import-logs');
    return data
        .map((e) => ImportLog.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ImportPreview> preview(String filePath, String filename) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filename),
    });
    final data = await _api.dio
        .post<Map<String, dynamic>>('/transactions/import/preview', data: form);
    return ImportPreview.fromJson(data.data!);
  }

  Future<int> confirm({
    required String accountId,
    required List<Map<String, dynamic>> transactions,
    required String filename,
    required String detectedFormat,
  }) async {
    final result = await _api.post<Map<String, dynamic>>(
      '/transactions/import',
      body: {
        'account_id': accountId,
        'transactions': transactions,
        'filename': filename,
        'detected_format': detectedFormat,
      },
    );
    return result['imported'] as int? ?? transactions.length;
  }
}
