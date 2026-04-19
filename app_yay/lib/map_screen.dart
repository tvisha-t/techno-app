import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Safety heat map screen with OpenStreetMap
class MapScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<bool> onThemeToggle;

  const MapScreen({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

// ─ Purple Aesthetic Color Palette ─────────────────────
const Color _darkPurple = Color(0xFF5B2D8E);
const Color _mediumPurple = Color(0xFF8A5C9C);
const Color _lightPurple = Color(0xFFE5D4F0);
const Color _accentPurple = Color(0xFF9C6FD6);
// ───────────────────────────────────────────────────

class _MapScreenState extends State<MapScreen> {
  String? _selectedZone;

  // Safety zones in San Francisco
  final List<Map<String, dynamic>> _zones = [
    {
      'name': 'Downtown',
      'level': 'be cautious!',
      'color': Colors.red,
      'incidents': '21 incidents reported in the last 2 weeks',
      'lat': 37.7749,
      'lng': -122.4194,
    },
    {
      'name': 'Bus Stop',
      'level': 'be careful!',
      'color': Colors.red,
      'incidents': '15 incidents reported in the last 2 weeks',
      'lat': 37.7849,
      'lng': -122.4094,
    },
    {
      'name': 'North Campus',
      'level': 'moderate',
      'color': Colors.orange,
      'incidents': '8 incidents reported in the last 2 weeks',
      'lat': 37.7649,
      'lng': -122.4294,
    },
    {
      'name': 'West Campus',
      'level': 'moderate',
      'color': Colors.orange,
      'incidents': '10 incidents reported in the last 2 weeks',
      'lat': 37.7649,
      'lng': -122.4394,
    },
    {
      'name': 'East Campus',
      'level': 'usually safe',
      'color': Colors.green,
      'incidents': '3 incidents reported in the last 2 weeks',
      'lat': 37.7849,
      'lng': -122.4094,
    },
    {
      'name': 'South Campus',
      'level': 'pretty safe',
      'color': Colors.green,
      'incidents': '2 incidents reported in the last 2 weeks',
      'lat': 37.7549,
      'lng': -122.4194,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLightMode = widget.themeMode == ThemeMode.light;
    return Scaffold(
      backgroundColor: isLightMode ? Colors.grey[100] : Colors.grey[900],
      appBar: AppBar(
        backgroundColor: _darkPurple,
        title: const Text('Safety heat map', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Icon(isLightMode ? Icons.light_mode : Icons.dark_mode),
          Switch(value: isLightMode, onChanged: widget.onThemeToggle),
          Icon(isLightMode ? Icons.dark_mode : Icons.light_mode),
        ],
      ),
      body: Stack(
        children: [
          // Heat map with zones
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(37.7749, -122.4194),
              initialZoom: 13,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app_yay',
              ),
              CircleLayer(
                circles: _buildHeatmapCircles(),
              ),
              MarkerLayer(
                markers: _buildClickableMarkers(),
              ),
            ],
          ),

          // Legend
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: _darkPurple.withOpacity(0.2), blurRadius: 6),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Safety Levels',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  _LegendDot(color: Colors.green, label: 'Safe'),
                  _LegendDot(color: Colors.orange, label: 'Moderate'),
                  _LegendDot(color: Colors.red, label: 'Be Careful'),
                ],
              ),
            ),
          ),

          // Zone details overlay
          if (_selectedZone != null)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.98),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: _darkPurple.withOpacity(0.25), blurRadius: 12),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedZone!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _selectedZone = null),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _mediumPurple.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _mediumPurple.withOpacity(0.4), width: 1),
                      ),
                      child: Text(
                        _zones.firstWhere((z) => z['name'] == _selectedZone)['level'] as String,
                        style: const TextStyle(
                          color: _mediumPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _zones.firstWhere((z) => z['name'] == _selectedZone)['incidents'] as String,
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<CircleMarker> _buildHeatmapCircles() {
    return _zones.map((zone) {
      return CircleMarker(
        point: LatLng(zone['lat'] as double, zone['lng'] as double),
        radius: 800,
        useRadiusInMeter: true,
        color: (zone['color'] as Color).withOpacity(0.25),
        borderStrokeWidth: 3,
        borderColor: zone['color'] as Color,
      );
    }).toList();
  }

  List<Marker> _buildClickableMarkers() {
    return _zones.map((zone) {
      return Marker(
        point: LatLng(zone['lat'] as double, zone['lng'] as double),
        child: GestureDetector(
          onTap: () => setState(() => _selectedZone = zone['name'] as String),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (zone['color'] as Color).withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: _darkPurple.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Text(
              zone['name'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }).toList();
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