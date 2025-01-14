import 'package:study_buds/models/student.dart';

class Group {
  final int? id;
  final String name;
  final String description;
  final String course;
  final bool isPublic;
  final String? telegramLink;
  final int? ownerId;
  final int? membersLimit;
  final int membersCount;
  final List<Student>? members;
  final String joinRequestStatus;

  Group({
    this.id,
    required this.name,
    required this.description,
    required this.course,
    required this.isPublic,
    required this.telegramLink,
    required this.ownerId,
    required this.membersLimit,
    this.membersCount = 1,
    this.joinRequestStatus = '',
    required this.members,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      course: json['course'] ?? '',
      isPublic: json['isPublic'],
      telegramLink: json['telegramLink'],
      ownerId: json['ownerId'],
      joinRequestStatus: json['requestStatus'] ?? '',
      membersLimit: json['membersLimit'],
      membersCount: json['membersCount'],
      members: json['members'] != null
          ? (json['members'] as List<dynamic>)
              .map((member) => Student.fromJson(member))
              .toList()
          : [],
    );
  }

  static List<Group> fromJsonList(List<dynamic> jsonArray) {
    return jsonArray.map((model) => Group.fromJson(model)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'course': course,
      'isPublic': isPublic,
      'telegramLink': telegramLink,
      'ownerId': 123,
      'membersLimit': membersLimit,
      'membersCount': membersCount,
      'members': members != null
          ? members?.map((member) => member.toJson()).toList()
          : [],
    };
  }
}
