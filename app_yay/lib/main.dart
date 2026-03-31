import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'report_screen.dart';
import 'sos_screen.dart';

void main() {
  runApp(const SafeHaven());
}

// root widget to set up routing
class SafeHaven extends StatelessWidget {
  const SafeHaven({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeHaven',
      debugShowCheckedModeBanner: false, 

      // app-wide color theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B2D8E), // deep purple
          primary: const Color(0xFF5B2D8E),
          secondary: const Color(0xFF9C6FD6), // lighter purple
        ),
        useMaterial3: true,
      ),

      initialRoute: '/login',

      // use to nagivate: Navigator.pushNamed(context, '/home')
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainShell(), // MainShell holds the bottom nav bar
      },
    );
  }
}

// ─────────────────────────────────────────────
// MainShell: the persistent bottom nav bar wrapper
// we're just swapping out the body while keeping the bottom nav bar intact
// ─────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MapScreen(),
    ReportScreen(),
    SosScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // show matching index screen
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        //rebuild every time user taps a new tab
        onTap: (index) => setState(() => _currentIndex = index),

        type: BottomNavigationBarType.fixed, 
        selectedItemColor: const Color(0xFF5B2D8E),
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.sos), label: 'SOS'),
        ],
      ),
    );
  }
}