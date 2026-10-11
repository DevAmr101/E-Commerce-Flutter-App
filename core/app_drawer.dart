import 'package:e_com/core/di/service_locator.dart';
import 'package:e_com/core/routing/app_routes.dart';
import 'package:e_com/core/secure_storage_helper.dart';
import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final String selectedCategory;
  final Function(String categoryDisplayName) onCategorySelected;

  const AppDrawer({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const Map<String, IconData> categoriesWithIcons = {
    "All": Icons.grid_view_rounded,
    "Men's Apparel": Icons.checkroom_rounded,
    "Women's Apparel": Icons.female_outlined,
    "Fine Jewelry": Icons.diamond_outlined,
    "Electronics": Icons.devices_other_rounded,
  };

  // 🛠️ دالة التعامل مع تأكيد تسجيل الخروج
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
      // 1. حذف التوكن من التخزين الآمن
      await getIt<SecureStorageHelper>().deleteToken();

      if (!context.mounted) return;

      // 2. التوجيه لشاشة تسجيل الدخول ومسح التاريخ
      context.goNamed(AppRoutes.loginScreenName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 50.h,
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.w),
                  ),
                  child: CircleAvatar(
                    radius: 32.r,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primaryColor,
                      size: 34.sp,
                    ),
                  ),
                ),
                const HeightSpace(12),
                Text(
                  "Welcome Back! 👋",
                  style: AppStyles.primaryHeadLinesStyle.copyWith(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const HeightSpace(4),
                Text(
                  "Explore & Shop Your Favorites",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

          // القائمة
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              children: [
                _buildSectionHeader("Product Categories"),
                const HeightSpace(6),

                ...categoriesWithIcons.entries.map((entry) {
                  final displayName = entry.key;
                  final icon = entry.value;
                  final isSelected = selectedCategory == displayName;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: ListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      tileColor: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      leading: Icon(
                        icon,
                        size: 22.sp,
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.grey.shade700,
                      ),
                      title: Text(
                        displayName,
                        style: AppStyles.black15BoldStyle.copyWith(
                          fontSize: 14.sp,
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected
                          ? Container(
                              width: 6.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                      onTap: () {
                        onCategorySelected(displayName);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(thickness: 1, height: 1),
                ),

                _buildSectionHeader("Quick Access"),
                const HeightSpace(6),

                // 🛒 رابط السلة (My Cart)
                _buildDrawerTile(
                  icon: Icons.shopping_cart_outlined,
                  title: "My Cart",
                  onTap: () {
                    Navigator.pop(context); // غلق الـ Drawer أولاً
                    context.pushNamed(AppRoutes.cartScreenName); // الانتقال لشاشة السلة
                  },
                ),
                
                // 📦 رابط الطلبات (My Orders)
                _buildDrawerTile(
                  icon: Icons.local_shipping_outlined,
                  title: "My Orders",
                  onTap: () {
                    Navigator.pop(context);
                    // context.pushNamed(AppRoutes.ordersScreenName);
                  },
                ),
                
                // 🧡 رابط المفضلة (Wishlist)
                _buildDrawerTile(
                  icon: Icons.favorite_border_rounded,
                  title: "Wishlist",
                  onTap: () {
                    Navigator.pop(context); // غلق الـ Drawer أولاً
                    context.pushNamed(AppRoutes.wishlistScreenName); // الانتقال لشاشة المفضلة
                  },
                ),
                
                // 📍 رابط العناوين (Addresses)
                _buildDrawerTile(
                  icon: Icons.location_on_outlined,
                  title: "Addresses",
                  onTap: () {
                    Navigator.pop(context);
                    // context.pushNamed(AppRoutes.addressesScreenName);
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(thickness: 1, height: 1),
                ),

                // ⚙️ الإعدادات (Settings)
                _buildDrawerTile(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                // 🚪 تسجيل الخروج (Logout) مع رسالة التأكيد
                _buildDrawerTile(
                  icon: Icons.logout_rounded,
                  title: "Logout",
                  textColor: Colors.redAccent,
                  iconColor: Colors.redAccent,
                  onTap: () async {
                    Navigator.pop(context); // غلق الـ Drawer أولاً
                    await _handleLogout(context); // إظهار نافذة التأكيد التنفيذية
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
    Color iconColor = Colors.grey,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        leading: Icon(icon, size: 22.sp, color: iconColor),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}