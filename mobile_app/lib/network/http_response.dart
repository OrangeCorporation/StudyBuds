class GeneralResponse {
  final String status;
  final String message;

  GeneralResponse({required this.status, required this.message});

  factory GeneralResponse.fromJson(Map<String, dynamic> json) {
    return GeneralResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
