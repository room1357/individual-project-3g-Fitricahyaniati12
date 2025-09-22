import 'expense.dart';

class LoopingExamples {
  static List<Expense> expenses = [
    Expense(
      id: '1',
      title: 'Makan Siang',
      amount: 50000.0,
      category: 'Makanan',
      date: DateTime(2025, 9, 21),
      description: 'Nasi goreng + es teh',
    ),
    Expense(
      id: '2',
      title: 'Transportasi',
      amount: 20000.0,
      category: 'Transport',
      date: DateTime(2025, 9, 21),
      description: 'Naik ojek online',
    ),
    Expense(
      id: '3',
      title: 'Kopi',
      amount: 15000.0,
      category: 'Minuman',
      date: DateTime(2025, 9, 20),
      description: 'Kopi susu',
    ),
  ];

  // 1. Menghitung total dengan berbagai cara

  static double calculateTotalTraditional(List<Expense> expenses) {
    double total = 0;
    for (int i = 0; i < expenses.length; i++) {
      total += expenses[i].amount;
    }
    return total;
  }

  static double calculateTotalForIn(List<Expense> expenses) {
    double total = 0;
    for (Expense expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  static double calculateTotalForEach(List<Expense> expenses) {
    double total = 0;
    expenses.forEach((expense) {
      total += expense.amount;
    });
    return total;
  }

  static double calculateTotalFold(List<Expense> expenses) {
    return expenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
  }

  static double calculateTotalReduce(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    return expenses.map((e) => e.amount).reduce((a, b) => a + b);
  }

  // 2. Mencari item dengan berbagai cara

  static Expense? findExpenseTraditional(List<Expense> expenses, String id) {
    for (int i = 0; i < expenses.length; i++) {
      if (expenses[i].id == id) {
        return expenses[i];
      }
    }
    return null;
  }

  static Expense? findExpenseWhere(List<Expense> expenses, String id) {
    try {
      return expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  // 3. Filtering

  static List<Expense> filterByCategoryManual(
      List<Expense> expenses, String category) {
    List<Expense> result = [];
    for (Expense expense in expenses) {
      if (expense.category.toLowerCase() == category.toLowerCase()) {
        result.add(expense);
      }
    }
    return result;
  }

  static List<Expense> filterByCategoryWhere(
      List<Expense> expenses, String category) {
    return expenses
        .where((expense) =>
            expense.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // 4. Mapping

  static List<String> getTitlesManual(List<Expense> expenses) {
    List<String> titles = [];
    for (Expense expense in expenses) {
      titles.add(expense.title);
    }
    return titles;
  }

  static List<String> getTitlesMap(List<Expense> expenses) {
    return expenses.map((expense) => expense.title).toList();
  }

  // 5. Aggregasi (max/min)

  static Expense? getMaxExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce(
        (curr, next) => curr.amount > next.amount ? curr : next);
  }

  static Expense? getMinExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce(
        (curr, next) => curr.amount < next.amount ? curr : next);
  }

  // 6. Looping dengan index

  static void printExpensesWithIndex(List<Expense> expenses) {
    for (int i = 0; i < expenses.length; i++) {
      print('[$i] ${expenses[i].title} - Rp ${expenses[i].amount}');
    }
  }

  // 7. Grouping (total per kategori)

  static Map<String, double> groupByCategory(List<Expense> expenses) {
    Map<String, double> result = {};
    for (Expense expense in expenses) {
      result[expense.category] =
          (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }
}
