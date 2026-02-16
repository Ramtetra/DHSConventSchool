import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../responsemodel/count_model.dart';
import '../services/admin_service.dart';
import 'dio_provider.dart';

final adminServiceProvider = Provider<AdminService>((ref) {
  final dio = ref.read(dioProvider);
  return AdminService(dio);
});

final countProvider = FutureProvider<CountModel>((ref) async {
  final service = ref.read(adminServiceProvider);
  return service.getCounts();
});
