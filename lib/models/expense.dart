class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String description;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });

  /// 🔹 Getter: format tampilan mata uang
  String get formattedAmount => 'Rp ${amount.toStringAsFixed(0)}';

  /// 🔹 Getter: format tampilan tanggal (dd/mm/yyyy)
  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  /// 🔹 Konversi dari Map (misal dari SharedPreferences atau JSON)
  factory Expense.fromJson(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount:
          (map['amount'] is int)
              ? (map['amount'] as int).toDouble()
              : (map['amount'] ?? 0.0),
      category: map['category'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      description: map['description'] ?? '',
    );
  }

  /// 🔹 Konversi ke Map (agar bisa disimpan ke SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}
