import 'dart:convert';
import 'dart:ffi';

class Group {
  final String name;
  final String course;
  final String description;
  final int members;
  final bool isPublic;

  Group({
    required this.name,
    required this.course,
    required this.description,
    required this.members,
    required this.isPublic,
  });

  // Static method to parse a JSON string into a list of Group instances
  static List<Group> fromJsonList(List<dynamic> jsonArray) {
    print("qui");
    print(jsonArray);
    List<Group> res = jsonArray.map((model) => Group.fromJson(model)).toList();
    print("qui");
    return res;
  }

  // Factory constructor to create a Group from JSON
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['name'] ?? 'No Name',
      course: json['course'] ?? 'No Course',
      description: json['description'] ?? 'No Description',
      members: (json['member_count'] as int?) ?? 0, // Safe casting
      isPublic: (json['is_public'] as bool?) ?? false, // Safe casting
    );
  }
}
