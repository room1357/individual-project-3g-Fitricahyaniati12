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
  List<Category> categories = [];
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final loaded = await _storage.getCategories();
    setState(() {
      categories = loaded;
    });
  }

  Future<void> _addCategory() async {
    if (nameController.text.isEmpty) return;

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

    await _storage.saveCategories(categories);
  }

  Future<void> _deleteCategory(int index) async {
    setState(() {
      categories.removeAt(index);
    });
    await _storage.saveCategories(categories);
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
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
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _hexToColor(category.color),
                      child: Icon(
                        _stringToIcon(category.icon),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(category.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCategory(index),
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
