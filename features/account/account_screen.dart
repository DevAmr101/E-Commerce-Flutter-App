import 'package:e_com/core/di/service_locator.dart';

import 'package:e_com/core/routing/app_routes.dart';
import 'package:e_com/core/secure_storage_helper.dart';
import 'package:e_com/core/styling/app_assets.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:e_com/features/account/widgets/account_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  // دالة التعامل مع عملية تسجيل الخروج
  Future<void> _handleLogout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      // 1️⃣ حذف الـ Token المحفوظ في Secure Storage
      await getIt<SecureStorageHelper>().deleteToken();

      if (!context.mounted) return;

      // 2️⃣ الانتقال لشاشة التسجيل مع إعادة تعيين الهيكلية
      context.goNamed(AppRoutes.loginScreenName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: const Divider(),
          ),
          const HeightSpace(26),
          AccountItemWidget(
            title: "My Orders",
            onTap: () {},
            iconPath: AppAssets.box,
          ),
          const HeightSpace(16),
          const Divider(thickness: 7),
          const HeightSpace(7),
          AccountItemWidget(
            title: "Details",
            onTap: () {},
            iconPath: AppAssets.details,
          ),
          const HeightSpace(7),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: const Divider(),
          ),
          const HeightSpace(7),
          AccountItemWidget(
            title: "Address",
            onTap: () {
              GoRouter.of(context).pushNamed(AppRoutes.addressScreenName);
            },
            iconPath: AppAssets.address,
          ),
          const HeightSpace(7),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: const Divider(),
          ),
          const HeightSpace(7),
          AccountItemWidget(
            title: "FAQs",
            onTap: () {},
            iconPath: AppAssets.question,
          ),
          const HeightSpace(7),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: const Divider(),
          ),
          const HeightSpace(7),
          AccountItemWidget(
            title: "Help Center",
            onTap: () {},
            iconPath: AppAssets.headphone,
          ),
          const HeightSpace(7),
          const Divider(thickness: 7),
          const Spacer(),
          
          // 3️⃣ منطقة تسجيل الخروج مغلفة بـ InkWell لتشمل الأيقونة والنص معاً
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: InkWell(
              onTap: () => _handleLogout(context),
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      color: Colors.redAccent.shade400,
                      size: 26.sp,
                    ),
                    const WidthSpace(11),
                    Text(
                      "Log Out",
                      style: AppStyles.black15BoldStyle.copyWith(
                        color: Colors.redAccent.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const HeightSpace(20),
        ],
      ),
    );
  }
}


