import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../app.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/transaction_type.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import '../../../di/injection.dart';
import '../../cubit/transaction/transaction_form_cubit.dart';
import '../../widgets/common/loading_widget.dart';

@RoutePage()
class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

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
  List<Category> _categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _noteController = TextEditingController();
    _selectedType = TransactionType.expense;
    _loadCategories();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    final getCategoriesUseCase = getIt<GetCategoriesUseCase>();
    final result = await getCategoriesUseCase();

    if (mounted) {
      setState(() {
        _isLoadingCategories = false;
        result.fold(
          (failure) {
            // Handle error - could show snackbar
          },
          (categories) {
            _categories = categories;
          },
        );
      });
    }
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

  void _handleCreateTransaction(BuildContext context) {
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

      final amount = double.tryParse(_amountController.text.trim());
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
      context.read<TransactionFormCubit>().createTransaction(
            amount: amount,
            type: _selectedType,
            categoryId: _selectedCategory!.id,
            transactionDate: dateFormat.format(_selectedDate!),
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransactionFormCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.addTransaction),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: BlocListener<TransactionFormCubit, TransactionFormState>(
              listener: (context, state) {
                if (state is TransactionFormSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.transactionCreatedSuccessfully),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.router.pop();
                } else if (state is TransactionFormError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              child: Builder(
                builder: (context) {
                  final formState = context.watch<TransactionFormCubit>().state;
                  final isLoading = formState is TransactionFormLoading;

                  if (_isLoadingCategories) {
                    return const LoadingWidget();
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
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                            final amount = double.tryParse(value.trim());
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
                          items: _categories
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
                              : () => _handleCreateTransaction(context),
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
                                  context.l10n.createTransaction,
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
    );
  }
}
