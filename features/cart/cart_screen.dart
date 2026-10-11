import 'package:e_com/core/cubit/cart_cubit.dart';
import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:e_com/features/cart/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // استخدام BlocBuilder للاستماع لتحديثات السلة
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          // إذا كانت السلة فارغة أو في البداية
          if (state is! CartUpdated || state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64.sp, color: Colors.grey.shade400),
                  const HeightSpace(16),
                  Text(
                    "Your cart is empty",
                    style: AppStyles.black15BoldStyle.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // إذا كان هناك منتجات في السلة
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeightSpace(16),
                  // بناء قائمة المنتجات الحقيقية بناءً على الـ State
                  ...state.items.map((cartItem) {
                    return CartItemWidget(cartItem: cartItem);
                  }),
                  const HeightSpace(8),
                ],
              ),
            ),
          );
        },
      ),

      // شريط المجموع في الأسفل يتحدث ديناميكياً
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final isCartEmpty = state is! CartUpdated || state.items.isEmpty;
          final subTotal = isCartEmpty ? 0.0 : state.subTotal;
          final vat = isCartEmpty ? 0.0 : state.vat;
          final shippingFee = isCartEmpty ? 0.0 : state.shippingFee;
          final total = isCartEmpty ? 0.0 : state.total;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSummaryRow(title: "Sub-total", value: "\$${subTotal.toStringAsFixed(2)}"),
                  const HeightSpace(8),
                  _buildSummaryRow(title: "VAT (14%)", value: "\$${vat.toStringAsFixed(2)}"),
                  const HeightSpace(8),
                  _buildSummaryRow(title: "Shipping Fee", value: "\$${shippingFee.toStringAsFixed(2)}"),
                  const HeightSpace(12),
                  const Divider(color: Color(0xffE8ECF4), thickness: 1),
                  const HeightSpace(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: AppStyles.black15BoldStyle.copyWith(fontSize: 17.sp),
                      ),
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: AppStyles.black15BoldStyle.copyWith(fontSize: 18.sp, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                  const HeightSpace(20),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: isCartEmpty ? null : () {}, // تعطيل الزر لو السلة فارغة
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Go to Checkout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const WidthSpace(8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.subtitlesStyles.copyWith(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: AppStyles.black16w500Style.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}


