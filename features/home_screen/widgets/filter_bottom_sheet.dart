import 'package:e_com/core/cubit/products_cubit.dart';
import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SortOption selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = context.read<ProductsCubit>().currentSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط السحب بالأعلى
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          const HeightSpace(16),

          Text(
            "Sort Products",
            style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 18.sp),
          ),
          const HeightSpace(12),

          // 💡 استخدام RadioGroup لإدارة المجموعة الحديثة دون تحذيرات
          RadioGroup<SortOption>(
            groupValue: selectedOption,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedOption = value;
                });
              }
            },
            child: Column(
              children: [
                RadioListTile<SortOption>(
                  title: const Text("Default"),
                  value: SortOption.none,
                  activeColor: AppColors.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<SortOption>(
                  title: const Text("Price: Low to High"),
                  value: SortOption.priceLowToHigh,
                  activeColor: AppColors.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<SortOption>(
                  title: const Text("Price: High to Low"),
                  value: SortOption.priceHighToLow,
                  activeColor: AppColors.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<SortOption>(
                  title: const Text("Highest Rated"),
                  value: SortOption.topRated,
                  activeColor: AppColors.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          const HeightSpace(20),

          // زر التطبيق
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                context.read<ProductsCubit>().sortProducts(selectedOption);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                "Apply Filter",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const HeightSpace(8),
        ],
      ),
    );
  }
}