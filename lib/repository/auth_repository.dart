import 'package:dio/dio.dart';

import '../responsemodel/login_response.dart';

class AuthRepository {

  final Dio dio;

  AuthRepository(this.dio);

  Future<LoginResponse> login(
      String email,
      String password,
      String role,
      ) async {

    final body = {
      "Email": email,
      "Password": password,
      "Role": role
    };

    print("REQUEST URL: ${dio.options.baseUrl}/api/Auth/Login");
    print("REQUEST BODY: $body");

    final response = await dio.post(
      "/api/Auth/Login",
      data: body,
    );

    print("RESPONSE DATA: ${response.data}");

    return LoginResponse.fromJson(response.data);
  }
}