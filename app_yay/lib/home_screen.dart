import 'package:flutter/material.dart';
import 'city_detail_screen.dart';
import 'widgets/safe_haven_logo.dart';

// each city has a map & has a namme, score (0–100), news blurb, and safety level label

class City {
  final String name;
  final int score;
  final String level;
  final String news;
  final List<String> newsletters;

  City({
    required this.name,
    required this.score,
    required this.level,
    required this.news,
    required this.newsletters,
  });
}

final List<City> _placeholderCities = [
  City(
    name: 'San Francisco',
    score: 62,
    news: '2026/4/17: SFPD Arrests Driver of a Fatal Collision #26-047',
    level: 'moderate',
    newsletters: [
      '2026/4/17 MSN: SFPD Arrests Driver of a Fatal Collision #26-047',
      '2026/4/16: Hit and run near Mission Street and South Van Ness Avenue',
      '2026/4/6: Chinatown stabbing in broad daylight; Area evacuated',
    ],
  ),
  City(
    name: 'Minneapolis',
    score: 71,
    news: '2026/4/19: Hopkins shooting leaves 16-year-old boy in critical condition',
    level: 'generally safe...',
    newsletters: [
      '2026/4/19: Hopkins shooting leaves 16-year-old boy in critical condition',
      '2026/4/17: ICE-related safety concerns in downtown Roseville',
      '2026/4/16: New safety measures implemented in downtown area',
    ],
  ),
  City(
    name: 'Chicago',
    score: 38,
    news: '2026/4/18 NBC 5: Garfield Park search for suspects in mass shooting continues',
    level: 'exercise caution...',
    newsletters: [
      '2026/4/18 NBC 5: Garfield Park search for suspects in mass shooting continues',
      '2026/4/17 FOC 32: Recent South Side shooting during heated argument',
      '2026/4/17 ABC 7: Archer Heights blockaded due to fiery carh crash',
    ],
  ),
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
  List<City> _cities = List.from(_placeholderCities);

  // user types city name & presses +
  void _addCity(String name) {
  if (name.trim().isEmpty) return;

  setState(() {
    _cities.add(
      City(
        name: name.trim(),
        score: 50,
        news: 'Safety data loading...',
        level: 'unknown...',
        newsletters: [
          'Breaking update for ${name.trim()}',
          'Local safety report emerging',
          'Community advisory released',
        ],
      ),
    );
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
                      hintText: 'Add a city to your dashboard',
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
                      'No cities yet, lets add one above!',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[index];
                      final color = _scoreColor(city.score as int);

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
                                      city.name as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Safety score: ${city.score} · ${city.level}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // News blurb — truncated to 2 lines
                                    Text(
                                      city.news as String,
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