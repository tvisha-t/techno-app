import 'package:flutter/material.dart';

// sos screen but super simplified just for demo purposes
// idle & activated states

class SosScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<bool> onThemeToggle;

  const SosScreen({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _sosActivated = false;

  @override
  Widget build(BuildContext context) {
    final isLightMode = widget.themeMode == ThemeMode.light;
    return Scaffold(
        backgroundColor: _sosActivated ? Colors.red[700] : (isLightMode ? Colors.grey[50] : Colors.grey[900]),
      appBar: AppBar(
        backgroundColor: _sosActivated ? Colors.red[900] : const Color(0xFF5B2D8E),
        title: const Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Icon(isLightMode ? Icons.light_mode : Icons.dark_mode),
          Switch(value: isLightMode, onChanged: widget.onThemeToggle),
          Icon(isLightMode ? Icons.dark_mode : Icons.light_mode),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_sosActivated) ...[
                // ── idle ───────────────────────────────
                const Text(
                  'Press the button if you\nneed immediate help!!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 48),

                // big SOS button
                GestureDetector(
                  onTap: () => setState(() => _sosActivated = true),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // ── activated state ──────────────────────────
                const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 80),
                const SizedBox(height: 24),
                const Text(
                  'SOS ACTIVATED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'help is on the way!',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 60),

                // cancel button, no pin needed right now
                TextButton(
                  onPressed: () => setState(() => _sosActivated = false),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    'cancel SOS',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}