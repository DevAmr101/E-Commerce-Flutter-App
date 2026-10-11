import 'package:e_com/core/cubit/cart_cubit.dart';
import 'package:e_com/core/cubit/wishlist_cubit.dart';
import 'package:e_com/core/models/product_model.dart';
import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Wishlist",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<WishlistCubit, List<ProductModel>>(
        builder: (context, wishlist) {
          // 🎨 1. تصميم احترافي لحالة المفضلة الفارغة (Empty State)
          if (wishlist.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.sp),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 64.sp,
                        color: Colors.redAccent.withValues(alpha: 0.7),
                      ),
                    ),
                    const HeightSpace(16),
                    Text(
                      "Your Wishlist is Empty",
                      style: AppStyles.black15BoldStyle.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const HeightSpace(8),
                    Text(
                      "Save your favorite items here so you can find them easily later.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // 🛍️ 2. قائمة المنتجات المفضلة بتصميم بطاقات أنيقة (Cards)
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            itemCount: wishlist.length,
            separatorBuilder: (context, index) => const HeightSpace(12),
            itemBuilder: (context, index) {
              final product = wishlist[index];
              return Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // صورة المنتج
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        width: 75.w,
                        height: 75.h,
                        color: Colors.grey.shade100,
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const WidthSpace(12),
                    
                    // تفاصيل المنتج (العنوان والسعر)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.black15BoldStyle.copyWith(
                              fontSize: 13.sp,
                            ),
                          ),
                          const HeightSpace(6),
                          Text(
                            "\$${product.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // أزرار التفاعل (إضافة للسلة + حذف من المفضلة)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // زر الحذف من المفضلة
                        InkWell(
                          onTap: () {
                            context.read<WishlistCubit>().toggleFavorite(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Removed from wishlist"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(4.sp),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 20.sp,
                            ),
                          ),
                        ),
                        const HeightSpace(8),
                        // زر إضافة للسلة مباشرة
                        InkWell(
                          onTap: () {
                            context.read<CartCubit>().addProduct(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${product.title} added to cart!"),
                                duration: const Duration(seconds: 1),
                                backgroundColor: AppColors.primaryColor,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(6.sp),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(
                              Icons.add_shopping_cart_rounded,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}