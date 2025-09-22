import '../models/expense.dart';

class ExpenseManager {
  static List<Expense> expenses = [
    Expense(
      id: '1',
      title: "Makan siang",
      description: "Nasi goreng + es teh",
      category: "Makanan",
      amount: 25000,
      date: DateTime(2025, 9, 20),
    ),
    Expense(
      id: '2',
      title: "Ojek online",
      description: "Pergi ke kampus",
      category: "Transportasi",
      amount: 12000,
      date: DateTime(2025, 9, 21),
    ),
    Expense(
      id: '3',
      title: "Tagihan listrik",
      description: "Bayar PLN bulanan",
      category: "Utilitas",
      amount: 150000,
      date: DateTime(2025, 9, 22),
    ),
  ];
}
