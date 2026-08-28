class Attachment {
  const Attachment({
    required this.id,
    required this.transactionId,
    required this.filename,
    required this.contentType,
    required this.size,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json['id'] as String,
        transactionId: json['transaction_id'] as String,
        filename: json['filename'] as String,
        contentType: json['content_type'] as String,
        size: json['size'] as int,
      );

  final String id;
  final String transactionId;
  final String filename;
  final String contentType;
  final int size;

  bool get isImage => contentType.startsWith('image/');
}
