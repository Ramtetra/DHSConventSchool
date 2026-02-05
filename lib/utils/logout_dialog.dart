import 'package:flutter/material.dart';
import 'package:dhs/utils/session_manager.dart';

import '../screens/admin/login_screen.dart';

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    useRootNavigator: true, // 🔥 CRITICAL
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              debugPrint('YES clicked');

              // Close dialog (ROOT)
              Navigator.of(dialogContext, rootNavigator: true).pop();

              // Clear session
              await SessionManager.logout();
              debugPrint('Session cleared');

              if (!context.mounted) return;

              // Navigate to Login (ROOT)
              Navigator.of(context, rootNavigator: true)
                  .pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
