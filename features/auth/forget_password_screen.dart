import 'package:e_com/core/styling/app_colors.dart';
import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/custom_text_field.dart';
import 'package:e_com/core/widgets/primay_button_widget.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailOrUsernameController;

  @override
  void initState() {
    super.initState();
    emailOrUsernameController = TextEditingController();
  }

  @override
  void dispose() {
    emailOrUsernameController.dispose();
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
                  const HeightSpace(20),

                  // 👈 زر الرجوع للخلف
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  const HeightSpace(26),

                  SizedBox(
                    width: 326.w,
                    child: Text(
                      "Forgot Password?",
                      style: AppStyles.primaryHeadLinesStyle,
                    ),
                  ),
                  const HeightSpace(7),

                  SizedBox(
                    width: 326.w,
                    child: Text(
                      "Don't worry! Please enter your email or username associated with your account.",
                      style: AppStyles.subtitlesStyles.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),

                  const HeightSpace(26),

                  Text("Email or Username", style: AppStyles.black15BoldStyle),

                  const HeightSpace(7),

                  CustomTextField(
                    controller: emailOrUsernameController,
                    hintText: "Enter your email or username",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email or username";
                      }
                      return null;
                    },
                  ),

                  const HeightSpace(26),

                  PrimayButtonWidget(
                    buttonText: "Send Code",
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}