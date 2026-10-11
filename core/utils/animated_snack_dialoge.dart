import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class AnimatedSnackDialoge {
  // 🟢 تنبيه النجاح (Success)
  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.success,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  // 🔴 تنبيه الخطأ (Error)
  static void showError({
    required BuildContext context,
    required String message,
  }) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.error,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      duration: const Duration(seconds: 4),
    ).show(context);
  }

  // 🟠 تنبيه التحذير (Warning)
  static void showWarning({
    required BuildContext context,
    required String message,
  }) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.warning,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  // 🔵 تنبيه معلومات (Info)
  static void showInfo({
    required BuildContext context,
    required String message,
  }) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.info,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}