import 'dart:convert';

import '../../core/api/api_client.dart';
import '../../models/agent_conversation.dart';

class ConversationsRepository {
  ConversationsRepository(this._api);
  final ApiClient _api;

  Future<List<AgentConversation>> list({String? agentId}) async {
    final data = await _api.get<List<dynamic>>(
      '/agents/conversations',
      query: {'agent_id': ?agentId},
    );
    return data
        .map((e) => AgentConversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AgentMessage>> messages(String conversationId) async {
    final data =
        await _api.get<List<dynamic>>('/agents/conversations/$conversationId/messages');
    return data.map((e) => AgentMessage.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> rename(String conversationId, String title) => _api.patch<Map<String, dynamic>>(
        '/agents/conversations/$conversationId',
        body: {'title': title},
      );

  Future<void> delete(String conversationId) =>
      _api.delete<dynamic>('/agents/conversations/$conversationId');

  /// Sends a message to [agentId] and streams the reply. The server frames
  /// each event as `event: <type>\ndata: <json>\n\n`; this decodes the raw
  /// byte stream incrementally (so a UTF-8 sequence or an SSE frame split
  /// across two network chunks still parses correctly) and yields one
  /// [ChatEvent] per complete frame.
  Stream<ChatEvent> streamChat(
    String agentId, {
    required String content,
    String? conversationId,
    String channel = 'web',
  }) async* {
    final byteStream = await _api.postEventStream(
      '/agents/$agentId/chat',
      body: {
        'content': content,
        'conversation_id': ?conversationId,
        'channel': channel,
      },
    );

    var buffer = '';
    await for (final chunk in byteStream.transform(utf8.decoder)) {
      buffer += chunk;
      while (true) {
        final frameEnd = buffer.indexOf('\n\n');
        if (frameEnd == -1) break;
        final frame = buffer.substring(0, frameEnd);
        buffer = buffer.substring(frameEnd + 2);
        final event = _parseFrame(frame);
        if (event != null) yield event;
      }
    }
  }

  ChatEvent? _parseFrame(String frame) {
    String? eventType;
    final dataLines = <String>[];
    for (final line in frame.split('\n')) {
      if (line.startsWith('event:')) {
        eventType = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        dataLines.add(line.substring(5).trim());
      }
    }
    if (eventType == null || dataLines.isEmpty) return null;
    try {
      final data = jsonDecode(dataLines.join('\n')) as Map<String, dynamic>;
      return ChatEvent.fromSse(eventType, data);
    } catch (_) {
      return null;
    }
  }
}
