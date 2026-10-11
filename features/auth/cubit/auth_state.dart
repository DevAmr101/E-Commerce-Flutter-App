import 'package:e_com/features/auth/models/login_response_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthSuccess extends AuthState {
  final LoginResponseModel responseModel; // 👈 تعديل النوع ليكون نفس الناتج من الـ Repo
  AuthSuccess(this.responseModel);
}