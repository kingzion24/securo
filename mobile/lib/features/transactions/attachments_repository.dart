import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../models/attachment.dart';

class AttachmentsRepository {
  AttachmentsRepository(this._api);
  final ApiClient _api;

  Future<List<Attachment>> list(String transactionId) async {
    final data = await _api.get<List<dynamic>>('/transactions/$transactionId/attachments');
    return data.map((e) => Attachment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> upload(String transactionId, String filePath, String filename) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filename),
    });
    await _api.dio.post<Map<String, dynamic>>(
      '/transactions/$transactionId/attachments',
      data: form,
    );
  }

  Future<void> delete(String transactionId, String attachmentId) =>
      _api.delete<dynamic>('/transactions/$transactionId/attachments/$attachmentId');
}
