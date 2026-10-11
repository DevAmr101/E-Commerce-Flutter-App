import 'package:e_com/core/cubit/cart_cubit.dart';
import 'package:e_com/core/cubit/wishlist_cubit.dart'; // 👈 تأكد من استيراد WishlistCubit
import 'package:e_com/core/models/product_model.dart';
import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductModel product;
  final Function()? onTap;

  const ProductItemWidget({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: 161.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    width: 161.w,
                    height: 149.h,
                    color: Colors.grey.shade100,
                    child: product.image.isNotEmpty
                        ? Image.network(
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
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey,
                            ),
                          )
                        : Container(color: AppColors.primaryColor),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber, size: 14.sp),
                        SizedBox(width: 2.w),
                        Text(
                          "${product.rating.rate}",
                          style: AppStyles.black15BoldStyle.copyWith(
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const HeightSpace(7),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.black15BoldStyle.copyWith(fontSize: 13.sp),
            ),
            const HeightSpace(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: AppStyles.grey12MediumStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                Row(
                  children: [
                    // 🧡 زر المفضلة (Wishlist)
                    Material(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6.r),
                      child: InkWell(
                        onTap: () {
                          context.read<WishlistCubit>().toggleFavorite(product);
                        },
                        borderRadius: BorderRadius.circular(6.r),
                        child: Padding(
                          padding: EdgeInsets.all(6.sp),
                          child: BlocBuilder<WishlistCubit, List<ProductModel>>(
                            builder: (context, wishlist) {
                              final isFavorite = wishlist.contains(product);
                              return Icon(
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: isFavorite ? Colors.redAccent : Colors.grey,
                                size: 16.sp,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const WidthSpace(6),
                    // 🛒 زر السلة (Cart)
                    Material(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(6.r),
                      child: InkWell(
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
                        borderRadius: BorderRadius.circular(6.r),
                        child: Padding(
                          padding: EdgeInsets.all(6.sp),
                          child: Icon(
                            Icons.add_shopping_cart_rounded,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}