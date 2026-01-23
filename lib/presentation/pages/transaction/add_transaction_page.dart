import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../app.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/entities/transaction_type.dart';
import '../../../di/injection.dart';
import '../../cubit/transaction/transaction_form_cubit.dart';
import '../../widgets/common/loading_widget.dart';

@RoutePage()
class AddTransactionPage extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionPage({super.key, this.transaction});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  late TransactionType _selectedType;
  Category? _selectedCategory;
  DateTime? _selectedDate;
  bool _categoryMatched = false;
  bool get _isEditMode => widget.transaction != null;
  
  final NumberFormat _numberFormat = NumberFormat.currency(
    symbol: '',
    decimalDigits: 0,
  );
  
  String _formatNumber(String value) {
    if (value.isEmpty) return '';
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return '';
    final number = int.tryParse(digitsOnly);
    if (number == null) return '';
    return _numberFormat.format(number);
  }

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final transaction = widget.transaction!;
      _amountController = TextEditingController(
        text: _numberFormat.format(transaction.amount),
      );
      _noteController = TextEditingController(text: transaction.note ?? '');
      _selectedType = transaction.type;
      _selectedCategory = transaction.category;
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(transaction.transactionDate);
      } catch (e) {
        _selectedDate = null;
      }
    } else {
      _amountController = TextEditingController();
      _noteController = TextEditingController();
      _selectedType = TransactionType.expense;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleSaveTransaction(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.pleaseSelectCategory),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.pleaseSelectDate),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      // Remove formatting characters and parse
      final cleanAmountText = _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
      final amount = int.tryParse(cleanAmountText);
      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.amountMustBeGreaterThanZero),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      final dateFormat = DateFormat('yyyy-MM-dd');
      // Convert to double for API (amount is stored as double)
      final amountDouble = amount.toDouble();
      if (_isEditMode) {
        context.read<TransactionFormCubit>().updateTransaction(
              id: widget.transaction!.id,
              amount: amountDouble,
              type: _selectedType,
              categoryId: _selectedCategory!.id,
              transactionDate: dateFormat.format(_selectedDate!),
              note: _noteController.text.trim().isEmpty
                  ? null
                  : _noteController.text.trim(),
            );
      } else {
        context.read<TransactionFormCubit>().createTransaction(
              amount: amountDouble,
              type: _selectedType,
              categoryId: _selectedCategory!.id,
              transactionDate: dateFormat.format(_selectedDate!),
              note: _noteController.text.trim().isEmpty
                  ? null
                  : _noteController.text.trim(),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransactionFormCubit>()..loadCategories(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? context.l10n.editTransaction : context.l10n.addTransaction),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              // Unfocus when tapping outside input fields
              FocusScope.of(context).unfocus();
            },
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: BlocListener<TransactionFormCubit, TransactionFormState>(
              listener: (context, state) {
                if (state is TransactionFormSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isEditMode
                            ? context.l10n.transactionUpdatedSuccessfully
                            : context.l10n.transactionCreatedSuccessfully,
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Return true to indicate success and trigger refresh
                  context.router.pop(true);
                } else if (state is TransactionFormError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                } else if (state is TransactionFormCategoriesLoaded) {
                  // Match selected category with loaded categories in edit mode
                  if (_isEditMode && widget.transaction?.category != null && !_categoryMatched) {
                    final matchedCategory = state.categories.firstWhere(
                      (cat) => cat.id == widget.transaction!.category!.id,
                      orElse: () => widget.transaction!.category!,
                    );
                    setState(() {
                      _selectedCategory = matchedCategory;
                      _categoryMatched = true;
                    });
                  }
                }
              },
              child: Builder(
                builder: (context) {
                  final formState = context.watch<TransactionFormCubit>().state;
                  final isLoading = formState is TransactionFormLoading;

                  // Handle category loading states
                  if (formState is TransactionFormLoadingCategories) {
                    return const LoadingWidget();
                  }

                  if (formState is TransactionFormCategoriesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.sp,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            formState.message,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<TransactionFormCubit>().loadCategories();
                            },
                            child: Text(context.l10n.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  // Get categories from state
                  List<Category> categories = [];
                  if (formState is TransactionFormCategoriesLoaded) {
                    categories = formState.categories;
                  } else if (formState is TransactionFormInitial) {
                    // Initial state - categories not loaded yet
                    // This should not happen as we call loadCategories immediately
                  }

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 24.h),
                        Text(
                          context.l10n.fillTransactionDetails,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32.h),
                        // Amount Field
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              if (newValue.text.isEmpty) {
                                return newValue;
                              }
                              final formatted = _formatNumber(newValue.text);
                              return TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                  offset: formatted.length,
                                ),
                              );
                            }),
                          ],
                          decoration: InputDecoration(
                            labelText: context.l10n.amount,
                            hintText: context.l10n.enterAmount,
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return context.l10n.pleaseEnterAmount;
                            }
                            // Remove formatting characters and parse
                            final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
                            final amount = int.tryParse(cleanValue);
                            if (amount == null || amount <= 0) {
                              return context.l10n.amountMustBeGreaterThanZero;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        // Transaction Type
                        Text(
                          context.l10n.transactionType,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 12.h),
                        SegmentedButton<TransactionType>(
                          segments: [
                            ButtonSegment<TransactionType>(
                              value: TransactionType.expense,
                              label: Text(context.l10n.expense),
                              icon: const Icon(Icons.arrow_downward),
                            ),
                            ButtonSegment<TransactionType>(
                              value: TransactionType.income,
                              label: Text(context.l10n.income),
                              icon: const Icon(Icons.arrow_upward),
                            ),
                          ],
                          selected: {_selectedType},
                          onSelectionChanged: (Set<TransactionType> newSelection) {
                            setState(() {
                              _selectedType = newSelection.first;
                              _selectedCategory = null; // Reset category when type changes
                            });
                          },
                        ),
                        SizedBox(height: 24.h),
                        // Category Dropdown
                        DropdownButtonFormField<Category>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: context.l10n.category,
                            hintText: context.l10n.selectCategory,
                            prefixIcon: const Icon(Icons.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          items: categories
                              .where((category) => category.type.value == _selectedType.value)
                              .map((category) {
                            return DropdownMenuItem<Category>(
                              value: category,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (Category? category) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return context.l10n.pleaseSelectCategory;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        // Date Field
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _selectedDate != null
                                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                                : '',
                          ),
                          decoration: InputDecoration(
                            labelText: context.l10n.transactionDate,
                            hintText: context.l10n.selectDate,
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (_selectedDate == null) {
                              return context.l10n.pleaseSelectDate;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        // Note Field
                        TextFormField(
                          controller: _noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: context.l10n.note,
                            hintText: context.l10n.enterNote,
                            prefixIcon: const Icon(Icons.note),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        // Create Button
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _handleSaveTransaction(context),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                )
                              : Text(
                                  _isEditMode
                                      ? context.l10n.updateTransaction
                                      : context.l10n.createTransaction,
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}
