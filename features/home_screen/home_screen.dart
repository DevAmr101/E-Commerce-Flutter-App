import 'package:e_com/core/app_drawer.dart';
import 'package:e_com/core/cubit/products_cubit.dart';
import 'package:e_com/core/di/service_locator.dart';
import 'package:e_com/core/routing/app_routes.dart';
import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/custom_text_field.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:e_com/features/home_screen/widgets/category_item_widget.dart';
import 'package:e_com/features/home_screen/widgets/filter_bottom_sheet.dart';
import 'package:e_com/features/home_screen/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductsCubit>()..getProducts(),
      child: const _HomeScreenBody(),
    );
  }
}

class _HomeScreenBody extends StatefulWidget {
  const _HomeScreenBody();

  @override
  State<_HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<_HomeScreenBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Map<String, String> categoriesMap = {
    "All": "All",
    "Men's Apparel": "men's clothing",
    "Women's Apparel": "women's clothing",
    "Fine Jewelry": "jewelery",
    "Electronics": "electronics",
  };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();

    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          
          // القائمة الجانبية
          drawer: AppDrawer(
            selectedCategory: cubit.selectedCategory,
            onCategorySelected: (category) {
              cubit.selectCategory(category);
              setState(() {});
            },
          ),

          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeightSpace(16),

                  // الهيدر الرئيسي: زر المنيو + العنوان
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Container(
                          width: 44.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.menu_rounded,
                            color: Colors.black87,
                            size: 24.sp,
                          ),
                        ),
                      ),
                      Text(
                        "Discover Products",
                        style: AppStyles.primaryHeadLinesStyle.copyWith(
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(width: 44.w),
                    ],
                  ),

                  const HeightSpace(20),

                  // شريط البحث وزر الفلتر
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            prefixIcon: Icon(
                              Icons.search,
                              color: const Color(0xff8391A1),
                              size: 22.sp,
                            ),
                            hintText: "Search for products...",
                            onChanged: (value) {
                              cubit.searchProducts(value);
                            },
                            onSubmitted: (value) {
                              cubit.searchProducts(value);
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        const WidthSpace(9),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.r),
                                ),
                              ),
                              builder: (bottomSheetContext) {
                                return BlocProvider.value(
                                  value: cubit,
                                  child: const FilterBottomSheet(),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 56.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: const Icon(
                              Icons.filter_list_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const HeightSpace(20),

                  // الشريط الأفقي للأقسام
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categoriesMap.keys.map((displayName) {
                        return CategoryItemWidget(
                          categoryName: displayName,
                          isSelected: cubit.selectedCategory == displayName,
                          onTap: () {
                            cubit.selectCategory(displayName);
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const HeightSpace(20),

                  // شبكة المنتجات
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is ProductsLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        } else if (state is ProductsError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.message,
                                  style: AppStyles.black15BoldStyle.copyWith(
                                    color: Colors.redAccent,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const HeightSpace(12),
                                ElevatedButton(
                                  onPressed: () {
                                    cubit.getProducts();
                                  },
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          );
                        } else if (state is ProductsSuccess) {
                          if (state.products.isEmpty) {
                            return const Center(
                              child: Text("No products found"),
                            );
                          }

                          return GridView.builder(
                            itemCount: state.products.length,
                            padding: EdgeInsets.only(bottom: 16.h),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20.w,
                              mainAxisSpacing: 20.h,
                              childAspectRatio: 0.65,
                            ),
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              return ProductItemWidget(
                                product: product, // 👈 تم التعديل لتمرير الكائن كاملاً بنجاح
                                onTap: () {
                                  GoRouter.of(context).pushNamed(
                                    AppRoutes.productDetailsName,
                                    extra: product,
                                  );
                                },
                              );
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}



