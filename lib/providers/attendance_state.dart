import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_endpoints.dart';
import '../models/attendance_model.dart';
import '../models/attendance_model/attendance_count.dart';
import '../network/dio_client.dart';

// State class for attendance
class AttendanceState {
  final AttendanceCount? attendanceCount;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  AttendanceState({
    this.attendanceCount,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AttendanceState copyWith({
    AttendanceCount? attendanceCount,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AttendanceState(
      attendanceCount: attendanceCount ?? this.attendanceCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// Provider for attendance state
final attendanceProvider = StateNotifierProvider<AttendanceNotifier, AttendanceState>(
      (ref) => AttendanceNotifier(ref.read(dioProvider)),
);

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final Dio _dio;

  AttendanceNotifier(this._dio) : super(AttendanceState());

  // Fetch attendance count
  Future<void> fetchAttendanceCount() async {
    // Set loading state
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      final response = await _dio.get(ApiEndpoints.attendanceCount);

      if (response.statusCode == 200) {
        final attendanceResponse = AttendanceResponse.fromJson(response.data);

        if (attendanceResponse.success && attendanceResponse.data != null) {
          state = state.copyWith(
            attendanceCount: attendanceResponse.data,
            isLoading: false,
            isSuccess: true,
            errorMessage: null,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: attendanceResponse.message,
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Failed to load attendance data',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Receive timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: 'An unexpected error occurred',
      );
    }
  }

  // Refresh data
  Future<void> refreshAttendance() async {
    await fetchAttendanceCount();
  }
}