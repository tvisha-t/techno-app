import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'report_screen.dart';
import 'sos_screen.dart';

// ─ Purple Aesthetic Color Palette ─────────────────────
const Color _darkPurple = Color(0xFF5B2D8E);
const Color _mediumPurple = Color(0xFF8A5C9C);
const Color _lightPurple = Color(0xFFE5D4F0);
const Color _accentPurple = Color(0xFF9C6FD6);
// ───────────────────────────────────────────────────

void main() {
  runApp(const SafeHaven());
}

// root widget to set up routing
class SafeHaven extends StatefulWidget {
  const SafeHaven({super.key});

  @override
  State<SafeHaven> createState() => _SafeHavenState();
}

class _SafeHavenState extends State<SafeHaven> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme(bool isOn) {
    setState(() {
      _themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeHaven',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[50],
        colorScheme: ColorScheme.fromSeed(
          seedColor: _darkPurple,
          primary: _darkPurple,
          secondary: _accentPurple,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _darkPurple,
            foregroundColor: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[900],
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _darkPurple,
          primary: _darkPurple,
          secondary: _accentPurple,
          brightness: Brightness.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _darkPurple,
            foregroundColor: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => MainShell(
          themeMode: _themeMode,
          onThemeToggle: _toggleTheme,
        ),
      },
    );
  }
}

// ─────────────────────────────────────────────
// MainShell: the persistent bottom nav bar wrapper
// we're just swapping out the body while keeping the bottom nav bar intact
// ─────────────────────────────────────────────
class MainShell extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<bool> onThemeToggle;

  const MainShell({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    HomeScreen(
      themeMode: widget.themeMode,
      onThemeToggle: widget.onThemeToggle,
    ),
    MapScreen(
      themeMode: widget.themeMode,
      onThemeToggle: widget.onThemeToggle,
    ),
    ReportScreen(
      themeMode: widget.themeMode,
      onThemeToggle: widget.onThemeToggle,
    ),
    SosScreen(
      themeMode: widget.themeMode,
      onThemeToggle: widget.onThemeToggle,
    ),
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
        selectedItemColor: _darkPurple,
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