import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/category.dart';

class StorageService {
  static const String categoryKey = "categories";

  // Ambil semua kategori
  Future<List<Category>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(categoryKey);

    if (data != null) {
      List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => Category.fromMap(e)).toList();
    }
    // Kalau kosong → pakai default
    return Category.defaultCategories;
  }

  // Simpan kategori baru
  Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    String data = jsonEncode(categories.map((e) => e.toMap()).toList());
    await prefs.setString(categoryKey, data);
  }
}
