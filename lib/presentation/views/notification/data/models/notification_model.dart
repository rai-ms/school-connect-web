class NotificationResponse {
  final String id;
  final String title;
  final String body;
  final String notificationType;
  final String? recipientUserId;
  final String? recipientRole;
  final String? recipientClassId;
  final String? senderUserId;
  final String? senderName;
  final String status;
  final bool isRead;
  final String? readAt;
  final String? dataPayload;
  final DateTime? createdAt;

  NotificationResponse({
    required this.id,
    required this.title,
    required this.body,
    required this.notificationType,
    this.recipientUserId,
    this.recipientRole,
    this.recipientClassId,
    this.senderUserId,
    this.senderName,
    this.status = 'PENDING',
    this.isRead = false,
    this.readAt,
    this.dataPayload,
    this.createdAt,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      notificationType: json['notificationType'] ?? 'CUSTOM',
      recipientUserId: json['recipientUserId'],
      recipientRole: json['recipientRole'],
      recipientClassId: json['recipientClassId'],
      senderUserId: json['senderUserId'],
      senderName: json['senderName'],
      status: json['status'] ?? 'PENDING',
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'],
      dataPayload: json['dataPayload'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  String get timeAgo {
    if (createdAt == null) return '';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }
}

class SendNotificationRequest {
  final String title;
  final String body;
  final String notificationType;
  final String? recipientUserId;
  final String? recipientRole;
  final String? recipientClassId;
  final String? dataPayload;

  SendNotificationRequest({
    required this.title,
    required this.body,
    required this.notificationType,
    this.recipientUserId,
    this.recipientRole,
    this.recipientClassId,
    this.dataPayload,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'notificationType': notificationType,
        if (recipientUserId != null) 'recipientUserId': recipientUserId,
        if (recipientRole != null) 'recipientRole': recipientRole,
        if (recipientClassId != null) 'recipientClassId': recipientClassId,
        if (dataPayload != null) 'dataPayload': dataPayload,
      };
}
