import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/admin/splash_screen.dart';

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "assets/.env");
    debugPrint(".env loaded successfully");
  } catch (e) {
    debugPrint("Error loading .env: $e");
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DHS',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF005B85),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.lato().fontFamily,
        textTheme: GoogleFonts.latoTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF005B85),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const SplashScreen(), // 🔥 Always splash first
    );
  }
}
