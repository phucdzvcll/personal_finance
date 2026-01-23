import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../app.dart';
import '../../../core/constants/icons.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/category_type.dart';
import '../../../di/injection.dart';
import '../../cubit/category/category_form_cubit.dart';
import '../../widgets/common/loading_widget.dart';

@RoutePage()
class AddCategoryPage extends StatefulWidget {
  final Category? category;

  const AddCategoryPage({super.key, this.category});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late CategoryType _selectedType;
  String? _selectedIcon;
  String? _selectedColor;
  IconData? _selectedIconData;
  bool get _isEditMode => widget.category != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final category = widget.category!;
      _nameController = TextEditingController(text: category.name);
      _selectedType = category.type;
      _selectedIcon = category.icon;
      _selectedColor = category.color;
      if (category.icon != null) {
        try {
          final icon = icons.firstWhere(
            (icon) => icon.title == category.icon,
            orElse: () => icons.first,
          );
          _selectedIconData = icon.iconData;
        } catch (e) {
          _selectedIconData = null;
        }
      }
    } else {
      _nameController = TextEditingController();
      _selectedType = CategoryType.expense;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSaveCategory(BuildContext context) {
      if (_formKey.currentState!.validate()) {
        if (_isEditMode) {
          context.read<CategoryFormCubit>().updateCategory(
                id: widget.category!.id,
                name: _nameController.text.trim(),
                type: _selectedType,
                icon: _selectedIcon,
                color: _selectedColor,
              );
        } else {
          context.read<CategoryFormCubit>().createCategory(
                name: _nameController.text.trim(),
                type: _selectedType,
                icon: _selectedIcon,
                color: _selectedColor,
              );
        }
      }
  }

  void _showIconPickerDialog(BuildContext context) {
    final searchController = TextEditingController();
    List<AppIcon> filteredIcons = List.from(icons);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Text(
                      context.l10n.selectIcon,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16.h),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search icons...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          if (value.isEmpty) {
                            filteredIcons = List.from(icons);
                          } else {
                            filteredIcons = icons
                                .where((icon) => icon.title
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                        ),
                        itemCount: filteredIcons.length,
                        itemBuilder: (context, index) {
                          final icon = filteredIcons[index];
                          final isSelected = _selectedIcon == icon.title;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIcon = icon.title;
                                _selectedIconData = icon.iconData;
                              });
                              Navigator.of(dialogContext).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (_selectedColor != null
                                        ? Color(int.parse(_selectedColor!.replaceFirst('#', '0xFF')))
                                            .withOpacity(0.1)
                                        : Theme.of(context).colorScheme.primaryContainer)
                                    : Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                  color: isSelected
                                      ? (_selectedColor != null
                                          ? Color(int.parse(_selectedColor!.replaceFirst('#', '0xFF')))
                                          : Theme.of(context).colorScheme.primary)
                                      : Theme.of(context).colorScheme.outline,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: FaIcon(
                                  icon.iconData,
                                  color: isSelected
                                      ? (_selectedColor != null
                                          ? Color(int.parse(_selectedColor!.replaceFirst('#', '0xFF')))
                                          : Theme.of(context).colorScheme.primary)
                                      : Theme.of(context).colorScheme.onSurface,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: Text(context.l10n.cancel),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    Color pickerColor = _selectedColor != null
        ? Color(int.parse(_selectedColor!.replaceFirst('#', '0xFF')))
        : Colors.blue;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(context.l10n.selectColor),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (Color color) {
                    setDialogState(() {
                      pickerColor = color;
                    });
                  },
                  enableAlpha: false,
                  displayThumbColor: true,
                  paletteType: PaletteType.hslWithSaturation,
                  labelTypes: const [],
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(context.l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      final hex = pickerColor.value.toRadixString(16).substring(2).toUpperCase();
                      _selectedColor = '#${hex.padLeft(6, '0')}';
                    });
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(context.l10n.select),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoryFormCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? context.l10n.editCategory : context.l10n.addNewCategory),
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
              child: BlocListener<CategoryFormCubit, CategoryFormState>(
              listener: (context, state) {
                if (state is CategoryFormSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isEditMode
                            ? context.l10n.categoryUpdatedSuccessfully
                            : context.l10n.categoryCreatedSuccessfully,
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.router.pop();
                } else if (state is CategoryFormError) {
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
                  final formState = context.watch<CategoryFormCubit>().state;
                  final isLoading = formState is CategoryFormLoading;
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 24.h),
                      Text(
                        _isEditMode
                            ? context.l10n.editCategory
                            : context.l10n.addNewCategory,
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.l10n.fillCategoryDetails,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      TextFormField(
                        controller: _nameController,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: context.l10n.categoryName,
                          hintText: context.l10n.enterCategoryName,
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.l10n.pleaseEnterCategoryName;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        context.l10n.categoryType,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8.h),
                      SegmentedButton<CategoryType>(
                        segments: [
                          ButtonSegment(
                            value: CategoryType.expense,
                            label: Text(context.l10n.expense),
                            icon: const Icon(Icons.arrow_downward),
                          ),
                          ButtonSegment(
                            value: CategoryType.income,
                            label: Text(context.l10n.income),
                            icon: const Icon(Icons.arrow_upward),
                          ),
                        ],
                        selected: {_selectedType},
                        onSelectionChanged: (Set<CategoryType> newSelection) {
                          setState(() {
                            _selectedType = newSelection.first;
                          });
                        },
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        context.l10n.selectIcon,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => _showIconPickerDialog(context),
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48.w,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: _selectedIconData != null
                                      ? (_selectedColor != null
                                          ? Color(int.parse(_selectedColor!.replaceFirst('#', '0xFF')))
                                              .withOpacity(0.1)
                                          : Theme.of(context).colorScheme.primaryContainer)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: _selectedIconData != null
                                        ? (_selectedColor != null
                                            ? Color(int.parse(_selectedColor!.replaceFirst('#', '0xFF')))
                                            : Theme.of(context).colorScheme.primary)
                                        : Theme.of(context).colorScheme.outline,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: _selectedIconData != null
                                    ? Center(
                                        child: FaIcon(
                                          _selectedIconData!,
                                          color: _selectedColor != null
                                              ? Color(int.parse(_selectedColor!.replaceFirst('#', '0xFF')))
                                              : Theme.of(context).colorScheme.primary,
                                          size: 24.sp,
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.image_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                          size: 24.sp,
                                        ),
                                      ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  _selectedIcon != null
                                      ? _selectedIcon!
                                      : context.l10n.selectIcon,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.sp,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        context.l10n.selectColor,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => _showColorPickerDialog(context),
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: _selectedColor != null
                                ? Color(int.parse(_selectedColor!.replaceFirst('#', '0xFF')))
                                : Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: _selectedColor != null
                                      ? Color(int.parse(_selectedColor!.replaceFirst('#', '0xFF')))
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  _selectedColor != null
                                      ? _selectedColor!
                                      : context.l10n.selectColor,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.sp,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      if (isLoading)
                        const LoadingWidget()
                      else
                        ElevatedButton(
                          onPressed: () => _handleSaveCategory(context),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            _isEditMode
                                ? context.l10n.updateCategory
                                : context.l10n.createCategory,
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
