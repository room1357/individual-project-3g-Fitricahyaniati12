class Category {
  final String name;   // Nama kategori
  final String icon;   // Nama icon (biar fleksibel simpan sebagai string)
  final String color;  // Warna dalam format hex (#RRGGBB)

  Category({
    required this.name,
    required this.icon,
    required this.color,
  });

  // Konversi ke Map (untuk JSON encode)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  // Buat Category dari Map (untuk JSON decode)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'],
      icon: map['icon'],
      color: map['color'],
    );
  }
  // Contoh kategori default
  static List<Category> defaultCategories = [
    Category(name: 'Makanan', icon: 'restaurant', color: '#FF9800'),    // Orange
    Category(name: 'Transportasi', icon: 'directions_car', color: '#4CAF50'), // Green
    Category(name: 'Utilitas', icon: 'home', color: '#9C27B0'),        // Purple
    Category(name: 'Hiburan', icon: 'movie', color: '#E91E63'),        // Pink
    Category(name: 'Pendidikan', icon: 'school', color: '#2196F3'),    // Blue
  ];
}
