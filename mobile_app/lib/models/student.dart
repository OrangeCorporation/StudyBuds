class Student {
  final int id;
  final String firstName;
  final String lastName;
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
