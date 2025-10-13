import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../services/storage_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final StorageService _storage = StorageService();
  List<Category> categories = [];
  final TextEditingController nameController = TextEditingController();
  String? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserAndCategories();
  }

 Future<void> _loadUserAndCategories() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUser = prefs.getString('username'); // ambil username login
    if (_currentUser == null) return;

    final loaded = await _storage.getCategories(username: _currentUser!);

    setState(() {
      categories = loaded;
    });
  }

  Future<void> _addCategory() async {
    if (nameController.text.isEmpty || _currentUser == null) return;

    setState(() {
      categories.add(
        Category(
          name: nameController.text,
          icon: 'category',   // default icon
          color: '#607D8B',   // default abu-abu
        ),
      );
      nameController.clear();
    });

    await _storage.saveCategories(_currentUser!, categories);

  }

  Future<void> _deleteCategory(int index) async {
    if (_currentUser == null) return;

    setState(() {
      categories.removeAt(index);
    });
    await _storage.saveCategories(_currentUser!, categories);
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }
  // ✅ Fungsi untuk edit kategori
  Future<void> _editCategory(int index) async {
    final TextEditingController editController =
        TextEditingController(text: categories[index].name);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Kategori"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              labelText: "Nama kategori baru",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (editController.text.isNotEmpty) {
                  setState(() {
                   categories[index] = Category(
                      name: editController.text,
                      icon: categories[index].icon,
                      color: categories[index].color,
                    );
                  });
                  await _storage.saveCategories(_currentUser!, categories);

                }
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  IconData _stringToIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'home':
        return Icons.home;
      case 'movie':
        return Icons.movie;
      case 'school':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Input tambah kategori
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama kategori baru',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCategory,
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),

// Daftar kategori
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _hexToColor(category.color),
                      child: Icon(
                        _stringToIcon(category.icon),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(category.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol Edit
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editCategory(index),
                        ),
                        // Tombol Hapus
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
          ),
        ],
      ),
    );
  }
}