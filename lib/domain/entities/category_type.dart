enum CategoryType {
  expense,
  income;

  String get value {
    switch (this) {
      case CategoryType.expense:
        return 'expense';
      case CategoryType.income:
        return 'income';
    }
  }

  static CategoryType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'expense':
        return CategoryType.expense;
      case 'income':
        return CategoryType.income;
      default:
        throw ArgumentError('Unknown category type: $value');
    }
  }
}
