import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk menyimpan & mengambil data pengeluaran berdasarkan user login.
class SharedExpenseService {
  /// 🔹 Ambil semua pengeluaran milik user
  static Future<List<Map<String, dynamic>>> loadExpenses(
    String username,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'expenses_$username'; // tiap user punya key sendiri
    final data = prefs.getString(key);

    if (data == null || data.isEmpty) return [];

    try {
      final decoded = json.decode(data);
      if (decoded is List) {
        // pastikan semua elemen bisa dikonversi ke Map
        return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      // Jika data corrupt, hapus data lama
      await prefs.remove(key);
      return [];
    }
  }

  /// 🔹 Simpan seluruh daftar pengeluaran user
  static Future<void> saveExpenses(
    String username,
    List<Map<String, dynamic>> expenses,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'expenses_$username';
    final encoded = json.encode(expenses);
    await prefs.setString(key, encoded);
  }

  /// 🔹 Tambahkan pengeluaran baru
  static Future<void> addExpense(
    String username,
    Map<String, dynamic> expense,
  ) async {
    final existingExpenses = await loadExpenses(username);
    existingExpenses.add(expense);
    await saveExpenses(username, existingExpenses);
  }

  /// 🔹 Hapus pengeluaran berdasarkan index
  static Future<void> deleteExpense(String username, int index) async {
    final existingExpenses = await loadExpenses(username);
    if (index >= 0 && index < existingExpenses.length) {
      existingExpenses.removeAt(index);
      await saveExpenses(username, existingExpenses);
    }
  }

  /// 🔹 (Opsional) Hapus semua data pengeluaran user
  static Future<void> clearExpenses(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('expenses_$username');
  }
}
