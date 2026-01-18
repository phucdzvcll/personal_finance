import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/icons.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/entities/transaction_type.dart';
import '../../../app.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
    required this.onDelete,
  });

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

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      // Format as thousands (e.g., 150k, 1000k)
      final thousands = amount / 1000;
      if (thousands % 1 == 0) {
        return '\$${thousands.toInt()}k';
      }
      return '\$${thousands.toStringAsFixed(1)}k';
    } else {
      // Format as regular amount with 2 decimals
      return NumberFormat.currency(
        symbol: '\$',
        decimalDigits: 2,
      ).format(amount);
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Color _getCategoryColor(BuildContext context) {
    if (transaction.category?.color != null) {
      try {
        return Color(int.parse(
            transaction.category!.color!.replaceFirst('#', '0xFF')));
      } catch (e) {
        // Fallback to type-based color if color parsing fails
      }
    }
    // Fallback to type-based color if no category color
    return transaction.type == TransactionType.expense
        ? Colors.red
        : Colors.green;
  }

  IconData? _getCategoryIcon() {
    if (transaction.category?.icon != null) {
      return _getIconFromName(transaction.category!.icon);
    }
    // Fallback to type-based icon if no category icon
    return transaction.type == TransactionType.expense
        ? Icons.arrow_downward
        : Icons.arrow_upward;
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(context);
    final categoryIcon = _getCategoryIcon();

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Slidable(
        key: ValueKey('transaction_${transaction.id}'),
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
            onTap: onTap,
          leading: Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: categoryColor,
                width: 2,
              ),
            ),
            child: categoryIcon != null &&
                    transaction.category?.icon != null
                ? Center(
                    child: FaIcon(
                      categoryIcon,
                      color: categoryColor,
                      size: 24.sp,
                    ),
                  )
                : Center(
                    child: Icon(
                      categoryIcon ?? Icons.category,
                      color: categoryColor,
                      size: 24.sp,
                    ),
                  ),
          ),
          title: Text(
            transaction.category?.name ?? context.l10n.category,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            _formatDate(transaction.transactionDate),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatAmount(transaction.amount),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (transaction.note != null && transaction.note!.isNotEmpty)
                Text(
                  transaction.note!,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

