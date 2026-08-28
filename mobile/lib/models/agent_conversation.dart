class AgentConversation {
  const AgentConversation({
    required this.id,
    required this.agentId,
    required this.channel,
    this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AgentConversation.fromJson(Map<String, dynamic> json) => AgentConversation(
        id: json['id'] as String,
        agentId: json['agent_id'] as String,
        channel: json['channel'] as String? ?? 'web',
        title: json['title'] as String?,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
      );

  final String id;
  final String agentId;
  final String channel;
  final String? title;
  final String createdAt;
  final String updatedAt;
}

class AgentMessage {
  const AgentMessage({
    required this.id,
    required this.role,
    required this.ordinal,
    this.content,
    this.toolCalls,
    this.toolResult,
    required this.createdAt,
  });

  factory AgentMessage.fromJson(Map<String, dynamic> json) => AgentMessage(
        id: json['id'] as String,
        role: json['role'] as String,
        ordinal: json['ordinal'] as int? ?? 0,
        content: json['content'] as String?,
        toolCalls: (json['tool_calls'] as List?)?.cast<Map<String, dynamic>>(),
        toolResult: json['tool_result'] as Map<String, dynamic>?,
        createdAt: json['created_at'] as String,
      );

  final String id;

  /// `user`, `assistant`, or `tool`.
  final String role;
  final int ordinal;
  final String? content;
  final List<Map<String, dynamic>>? toolCalls;
  final Map<String, dynamic>? toolResult;
  final String createdAt;
}

/// One frame of the agent chat SSE stream — mirrors the backend's
/// `ExecutorEvent` union (`backend/app/agents/runtime/executor.py`).
class ChatEvent {
  const ChatEvent({
    required this.type,
    this.text,
    this.toolName,
    this.toolArgs,
    this.toolResult,
    this.conversationId,
    this.errorMessage,
  });

  factory ChatEvent.fromSse(String eventType, Map<String, dynamic> data) => ChatEvent(
        type: eventType,
        text: data['text'] as String?,
        toolName: data['tool_name'] as String?,
        toolArgs: data['tool_args'] as Map<String, dynamic>?,
        toolResult: data['tool_result'] as Map<String, dynamic>?,
        conversationId: data['conversation_id'] as String?,
        errorMessage: data['error_message'] as String?,
      );

  /// `conversation`, `text_delta`, `tool_call`, `tool_result`, `citation`,
  /// `error`, or `done`.
  final String type;
  final String? text;
  final String? toolName;
  final Map<String, dynamic>? toolArgs;
  final Map<String, dynamic>? toolResult;
  final String? conversationId;
  final String? errorMessage;
}
