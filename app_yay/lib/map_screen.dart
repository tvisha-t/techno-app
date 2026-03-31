import 'package:flutter/material.dart';

// global map screen, rn just placeholder w/ tappable ui
// todo: integrate a real map package? 
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selectedZone;

  // placeholder zones, need to replace
  final List<Map<String, dynamic>> _zones = [
    {
      'name': 'north campus',
      'level': 'moderate',
      'color': Colors.orange,
      'incidents': '8 incidents reported in the last 2 weeks',
    },
    {
      'name': 'dowtown',
      'level': 'be cautious!',
      'color': Colors.red,
      'incidents': '21 incidents reported in the last 2 weeks',
    },
    {
      'name': 'east campus',
      'level': 'usually safe',
      'color': Colors.green,
      'incidents': '3 incidents reported in the last 2 weeks',
    },
    {
      'name': 'bus stop',
      'level': 'be careful!',
      'color': Colors.red,
      'incidents': '15 incidents reported in the last 2 weeks',
    },
    {
      'name': 'west campus',
      'level': 'moderate',
      'color': Colors.orange,
      'incidents': '10 incidents reported in the last 2 weeks',
    },
    {
      'name': 'south campus',
      'level': 'pretty safe',
      'color': Colors.green,
      'incidents': '2 incidents reported in the last 2 weeks',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B2D8E),
        title: const Text('safety heat map', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
            // search bar palceholder
            // todo: wire up to map pan / zoom to searched city
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'search a city...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // ── map placeholder ──────────────────────────────────
          // lowk just a grey box... replace w/ GoogleMap or FlutterMap widget?
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // map background
                Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'map goes here :P',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'todo: Integrate google_maps_flutter or flutter_map',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // color-coded chips w/ popups
                Positioned(top: 60, left: 40, child: _zoneChip(0)),
                Positioned(top: 120, right: 30, child: _zoneChip(1)),
                Positioned(top: 200, left: 80, child: _zoneChip(2)),
                Positioned(bottom: 80, left: 30, child: _zoneChip(3)),
                Positioned(bottom: 60, right: 60, child: _zoneChip(4)),
                Positioned(top: 280, right: 80, child: _zoneChip(5)),
              ],
            ),
          ),

          // ── popup ───────────────────────────────────────
          // incident summary when a zone chip is tapped.
          if (_selectedZone != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF5B2D8E)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedZone!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          _zones.firstWhere((z) => z['name'] == _selectedZone)['incidents'] as String,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _selectedZone = null),
                  ),
                ],
              ),
            ),

          // ── legend ───────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LegendDot(color: Colors.green, label: 'safe'),
                _LegendDot(color: Colors.orange, label: 'moderate'),
                _LegendDot(color: Colors.red, label: 'be careful!'),
              ],
            ),
          ),
        ],
      ),
    );
  }

// helper method for tappable chip
  Widget _zoneChip(int index) {
    final zone = _zones[index];
    final bool isSelected = _selectedZone == zone['name'];
    return GestureDetector(
      onTap: () => setState(() {
        _selectedZone = isSelected ? null : zone['name'] as String;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: (zone['color'] as Color).withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Text(
          zone['name'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}