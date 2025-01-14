class NotificationModel {
  final int id;
  final int studentId;
  final int joinRequestId;
  final String message;
  final DateTime createdAt;
  final String notificationType;
  final String joinRequestStatus;

  NotificationModel({
    required this.id,
    required this.studentId,
    required this.joinRequestId,
    required this.message,
    required this.createdAt,
    required this.notificationType,
    required this.joinRequestStatus,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      studentId: json['studentId'],
      joinRequestId: json['joinRequestId'],
      notificationType: json['notificationType'] ?? ' ',
      message: json['message'] ?? ' ',
      createdAt: DateTime.parse(json['createdAt']),
      joinRequestStatus: json['joinRequestStatus'] ?? ' ',
    );
  }

  static List<NotificationModel> fromJsonList(List<dynamic> jsonArray) {
    return jsonArray.map((model) => NotificationModel.fromJson(model)).toList();
  }
}
