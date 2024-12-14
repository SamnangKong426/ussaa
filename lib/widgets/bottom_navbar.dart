// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:ussaa/models/task_model.dart';
// import 'package:ussaa/screens/calendar_screen.dart';
// import 'package:ussaa/screens/profile_screen.dart';
// import 'package:ussaa/screens/task_screen.dart';
// import 'package:ussaa/widgets/new_task.dart';
// // import 'package:ussaa/widgets/task_list.dart';

// class BottomNavBar extends StatefulWidget {
//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
//         child: GNav(
//           rippleColor: Colors.grey[300]!,
//           hoverColor: Colors.grey[100]!,
//           gap: 8,
//           activeColor: Colors.black,
//           iconSize: 24,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           duration: const Duration(milliseconds: 400),
//           tabBackgroundColor: Colors.grey[100]!,
//           color: Colors.black,
//           tabs: const [
//             GButton(
//               icon: LineIcons.home,
//               text: 'Tasks',
//             ),
//             GButton(
//               icon: LineIcons.calendar,
//               text: 'Calendar',
//             ),
//             GButton(
//               icon: LineIcons.user,
//               text: 'Profile',
//             ),
//           ],
//           selectedIndex: _selectedIndex,
//           onTabChange: (index) {
//             setState(() {
//               _selectedIndex = index;
//             });
//           },
//         ),
//       ),
    
//     );
//   }

// }
