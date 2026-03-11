import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';
import '../responsemodel/login_response.dart';
import 'dio_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {

  final Dio dio = ref.read(dioProvider);

  return AuthRepository(dio);
});

final loginProvider =
FutureProvider.family<LoginResponse, Map<String, String>>((ref, data) async {

  final repo = ref.read(authRepositoryProvider);

  return repo.login(
    data["email"]!,
    data["password"]!,
    data["role"]!,
  );
});