import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/category.dart';
import '../models/expense.dart';

class StorageService {
  static const String categoryKey = "categories";

 Future<List<Category>> getCategories({required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "categories_$username"; // key unik per user
    final data = prefs.getString(key);

    if (data != null) {
      List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => Category.fromMap(e)).toList();
    }

    // Kalau belum ada → pakai default
    return Category.defaultCategories;
  }

  // 🔹 Simpan kategori untuk user tertentu
  Future<void> saveCategories(String username, List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "categories_$username";
    String data = jsonEncode(categories.map((e) => e.toMap()).toList());
    await prefs.setString(key, data);
  }
}
