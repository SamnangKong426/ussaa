import 'package:flutter/material.dart';
import 'package:ussaa/services/notification_service.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          NotificationService.showNotification(
            title: 'Timer Notification',
            body: 'This is a notification from the Timer Screen',
          );
        },
        child: const Text('Show Notification'),
      ),
    );
  }
}
