// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Personal Finance';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get usernameOrEmail => 'Username or Email';

  @override
  String get enterUsernameOrEmail => 'Enter username or email';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Please enter your username or email';

  @override
  String get pleaseEnterValidUsernameOrEmail =>
      'Please enter a valid username or email';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get signIn => 'Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signUpToGetStarted => 'Sign up to get started';

  @override
  String get fullNameOptional => 'Full Name (Optional)';

  @override
  String get email => 'Email';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPasswordField => 'Please enter a password';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get welcomeToPersonalFinance => 'Welcome to Personal Finance';

  @override
  String get startManagingFinances => 'Start managing your finances';

  @override
  String get settings => 'Settings';

  @override
  String get configureAppSettings => 'Configure your app settings';

  @override
  String get categoryManagement => 'Category Management';

  @override
  String get language => 'Language';

  @override
  String get logOut => 'Log out';

  @override
  String get confirmLogout => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get addNewCategory => 'Add New Category';

  @override
  String get viewCategoryTransactions => 'View Category Transactions';

  @override
  String get categoryName => 'Category Name';

  @override
  String get enterCategoryName => 'Enter category name';

  @override
  String get pleaseEnterCategoryName => 'Please enter category name';

  @override
  String get categoryType => 'Category Type';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get createCategory => 'Create Category';

  @override
  String get categoryCreatedSuccessfully => 'Category created successfully';

  @override
  String get fillCategoryDetails => 'Fill in the category details';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get selectColor => 'Select Color';

  @override
  String get select => 'Select';

  @override
  String get viewCategories => 'View Categories';

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get retry => 'Retry';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get updateCategory => 'Update Category';

  @override
  String get categoryUpdatedSuccessfully => 'Category updated successfully';

  @override
  String get delete => 'Delete';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String deleteCategoryConfirmation(String categoryName) {
    return 'Are you sure you want to delete \"$categoryName\"?';
  }

  @override
  String get categoryDeletedSuccessfully => 'Category deleted successfully';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get amount => 'Amount';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get pleaseEnterAmount => 'Please enter amount';

  @override
  String get amountMustBeGreaterThanZero => 'Amount must be greater than 0';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get pleaseSelectCategory => 'Please select a category';

  @override
  String get transactionDate => 'Transaction Date';

  @override
  String get selectDate => 'Select Date';

  @override
  String get pleaseSelectDate => 'Please select a date';

  @override
  String get note => 'Note';

  @override
  String get enterNote => 'Enter note (optional)';

  @override
  String get createTransaction => 'Create Transaction';

  @override
  String get transactionCreatedSuccessfully =>
      'Transaction created successfully';

  @override
  String get fillTransactionDetails => 'Fill in the transaction details';

  @override
  String get transactions => 'Transactions';

  @override
  String get viewAndManageTransactions => 'View and manage your transactions';

  @override
  String get noTransactionsFound => 'No transactions found';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get updateTransaction => 'Update Transaction';

  @override
  String get transactionUpdatedSuccessfully =>
      'Transaction updated successfully';

  @override
  String get transactionDeletedSuccessfully =>
      'Transaction deleted successfully';

  @override
  String get monthlySummary => 'Monthly Summary';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get balance => 'Balance';

  @override
  String get expenseByCategory => 'Expense by Category';

  @override
  String get noExpenseData => 'No expense data available';

  @override
  String get loading => 'Loading...';

  @override
  String get filter => 'Filter';

  @override
  String get selectMonthYear => 'Select Month and Year';

  @override
  String get year => 'Year';

  @override
  String get month => 'Month';

  @override
  String get list => 'List';

  @override
  String get chart => 'Chart';
}
