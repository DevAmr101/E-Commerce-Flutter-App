import 'package:e_com/core/cubit/cart_cubit.dart';
import 'package:e_com/core/models/product_model.dart';
import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart'; // 👈 استيراد الكوبيت
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 👈 استيراد الـ Bloc
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 16.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeightSpace(16),

              // صورة المنتج من الـ API
              Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const HeightSpace(20),

              // القسم + التقييم الديناميكي
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: AppStyles.black15BoldStyle.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),

                  // شريط التقييم والمراجعات الديناميكي
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 22.sp),
                      const WidthSpace(4),
                      Text(
                        "${product.rating.rate}",
                        style: AppStyles.black16w500Style.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const WidthSpace(4),
                      Text(
                        "(${product.rating.count} reviews)",
                        style: AppStyles.subtitlesStyles.copyWith(
                          fontSize: 13.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const HeightSpace(16),

              // عنوان المنتج بالكامل داخل الجسم
              Text(
                product.title,
                style: AppStyles.black16w500Style.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const HeightSpace(16),

              // الوصف
              Text(
                "Description",
                style: AppStyles.black16w500Style.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const HeightSpace(8),
              Text(
                product.description,
                style: AppStyles.subtitlesStyles.copyWith(
                  color: Colors.black87,
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),

              const HeightSpace(24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Price",
                    style: AppStyles.subtitlesStyles.copyWith(
                      color: Colors.grey,
                      fontSize: 13.sp,
                    ),
                  ),
                  const HeightSpace(2),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: AppStyles.black16w500Style.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),

              SizedBox(
                width: 180.w,
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // 🛒 إضافة المنتج للسلة عبر الكوبيت
                    context.read<CartCubit>().addProduct(product);

                    // 🔔 إظهار إشعار نجاح الإضافة
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${product.title} added to cart!"),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.primaryColor,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  label: Text(
                    "Add To Cart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}