import 'package:e_com/core/cubit/cart_cubit.dart';
import 'package:e_com/core/cubit/products_cubit.dart';
import 'package:e_com/core/cubit/wishlist_cubit.dart'; // 👈 استيراد WishlistCubit
import 'package:e_com/core/di/service_locator.dart';
import 'package:e_com/core/routing/app_routes.dart';
import 'package:e_com/core/routing/router_generation_config.dart';
import 'package:e_com/core/secure_storage_helper.dart';
import 'package:e_com/core/styling/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator(); // تهيئة GetIt

  final bool isLoggedIn = await getIt<SecureStorageHelper>().hasToken();
  final String initialRoute = isLoggedIn ? AppRoutes.mainScreen : AppRoutes.loginScreen;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => WishlistCubit()), // 👈 توفير WishlistCubit على مستوى التطبيق
        BlocProvider(create: (context) => getIt<ProductsCubit>()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        routerConfig: RouterGenerationConfig.getRouter(initialRoute),
      ),
    );
  }
}