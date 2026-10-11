import 'package:e_com/core/routing/app_routes.dart';
import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/custom_text_field.dart';
import 'package:e_com/core/widgets/primay_button_widget.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController fullNameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TapGestureRecognizer loginTapRecognizer;

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    loginTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        if (mounted) {
          context.pushNamed(AppRoutes.loginScreenName);
        }
      };
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    loginTapRecognizer.dispose();
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
                      "Create Your Account",
                      style: AppStyles.primaryHeadLinesStyle,
                    ),
                  ),
                  const HeightSpace(7),

                  SizedBox(
                    width: 326.w,
                    child: Text(
                      "Let's get started! Please enter your details to create an account.",
                      style: AppStyles.subtitlesStyles.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),

                  const HeightSpace(18),

                  Text("Full Name", style: AppStyles.black15BoldStyle),

                  const HeightSpace(7),
                  CustomTextField(
                    controller: fullNameController,
                    hintText: "Enter Your Full Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Your Full Name";
                      }
                      return null;
                    },
                  ),
                  const HeightSpace(15),

                  Text("Username", style: AppStyles.black15BoldStyle),

                  const HeightSpace(7),
                  CustomTextField(
                    controller: usernameController,
                    hintText: "Enter Your Username",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
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
                    obscureText: isPasswordObscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.greyColor,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordObscure = !isPasswordObscure;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Your Password";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                  ),
                  const HeightSpace(15),

                  Text("Confirm Password", style: AppStyles.black15BoldStyle),

                  const HeightSpace(7),
                  CustomTextField(
                    hintText: "Re-enter Your Password",
                    controller: confirmPasswordController,
                    obscureText: isConfirmPasswordObscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.greyColor,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordObscure = !isConfirmPasswordObscure;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const HeightSpace(26),

                  PrimayButtonWidget(
                    buttonText: "Sign Up",
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        if (mounted) {
                          context.pushNamed(AppRoutes.loginScreenName);
                        }
                      }
                    },
                  ),
                  const HeightSpace(40),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: AppStyles.black15BoldStyle.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 18.sp,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: AppStyles.black15BoldStyle.copyWith(
                              fontSize: 18.sp,
                            ),
                            recognizer: loginTapRecognizer,
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
