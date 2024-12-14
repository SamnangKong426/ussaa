import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ussaa/screens/intro_screen.dart';
import 'package:ussaa/services/notification_service.dart';

void main() async {
  /* Initialize the notification service */
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  runApp(const MyApp());
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
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      // home: SafeArea(child: IntroScreen()),
      home: SafeArea(child: IntroScreen()),
    );
  }
}
