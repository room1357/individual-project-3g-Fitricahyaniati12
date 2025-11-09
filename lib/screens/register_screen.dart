import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // 🧩 Fungsi untuk handle register multi-user
  void handleRegister() async {
    String fullName = fullNameController.text.trim();
    String email = emailController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password tidak sama")));
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    // ✅ Aman dari error tipe data salah
    final existingData = prefs.get('users');
    String? existingUsersString;

    if (existingData is String) {
      existingUsersString = existingData;
    } else {
      existingUsersString = null;
      await prefs.remove('users'); // hapus data lama salah tipe
    }

    List<Map<String, dynamic>> users = [];

    if (existingUsersString != null && existingUsersString.isNotEmpty) {
      final decoded = json.decode(existingUsersString);
      if (decoded is List) {
        users = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    }

    // ✅ Cek username/email duplikat
    bool usernameExists = users.any((u) => u['username'] == username);
    bool emailExists = users.any((u) => u['email'] == email);

    if (usernameExists || emailExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username atau email sudah terdaftar")),
      );
      return;
    }

    // Tambah user baru
    users.add({
      "fullname": fullName,
      "email": email,
      "username": username,
      "password": password,
    });

    // Simpan ke prefs
    await prefs.setString('users', json.encode(users));

    // Notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registrasi berhasil! Silakan login.")),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    // Navigasi ke login
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  // 🎨 Widget Reusable TextField
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 214, 228),
      body: Stack(
        children: [
          // 💠 Lingkaran besar atas
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0xFF7EC8E3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 💠 Lingkaran kecil bawah
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFF9ED8EB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 🩵 Konten utama
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  size: 100,
                  color: Color(0xFF24527A),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Daftar Akun",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF24527A),
                  ),
                ),
                const SizedBox(height: 30),
                buildTextField(
                  controller: fullNameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: usernameController,
                  label: 'Username',
                  icon: Icons.account_circle_outlined,
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7EC8E3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: Color(0xFF24527A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
