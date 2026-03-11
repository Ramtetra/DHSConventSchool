class LoginResponse {

  final bool success;
  final String message;
  final UserData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {

    return LoginResponse(
      success: json['success'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {

  final String name;
  final String email;
  final String role;
  final String address;

  UserData({
    required this.name,
    required this.email,
    required this.role,
    required this.address,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {

    return UserData(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      address: json['address'],
    );
  }
}