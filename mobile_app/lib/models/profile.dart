class Profile {
  final int? studentId;
  final String firstName;
  final String lastName;
  final int telegramAccount;

  Profile(
      {this.studentId,
      required this.firstName,
      required this.lastName,
      required this.telegramAccount});

  static List<Profile> fromJsonList(List<dynamic> jsonArray) {
    List<Profile> res =
        jsonArray.map((model) => Profile.fromJson(model)).toList();
    return res;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.studentId,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'telegramAccount': this.telegramAccount
    };
  }

  // Factory constructor to create a Profile from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    int parseInt(String? value, [int defaultValue = 0]) {
      return int.tryParse(value ?? '') ?? defaultValue;
    }

    return Profile(
      studentId: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      telegramAccount: json['telegram_account'],
    );
  }
}
