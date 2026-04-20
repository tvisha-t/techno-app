import 'package:flutter/material.dart';
import 'widgets/safe_haven_logo.dart';

// ─ Purple Aesthetic Color Palette ─────────────────────
const Color _darkPurple = Color(0xFF5B2D8E);
const Color _mediumPurple = Color(0xFF8A5C9C);
const Color _lightPurple = Color(0xFFE5D4F0);
const Color _accentPurple = Color(0xFF9C6FD6);
// ───────────────────────────────────────────────────

// login screen is for logging & signup
// toggles betwen 2 modes using isLogin
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // true = show login form
  // false = show signup form
  bool _isLogin = true;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController(); // only used during signup

    // "submitting" the form just navigates to home for now, no real auth logic yet
  void _submit() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkPurple,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SafeHavenLogo(size: 120),
                const SizedBox(height: 24),
                // subtitle alternates depending on state
                Text(
                  _isLogin ? 'Welcome back!' : 'Create your account!',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // username field
                _buildField(_usernameController, 'Username', Icons.person),

                // phone number field during signup
                if (!_isLogin) ...[
                  const SizedBox(height: 16),
                  _buildField(
                    _phoneController,
                    'Phone number',
                    Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                ],
                const SizedBox(height: 16),

                // password field 
                _buildField(_passwordController, 'Password', Icons.lock, obscure: true),
                const SizedBox(height: 32),

                // submit button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _darkPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _isLogin ? 'Log in' : 'Sign up',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // toggle between login and signup modes
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Lets sign you up!"
                        : 'Already have an account? Lets log in',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // helper method for stylzed text input (reused for username, phone, and password fields)
  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure, // just hides text
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}