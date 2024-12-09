

class Group {
  final int? id;
  final String name;
  final String course;
  final String description;
  final int members;
  final bool isPublic;
  final String telegramLink;
  final int studentId;
  final String? status;

  Group({
    this.id,
    required this.name,
    required this.course,
    required this.description,
    required this.members,
    required this.isPublic,
    required this.telegramLink,
    required this.studentId,
    this.status
  });

  // Static method to parse a JSON string into a list of Group instances
  static List<Group> fromJsonList(List<dynamic> jsonArray) {
    print(jsonArray);
    List<Group> res = jsonArray.map((model) => Group.fromJson(model)).toList();
    return res;
  }

  Map<String, dynamic> toJson(){
      return {
        'id': this.id,
        'name': this.name,
        'description': this.description,
        'course': this.course,
        'isPublic': this.isPublic,
        'membersLimit': this.members,
        'telegramLink': this.telegramLink,
        'studentId': 123,
      };
    }
  // Factory constructor to create a Group from JSON
  factory Group.fromJson(Map<String, dynamic> json) {

    int parseInt(String? value, [int defaultValue = 0]) {
      return int.tryParse(value ?? '') ?? defaultValue;
    }

    return Group(
      id: json['id'],
      name: json['name'] ?? 'No Name',
      course: json['course'] ?? 'No Course',
      description: json['description'] ?? 'No Description',
      members: parseInt(json['member_count']),
      isPublic: json['is_public'] == true,
      studentId: parseInt(json['student_id']),
      telegramLink: json['telegram_link'] ?? '',
      status: json['status'] ?? null,
    );
  }
}
