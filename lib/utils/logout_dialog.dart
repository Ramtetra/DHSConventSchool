import 'package:flutter/material.dart';
import 'package:dhs/utils/session_manager.dart';

import '../screens/admin/login_screen.dart';

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                debugPrint('YES clicked');

                // Close dialog first
                Navigator.of(dialogContext, rootNavigator: true).pop();

                // 🔥 SAFETY DELAY
                await Future.delayed(const Duration(milliseconds: 100));

                // Clear session safely
                await SessionManager.logout();
                debugPrint('Session cleared');

                // ✅ Navigate to LoginScreen using dialogContext (always valid)
                Navigator.of(dialogContext, rootNavigator: true)
                    .pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              } catch (e, stack) {
                debugPrint('LOGOUT ERROR: $e');
                debugPrint('STACK: $stack');
              }
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

