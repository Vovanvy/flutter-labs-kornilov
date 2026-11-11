enum Category { food, transport, study }

extension CategoryName on Category {
  String get title {
    switch (this) {
      case Category.food:
        return 'Еда';
      case Category.transport:
        return 'Транспорт';
      case Category.study:
        return 'Учёба';
    }
  }
}

class Expense {
  final String name;
  final int amount;
  final Category category;

  Expense(this.name, this.amount, this.category);

  void printInfo() {
    print('$name: $amount руб. (${category.title})');
  }
}

Future<List<Expense>> loadExpenses() async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  return [
    Expense('Обед', 250, Category.food),
    Expense('Автобус', 60, Category.transport),
    Expense('Тетрадь', 100, Category.study),
    Expense('Ужин', 300, Category.food),
  ];
}

Future<void> main() async {
  print('Загружаем расходы...');

  final List<Expense> expenses = await loadExpenses();
  var total = 0;

  for (final expense in expenses) {
    expense.printInfo();
    total += expense.amount;
  }
  print('\nВсего потрачено: $total руб.');

  final foodExpenses = expenses.where(
    (expense) => expense.category == Category.food,
  );

  var foodTotal = 0;
  for (final expense in foodExpenses) {
    foodTotal += expense.amount;
  }
  print('Из них на еду: $foodTotal руб.');
}
