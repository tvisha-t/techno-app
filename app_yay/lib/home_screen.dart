import 'package:flutter/material.dart';
import 'city_detail_screen.dart';
import 'widgets/safe_haven_logo.dart';

// note: i hardcoded placeholder city data for now so there's something to show
// todo: replace w/ real data from crime API
// each city has a map & has a namme, score (0–100), news blurb, and safety level label
const List<Map<String, dynamic>> _placeholderCities = [
  {
    'name': 'minneapolis',
    'score': 62,
    'news': 'downtown patrol increased near UMN campus this week.',
    'level': 'moderate',
  },
  {
    'name': 'new haven',
    'score': 71,
    'news': 'there was a new community safety initiave launched recently',
    'level': 'generally safe...',
  },
  {
    'name': 'chicagoooo',
    'score': 38,
    'news': 'more incident reports near transit hubs this month',
    'level': 'exercise caution...',
  },
];

class HomeScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<bool> onThemeToggle;

  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ─ Purple Aesthetic Color Palette ─────────────────────
const Color _darkPurple = Color(0xFF5B2D8E);
const Color _mediumPurple = Color(0xFF8A5C9C);
const Color _lightPurple = Color(0xFFE5D4F0);
const Color _accentPurple = Color(0xFF9C6FD6);
// ───────────────────────────────────────────────────

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

    // city cards on dashbord starts w. the ones above
    // start w/ placeholder data
    // TODO: allow users to add & remove cities
  List<Map<String, dynamic>> _cities = List.from(_placeholderCities);

  // user types city name & presses +
  void _addCity(String name) {
    if (name.trim().isEmpty) return;
    setState(() {
      _cities.add({
        'name': name.trim(),
        'score': 50, // placeholder
        'news': 'safety data loading...', // placeholder, should be filled w/ api
        'level': 'unknown...',
      });
    });
    _searchController.clear();
  }

  void _removeCity(int index) {
    setState(() => _cities.removeAt(index));
  }

    // controls color value based on score
  Color _scoreColor(int score) {
    if (score >= 65) return Colors.green;
    if (score >= 45) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = widget.themeMode == ThemeMode.light;
    return Scaffold(
      backgroundColor: isLightMode ? Colors.grey[100] : Colors.grey[900],
      appBar: AppBar(
        backgroundColor: _darkPurple,
        title: Text(
          'SafeHaven',
          style: TextStyle(
            color: isLightMode ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: isLightMode ? Colors.black : Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
          Icon(isLightMode ? Icons.light_mode : Icons.dark_mode),
          Switch(
            value: isLightMode,
            onChanged: widget.onThemeToggle,
          ),
          Icon(isLightMode ? Icons.dark_mode : Icons.light_mode),
        ],
      ),
      body: Column(
        children: [
          // ── search bar ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'add a city to your dashboard...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onSubmitted: _addCity,
                  ),
                ),
                const SizedBox(width: 8),
                // + button to add a city
                ElevatedButton(
                  onPressed: () => _addCity(_searchController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _darkPurple,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),

          // ── city cards list ──────────────────────────────────
          Expanded(
            child: _cities.isEmpty
                ? const Center(
                    child: Text(
                      'no cities yet, lets add one above!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[index];
                      final color = _scoreColor(city['score'] as int);

                      return GestureDetector(
                        // tapping a card = open city detail screen (move the data)
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CityDetailScreen(city: city),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: color, // green/orange/red based on score
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      city['name'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'safety score: ${city['score']} · ${city['level']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // News blurb — truncated to 2 lines
                                    Text(
                                      city['news'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              // x button to remove city
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white70),
                                onPressed: () => _removeCity(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}