import 'package:hive/hive.dart';

part 'student.g.dart'; // This file will be generated

@HiveType(typeId: 0) // Assign a unique typeId for this model
class Student extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final int? telegramId;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.telegramId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      telegramId: json['telegram_account'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'telegram_account': telegramId,
    };
  }
}
