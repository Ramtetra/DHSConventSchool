import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static final Dio dio=Dio(
   BaseOptions(
     baseUrl: dotenv.env['API_BASE_URL']!,
     connectTimeout: const Duration(seconds: 20),
     receiveTimeout: const Duration(seconds: 20),
     headers: {
       'Content-Type': 'application/json',
     },
   ),
  )..interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
  );
}