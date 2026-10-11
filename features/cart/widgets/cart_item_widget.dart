import 'package:e_com/core/cubit/cart_cubit.dart';
import 'package:e_com/core/models/cart_item_model.dart';
import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem; // 👈 استقبال عنصر السلة

  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffE8ECF4), width: 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ صورة المنتج من الـ API
            Container(
              width: 83.w,
              height: 85.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  cartItem.product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            
            const WidthSpace(12),
            
            // 📄 تفاصيل المنتج
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الصف العلوي: اسم المنتج + زر الحذف
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          cartItem.product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.black15BoldStyle,
                        ),
                      ),
                      
                      const WidthSpace(8),
                      
                      // 🗑️ زر الحذف
                      GestureDetector(
                        onTap: () {
                          cartCubit.removeProduct(cartItem.product);
                        },
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
              
                  const HeightSpace(6),
              
                  // 💰 السعر الإجمالي لهذا العنصر بناءً على الكمية
                  Text(
                    "\$${cartItem.totalItemPrice.toStringAsFixed(2)}",
                    style: AppStyles.black16w500Style.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
              
                  const HeightSpace(8),
              
                  // 🔢 عداد زيادة ونقصان الكمية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // زر إنقاص الكمية (-)
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onTap: () {
                          cartCubit.decrementQuantity(cartItem);
                        },
                      ),
              
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          "${cartItem.quantity}",
                          style: AppStyles.black15BoldStyle.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
              
                      // زر زيادة الكمية (+)
                      _buildQuantityButton(
                        icon: Icons.add,
                        onTap: () {
                          cartCubit.incrementQuantity(cartItem);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🛠️ تصميم موحد لأزرار التحكم بالكمية
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.sp),
        decoration: BoxDecoration(
          color: const Color(0xffF7F8F9),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xffE8ECF4)),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: Colors.black87,
        ),
      ),
    );
  }
}