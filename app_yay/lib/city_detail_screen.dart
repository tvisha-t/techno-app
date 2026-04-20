import 'package:flutter/material.dart';
import 'home_screen.dart';

// opens when a user taps a city card
// receives 'city' map, name, score, news blurb, level, and other data

class CityDetailScreen extends StatelessWidget {
  final City city;

  const CityDetailScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final int score = city.score as int;
    final String name = city.name as String;

    // placeholder monthly incident counts (Jan–Dec)
    // toodo: pull from monthly api
    final List<double> monthlyData = [18, 22, 15, 28, 20, 25, 30, 22, 18, 24, 20, 17];
    final List<String> months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];

    final double maxVal = monthlyData.reduce((a, b) => a > b ? a : b);

    // pick score badge color
    Color scoreColor;
    if (score >= 65) {
      scoreColor = Colors.green;
    } else if (score >= 45) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B2D8E),
        title: Text(name, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // x button in top-right corner to close this screen
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── overall score card ───────────────────────────────
            _sectionCard(
              child: Column(
                children: [
                  const Text(
                    'Overall crime levels',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$score / 100',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  ),
                  Text(
                    city.level as String,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── monthly bar chart ────────────────────────────────
            const Text(
              'Monthly crime stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _sectionCard(
              child: SizedBox(
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(12, (i) {
                    final barHeight = (monthlyData[i] / maxVal) * 110;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C6FD6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              months[i],
                              style: const TextStyle(fontSize: 9, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── safety tips ──────────────────────────────────────
            const Text(
              'Safety tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _tipCard(Icons.directions_walk, 'Avoid walking alone at night in unfamiliar areas.'),
            _tipCard(Icons.phone_android, 'Keep your phone charged and share your location.'),
            _tipCard(Icons.group, 'Travel with friends when possible, especially after dark'),
            const SizedBox(height: 24),

            // ── relevant news ──────────────────────────────────────
            const Text(
              'Relevant news',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            ...List<Widget>.from(
              city.newsletters.map(
                (headline) => _newsCard(headline, 'recent'),
              ),
            ),

            const SizedBox(height: 24),

            // ── incident type breakdown ──────────────────────────
            const Text(
              'Recent incidents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _sectionCard(
              child: Column(
                children: [
                  _incidentRow('Assaults: ', 12, 30, Colors.red),
                  _incidentRow('Robberies', 7, 30, Colors.orange),
                  _incidentRow('Vandalsim', 18, 30, Colors.amber),
                  _incidentRow('Theft ', 24, 30, Colors.blue),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ── helpers! ───────────────────────────────────────────────────────

  // basic white card container
  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: child,
    );
  }

  // safety tip row w/ icon + text
  Widget _tipCard(IconData icon, String tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF5B2D8E)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(tip, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  // single news headline row
  Widget _newsCard(String headline, String timeAgo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          const Icon(Icons.article_outlined, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
                Text(timeAgo, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // scaling logic for incident type bars — takes count, max count, and color
  Widget _incidentRow(String type, int count, int max, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(type, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: count / max,
                minHeight: 14,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}