import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/storage_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final StorageService _storage = StorageService();
  List<Category> _categories = [];
  final String _username = 'default_user'; // Bisa diganti sesuai login user

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  /// 🔹 Ambil kategori dari penyimpanan lokal
  Future<void> _loadCategories() async {
    final saved = await _storage.getCategories(_username);
    if (saved.isEmpty) {
      _categories = Category.defaultCategories;
      await _storage.saveCategories(_username, _categories);
    } else {
      _categories = saved;
    }
    setState(() {});
  }

  /// 🔹 Simpan kategori ke penyimpanan lokal
  Future<void> _saveCategories() async {
    await _storage.saveCategories(_username, _categories);
  }

  /// 🔹 Tambah kategori baru
  void _addCategory() {
    String name = '';
    String icon = '';
    String color = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kategori'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nama'),
                onChanged: (val) => name = val,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Ikon (misal: restaurant)',
                ),
                onChanged: (val) => icon = val,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Warna (misal: #FF9800)',
                ),
                onChanged: (val) => color = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (name.isNotEmpty && icon.isNotEmpty && color.isNotEmpty) {
                  setState(() {
                    _categories.add(
                      Category(name: name, icon: icon, color: color),
                    );
                  });
                  await _saveCategories();
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Edit kategori
  void _editCategory(int index) {
    final category = _categories[index];
    String name = category.name;
    String icon = category.icon;
    String color = category.color;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Kategori'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: name),
                decoration: const InputDecoration(labelText: 'Nama'),
                onChanged: (val) => name = val,
              ),
              TextField(
                controller: TextEditingController(text: icon),
                decoration: const InputDecoration(labelText: 'Ikon'),
                onChanged: (val) => icon = val,
              ),
              TextField(
                controller: TextEditingController(text: color),
                decoration: const InputDecoration(labelText: 'Warna'),
                onChanged: (val) => color = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _categories[index] = Category(
                    name: name,
                    icon: icon,
                    color: color,
                  );
                });
                await _saveCategories();
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Hapus kategori
  void _deleteCategory(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Kategori'),
            content: Text(
              'Yakin ingin menghapus kategori "${_categories[index].name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() {
        _categories.removeAt(index);
      });
      await _saveCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
      body:
          _categories.isEmpty
              ? const Center(child: Text('Belum ada kategori'))
              : ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.circle,
                        color: _hexToColor(category.color),
                      ),
                      title: Text(category.name),
                      subtitle: Text('Ikon: ${category.icon}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _editCategory(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  /// 🔹 Konversi hex string ke Color
  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
