import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/category_type.dart';
import '../../../app.dart';

class SwipeableCategoryItem extends StatelessWidget {
  final Category category;
  final IconData? iconData;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SwipeableCategoryItem({
    super.key,
    required this.category,
    required this.iconData,
    required this.color,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Slidable(
        key: ValueKey('category_${category.id}'),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              ),
              flex: 1,
              autoClose: false,
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ListTile(
            leading: Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: iconData != null
                ? Center(
                    child: FaIcon(
                      iconData,
                      color: color,
                      size: 24.sp,
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.category,
                      color: color,
                      size: 24.sp,
                    ),
                  ),
          ),
          title: Text(
            category.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            category.type == CategoryType.expense
                ? context.l10n.expense
                : context.l10n.income,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          onTap: onTap,
          ),
        ),
      ),
    );
  }
}
