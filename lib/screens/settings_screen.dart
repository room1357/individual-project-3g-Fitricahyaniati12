import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _language = 'id'; // 'id' = Indonesia, 'en' = English

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _language = prefs.getString('language') ?? 'id';
    });
  }

  Future<void> _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  Future<void> _saveLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _saveTheme(value);
  }

  void _changeLanguage(String? value) {
    if (value != null) {
      setState(() {
        _language = value;
      });
      _saveLanguage(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = {
      'id': {
        'title': 'Pengaturan',
        'theme': 'Mode Gelap',
        'language': 'Bahasa',
        'about': 'Tentang Aplikasi',
      },
      'en': {
        'title': 'Settings',
        'theme': 'Dark Mode',
        'language': 'Language',
        'about': 'About App',
      },
    };

    final t = texts[_language]!;

    return Scaffold(
      appBar: AppBar(title: Text(t['title']!), backgroundColor: Colors.purple),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌙 Tema
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t['theme']!, style: const TextStyle(fontSize: 18)),
                Switch(
                  value: _isDarkMode,
                  onChanged: _toggleTheme,
                  activeColor: Colors.purple,
                ),
              ],
            ),
            const Divider(height: 30),

            // 🌍 Bahasa
            Text(t['language']!, style: const TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'id', child: Text('Bahasa Indonesia')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: _changeLanguage,
            ),
            const SizedBox(height: 40),

            // 📱 Tentang Aplikasi
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(t['about']!, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
