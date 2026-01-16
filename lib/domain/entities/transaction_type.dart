enum TransactionType {
  expense,
  income;

  String get value {
    switch (this) {
      case TransactionType.expense:
        return 'expense';
      case TransactionType.income:
        return 'income';
    }
  }

  static TransactionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'expense':
        return TransactionType.expense;
      case 'income':
        return TransactionType.income;
      default:
        throw ArgumentError('Unknown transaction type: $value');
    }
  }
}
