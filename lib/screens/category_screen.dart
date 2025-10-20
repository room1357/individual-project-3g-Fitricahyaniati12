import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // 🎨 Tambahkan package untuk color picker
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
  final String _username =
      'default_user'; // 📌 Nama user, bisa diganti kalau sistem login sudah ada

  // 🔹 Daftar ikon bawaan yang bisa dipilih pengguna
  final Map<String, IconData> _availableIcons = {
    'restaurant': Icons.restaurant,
    'shopping_cart': Icons.shopping_cart,
    'home': Icons.home,
    'flight': Icons.flight,
    'movie': Icons.movie,
    'school': Icons.school,
    'local_cafe': Icons.local_cafe,
    'directions_car': Icons.directions_car,
    'medical_services': Icons.medical_services,
    'pets': Icons.pets,
    'work': Icons.work,
    'mountain': Icons.terrain,
  };

  @override
  void initState() {
    super.initState();
    _loadCategories(); // 🔹 Panggil saat pertama kali layar dibuka
  }

  /// 🔹 Ambil kategori dari local storage
  Future<void> _loadCategories() async {
    final saved = await _storage.getCategories(_username);
    if (saved.isEmpty) {
      _categories = Category.defaultCategories; // kalau kosong pakai default
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

  /// 🟢 Tambah kategori baru
  void _addCategory() {
    String name = '';
    String? selectedIcon;
    Color selectedColor = Colors.orange; // warna default

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kategori'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Input nama kategori
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nama'),
                    onChanged: (val) => name = val,
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Dropdown untuk pilih ikon
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Pilih Ikon'),
                    value: selectedIcon,
                    items:
                        _availableIcons.keys.map((key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Row(
                              children: [
                                Icon(_availableIcons[key], color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(key),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (val) {
                      setStateDialog(() {
                        selectedIcon = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Tombol untuk memilih warna kategori
                  Row(
                    children: [
                      const Text('Pilih Warna:'),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          // 🔹 Tampilkan color picker
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Pilih Warna'),
                                  content: SingleChildScrollView(
                                    child: BlockPicker(
                                      pickerColor: selectedColor,
                                      onColorChanged: (color) {
                                        setStateDialog(() {
                                          selectedColor = color;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                          );
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: selectedColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (name.isNotEmpty && selectedIcon != null) {
                  setState(() {
                    _categories.add(
                      Category(
                        name: name,
                        icon: selectedIcon!,
                        color:
                            '#${selectedColor.value.toRadixString(16).substring(2)}',
                      ),
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

  /// 🟡 Edit kategori
  void _editCategory(int index) {
    final category = _categories[index];
    String name = category.name;
    String? selectedIcon = category.icon;
    Color selectedColor = _hexToColor(category.color);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Kategori'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Nama kategori
                  TextField(
                    controller: TextEditingController(text: name),
                    decoration: const InputDecoration(labelText: 'Nama'),
                    onChanged: (val) => name = val,
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Dropdown ikon
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Pilih Ikon'),
                    value: selectedIcon,
                    items:
                        _availableIcons.keys.map((key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Row(
                              children: [
                                Icon(_availableIcons[key], color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(key),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (val) {
                      setStateDialog(() {
                        selectedIcon = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Warna picker
                  Row(
                    children: [
                      const Text('Pilih Warna:'),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Pilih Warna'),
                                  content: SingleChildScrollView(
                                    child: BlockPicker(
                                      pickerColor: selectedColor,
                                      onColorChanged: (color) {
                                        setStateDialog(() {
                                          selectedColor = color;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                          );
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: selectedColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (name.isNotEmpty && selectedIcon != null) {
                  setState(() {
                    _categories[index] = Category(
                      name: name,
                      icon: selectedIcon!,
                      color:
                          '#${selectedColor.value.toRadixString(16).substring(2)}',
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

  /// 🔴 Hapus kategori
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

  /// 🔹 Ambil ikon sesuai nama
  IconData _getIconFromName(String iconName) {
    return _availableIcons[iconName] ?? Icons.category;
  }

  /// 🔹 Konversi string warna hex ke Color
  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  /// 🔹 Tampilan utama
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
                        _getIconFromName(category.icon),
                        color: _hexToColor(category.color),
                        size: 30,
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
}
