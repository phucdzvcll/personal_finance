import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../app.dart';
import '../../../core/constants/icons.dart';
import '../../../core/router/app_router.dart';
import '../../../di/injection.dart';
import '../../cubit/category/get_categories_cubit.dart';
import '../../cubit/category/delete_category_cubit.dart';
import '../../widgets/common/empty_widget.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/category/swipeable_category_item.dart';

@RoutePage()
class ViewCategoriesPage extends StatelessWidget {
  const ViewCategoriesPage({super.key});

  IconData? _getIconFromName(String? iconName) {
    if (iconName == null) return null;
    try {
      final icon = icons.firstWhere(
        (icon) => icon.title == iconName,
        orElse: () => icons.first,
      );
      return icon.iconData;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<GetCategoriesCubit>()..getCategories()),
        BlocProvider(create: (context) => getIt<DeleteCategoryCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.viewCategories),
          centerTitle: true,
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () async {
              await context.router.push(AddCategoryRoute());
              // Refresh categories after returning from create
              if (context.mounted) {
                context.read<GetCategoriesCubit>().getCategories();
              }
            },
            child: const Icon(Icons.add),
            tooltip: context.l10n.addNewCategory,
          ),
        ),
        body: BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
          builder: (context, state) {
            if (state is GetCategoriesLoading) {
              return const LoadingWidget();
            }

            if (state is GetCategoriesError) {
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
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<GetCategoriesCubit>().getCategories();
                      },
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is GetCategoriesSuccess) {
              final categories = state.categories;

              if (categories.isEmpty) {
                return EmptyWidget(
                  message: context.l10n.noCategoriesFound,
                  icon: Icons.category_outlined,
                );
              }

              return BlocListener<DeleteCategoryCubit, DeleteCategoryState>(
                listener: (context, state) {
                  if (state is DeleteCategorySuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.categoryDeletedSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Refresh categories after deletion
                    context.read<GetCategoriesCubit>().getCategories();
                  } else if (state is DeleteCategoryError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<GetCategoriesCubit>().getCategories();
                  },
                  child: SlidableAutoCloseBehavior(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                      final category = categories[index];
                      final iconData = _getIconFromName(category.icon);
                      final color = category.color != null
                          ? Color(int.parse(category.color!.replaceFirst('#', '0xFF')))
                          : Theme.of(context).colorScheme.primary;

                      return SwipeableCategoryItem(
                        category: category,
                        iconData: iconData,
                        color: color,
                        onTap: () async {
                          await context.router.push(AddCategoryRoute(category: category));
                          // Refresh categories after returning from edit
                          if (context.mounted) {
                            context.read<GetCategoriesCubit>().getCategories();
                          }
                        },
                        onDelete: () async {
                          // Show confirmation dialog when delete icon is tapped
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(context.l10n.deleteCategory),
                              content: Text(
                                context.l10n.deleteCategoryConfirmation(category.name),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text(context.l10n.cancel),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.error,
                                  ),
                                  child: Text(context.l10n.delete),
                                ),
                              ],
                            ),
                          );

                          // If confirmed, delete the category
                          if (confirmed == true && context.mounted) {
                            context.read<DeleteCategoryCubit>().deleteCategory(category.id);
                          }
                        },
                      );
                    },
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
