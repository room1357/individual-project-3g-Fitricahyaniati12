import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? fullName;
  String? email;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInUser = prefs.getString('loggedInUser'); // 🔹 Username aktif

    setState(() {
      username = loggedInUser ?? 'Username tidak tersedia';
      fullName = prefs.getString('fullname_$username') ?? 'Nama tidak tersedia';
      email = prefs.getString('email_$username') ?? 'Email tidak tersedia';
    });
  }

  Future<void> _editUsernameDialog() async {
    final TextEditingController controller = TextEditingController(
      text: username,
    );

    final newUsername = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Username'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Masukkan username baru',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text('Simpan'),
              ),
            ],
          ),
    );

    if (newUsername != null &&
        newUsername.isNotEmpty &&
        newUsername != username) {
      final prefs = await SharedPreferences.getInstance();

      final oldUsername = username!;
      final oldKey = 'expenses_$oldUsername';
      final newKey = 'expenses_$newUsername';
      final oldData = prefs.getString(oldKey);

      // 🔹 Pindahkan data pengeluaran lama ke username baru
      if (oldData != null) {
        await prefs.setString(newKey, oldData);
        await prefs.remove(oldKey);
      }

      // 🔹 Perbarui username di profil & data login
      await prefs.setString('loggedInUser', newUsername);
      await prefs.setString('username', newUsername);

      // 🔹 Update profil jika pakai format fullname_email_username
      final fullnameData = prefs.getString('fullname_$oldUsername');
      final emailData = prefs.getString('email_$oldUsername');
      if (fullnameData != null) {
        await prefs.setString('fullname_$newUsername', fullnameData);
        await prefs.remove('fullname_$oldUsername');
      }
      if (emailData != null) {
        await prefs.setString('email_$newUsername', emailData);
        await prefs.remove('email_$oldUsername');
      }

      setState(() {
        username = newUsername;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username berhasil diubah!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.blue,
      ),
      body:
          fullName == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                          'assets/images/Profil.webp',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        fullName!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 1),

                      _buildInfoRow("Username", username ?? "-"),
                      ElevatedButton(
                        onPressed: _editUsernameDialog,
                        child: const Text('Edit Username'),
                      ),

                      _buildInfoRow("Email", email ?? "-"),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Kembali'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  static Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
