import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountItemWidget extends StatelessWidget {
  final String? title;
  final String? iconPath;
  final VoidCallback? onTap;

  const AccountItemWidget({
    super.key,
    this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            // الأيقونة والعنوان
            Row(
              children: [
                iconPath == null
                    ? const SizedBox.shrink()
                    : Image.asset(iconPath!, width: 26.sp, height: 26.sp),
                const WidthSpace(12),
                Text(
                  title ?? "",
                  style: AppStyles.black15BoldStyle.copyWith(fontSize: 16.sp),
                ),
              ],
            ),
            const Spacer(),
            // السهم التوجيهي
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.sp,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}