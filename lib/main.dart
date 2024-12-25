import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ussaa/screens/intro_screen.dart';
import 'package:ussaa/services/database_service.dart';
import 'package:ussaa/services/notification_service.dart';

void main() async {
  runApp(const MyApp());
  /* Initialize Database */
  await AppDatabase.instance.database;
  /* Initialize the notification service */
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      home: SafeArea(child: IntroScreen()),
    );
  }
}
