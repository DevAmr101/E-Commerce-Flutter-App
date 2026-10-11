import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItemWidget extends StatelessWidget {
  final String categoryName;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItemWidget({
    super.key,
    required this.categoryName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 7.w),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 7.h,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            categoryName,
            style: AppStyles.black15BoldStyle.copyWith(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}