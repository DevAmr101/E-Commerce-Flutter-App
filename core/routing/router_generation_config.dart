import 'package:e_com/core/models/product_model.dart';
import 'package:e_com/core/routing/app_routes.dart';
import 'package:e_com/core/wishlist_screen.dart';
import 'package:e_com/features/address/address_screen.dart';
import 'package:e_com/features/auth/forget_password_screen.dart';
import 'package:e_com/features/auth/login_screen.dart';
import 'package:e_com/features/auth/signup_screen.dart';
import 'package:e_com/features/cart/cart_screen.dart';
import 'package:e_com/features/main_screen/main_screen.dart';
import 'package:e_com/features/product_details_screen/product_details_screen.dart';
import 'package:go_router/go_router.dart';

class RouterGenerationConfig {
  static GoRouter getRouter(String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.loginScreen,
          name: AppRoutes.loginScreenName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.signUpScreen,
          name: AppRoutes.signUpScreenName,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: AppRoutes.mainScreen,
          name: AppRoutes.mainScreenName,
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: AppRoutes.forgetPassword,
          name: AppRoutes.forgetPasswordName,
          builder: (context, state) => const ForgetPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.productDetails,
          name: AppRoutes.productDetailsName,
          builder: (context, state) {
            final product = state.extra as ProductModel;
            return ProductDetailsScreen(product: product);
          },
        ),
        GoRoute(
          path: AppRoutes.addressScreen,
          name: AppRoutes.addressScreenName,
          builder: (context, state) => const AddressScreen(),
        ),
        // 🛒 مسار شاشة السلة
        GoRoute(
          path: AppRoutes.cartScreen,
          name: AppRoutes.cartScreenName,
          builder: (context, state) => const CartScreen(),
        ),
        // 🧡 مسار شاشة المفضلة المفعّل
        GoRoute(
          path: AppRoutes.wishlistScreen,
          name: AppRoutes.wishlistScreenName,
          builder: (context, state) => const WishlistScreen(), // 👈 2. إلغاء التعليق هنا
        ),
      ],
    );
  }
}

