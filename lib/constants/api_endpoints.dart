// lib/core/constants/api_endpoints.dart

class ApiEndpoints {
  // Base URL - should be loaded from environment/config
  static const String baseUrl = 'http://dshschool-001-site1.mtempurl.com//api';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  // Student Endpoints
  static const String studentBase = '/api/student';
  static const String addStudent = '/api/admin/add-student';
  static const String getAllStudents = '/api/Admin/GetAllStudent';
  static const String getStudentById = '/api/student/{id}';
  static const String getStudentsByClass = '/api/student/{id}';
  static const String updateStudent = '/api/student/{id}';
  static const String deleteStudent = '/api/student/{id}';
  static const String getStudentAttendance = '/api/student/{id}/attendance';
  static const String getStudentHomework = '/api/student/{id}/homework';
  static const String getStudentTimetable = '/api/student/{id}/timetable';
  static const String getStudentResults = '/api/student/{id}/results';

  // Teacher Endpoints
  static const String teacherBase = '/api/teacher';
  static const String addTeacher = '/api/admin/add-teacher';
  static const String getAllTeachers = '/api/Admin/GetAllTeacher';
  static const String getTeacherById = '/api/teacher/{id}';
  static const String updateTeacher = '/api/teacher/{id}';
  static const String deleteTeacher = '/api/teacher/{id}';

  // Admin Endpoints
  static const String adminBase = '/api/admin';
  static const String dashboard = '/api/admin/dashboard';
  static const String getStats = '/api/admin/stats';
  static const String getUsers = '/api/admin/users';
  static const String updateUserStatus = '/api/admin/users/{id}/status';

  // Attendance Endpoints
  static const String attendanceCount= '/api/Attendence/AttendenceCount';
  static const String markAttendance = '/api/attendance/mark';
  static const String getAttendanceByDate = '/api/attendance/date/{date}';
  static const String getAttendanceByStudent = '/api/attendance/student/{studentId}';
  static const String getAttendanceByClass = '/api/attendance/class/{classId}';

  // Homework Endpoints
  static const String homeworkBase = '/api/homework';
  static const String addHomework = '/api/homework/add';
  static const String getHomework = '/api/homework';
  static const String getHomeworkByClass = '/api/homework/class/{classId}';
  static const String getHomeworkByStudent = '/api/homework/student/{studentId}';
  static const String submitHomework = '/api/homework/{id}/submit';
  static const String updateHomework = '/api/homework/{id}';
  static const String deleteHomework = '/api/homework/{id}';

  // Timetable Endpoints
  static const String timetableBase = '/api/timetable';
  static const String getTimetable = '/api/timetable';
  static const String getTimetableByClass = '/api/timetable/class/{classId}';
  static const String getTimetableByTeacher = '/api/timetable/teacher/{teacherId}';
  static const String createTimetable = '/api/timetable/create';
  static const String updateTimetable = '/api/timetable/{id}';
  static const String deleteTimetable = '/api/timetable/{id}';

  // Exam Endpoints
  static const String examBase = '/api/exam';
  static const String getExams = '/api/exam';
  static const String getExamById = '/api/exam/{id}';
  static const String createExam = '/api/exam/create';
  static const String updateExam = '/api/exam/{id}';
  static const String deleteExam = '/api/exam/{id}';
  static const String getExamResults = '/api/exam/{id}/results';
  static const String publishResults = '/api/exam/{id}/publish';

  // Result Endpoints
  static const String resultBase = '/api/result';
  static const String getResults = '/api/result';
  static const String getResultByStudent = '/api/result/student/{studentId}';
  static const String getResultByExam = '/api/result/exam/{examId}';
  static const String addResult = '/api/result/add';
  static const String updateResult = '/api/result/{id}';

  // Notification Endpoints
  static const String notificationBase = '/api/notification';
  static const String getNotifications = '/api/notification';
  static const String markAsRead = '/api/notification/{id}/read';
  static const String deleteNotification = '/api/notification/{id}';
  static const String sendNotification = '/api/notification/send';

  // Profile Endpoints
  static const String profileBase = '/api/profile';
  static const String getProfile = '/api/profile';
  static const String updateProfile = '/api/profile/update';
  static const String changePassword = '/api/profile/change-password';
  static const String uploadAvatar = '/api/profile/upload-avatar';

  // Helper method to replace path parameters
  static String replacePathParams(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}