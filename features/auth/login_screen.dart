import 'package:e_com/core/di/service_locator.dart';
import 'package:e_com/core/routing/app_routes.dart';
import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/utils/animated_snack_dialoge.dart';
import 'package:e_com/core/widgets/custom_text_field.dart';
import 'package:e_com/core/widgets/primay_button_widget.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:e_com/features/auth/cubit/auth_cubit.dart';
import 'package:e_com/features/auth/cubit/auth_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1️⃣ توفير الـ AuthCubit للشاشة عبر getIt
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: const _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody();

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TapGestureRecognizer signupTapRecognizer;

  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    signupTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        if (mounted) {
          context.pushNamed(AppRoutes.signUpScreenName);
        }
      };
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    signupTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeightSpace(26),
                  SizedBox(
                    width: 326.w,
                    child: Text(
                      "Login To Your Account",
                      style: AppStyles.primaryHeadLinesStyle,
                    ),
                  ),
                  const HeightSpace(7),
                  SizedBox(
                    width: 326.w,
                    child: Text(
                      "It's a pleasure to have you back! Please enter your details.",
                      style: AppStyles.subtitlesStyles.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                  const HeightSpace(18),
                  Text("Username", style: AppStyles.black15BoldStyle),
                  const HeightSpace(7),
                  CustomTextField(
                    controller: usernameController,
                    hintText: "Enter Your Username",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter Your Username";
                      }
                      return null;
                    },
                  ),
                  const HeightSpace(15),
                  Text("Password", style: AppStyles.black15BoldStyle),
                  const HeightSpace(7),
                  CustomTextField(
                    hintText: "Enter Your Password",
                    controller: passwordController,
                    obscureText: isObscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.greyColor,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Your Password";
                      }
                      if (value.length < 4) {
                        return "Password must be at least 4 characters";
                      }
                      return null;
                    },
                  ),
                  const HeightSpace(12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        if (mounted) {
                          context.pushNamed(AppRoutes.forgetPasswordName);
                        }
                      },
                      child: Text(
                        "Forgot Password?",
                        style: AppStyles.black15BoldStyle.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  const HeightSpace(26),

                  // 2️⃣ استخدام BlocConsumer لإدارة الحالات والتنبيهات
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        AnimatedSnackDialoge.showError(
                          context: context,
                          message: state.message,
                        );
                      } else if (state is AuthSuccess) {
                        AnimatedSnackDialoge.showSuccess(
                          context: context,
                          message: "Welcome back!",
                        );
                        context.goNamed(AppRoutes.mainScreenName);
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }

                      return PrimayButtonWidget(
                        buttonText: "Login",
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            // استدعاء دالة التسجيل من AuthCubit
                            context.read<AuthCubit>().login(
                                  username: usernameController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                          }
                        },
                      );
                    },
                  ),

                  const HeightSpace(40),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: AppStyles.black15BoldStyle.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 18.sp,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: AppStyles.black15BoldStyle.copyWith(
                              fontSize: 18.sp,
                            ),
                            recognizer: signupTapRecognizer,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const HeightSpace(26),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}