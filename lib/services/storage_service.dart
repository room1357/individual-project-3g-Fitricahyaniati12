import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/category.dart';

class StorageService {
  // 🔹 Singleton
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String categoryKeyPrefix = "categories_";

  // 🔹 Cache kategori sementara (RAM)
  final Map<String, List<Category>> _cachedCategories = {};

  // 🔹 Ambil kategori dari cache atau SharedPreferences
  Future<List<Category>> getCategories(String username) async {
    // Cek cache
    if (_cachedCategories.containsKey(username)) {
      return _cachedCategories[username]!;
    }

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$categoryKeyPrefix$username');

    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      final list = decoded.map((e) => Category.fromMap(e)).toList();
      _cachedCategories[username] = list;
      return list;
    }

    // Kalau belum ada, pakai default
    _cachedCategories[username] = Category.defaultCategories;
    await saveCategories(username, _cachedCategories[username]!);
    return _cachedCategories[username]!;
  }

  // 🔹 Simpan kategori (ke cache & lokal)
  Future<void> saveCategories(
    String username,
    List<Category> categories,
  ) async {
    _cachedCategories[username] = categories;

    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(categories.map((e) => e.toMap()).toList());
    await prefs.setString('$categoryKeyPrefix$username', encoded);
  }

  // 🔹 Hapus semua kategori (opsional, untuk reset)
  Future<void> clearCategories(String username) async {
    _cachedCategories.remove(username);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$categoryKeyPrefix$username');
  }
}
