import 'package:e_com/core/secure_storage_helper.dart';
import 'package:e_com/features/auth/cubit/auth_state.dart';
import 'package:e_com/features/auth/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  final SecureStorageHelper _secureStorageHelper; // 👈 إضافة الـ Storage

  AuthCubit(this._authRepo, this._secureStorageHelper) : super(AuthInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _authRepo.login(
      username: username,
      password: password,
    );

    result.fold(
      (failureMessage) => emit(AuthError(failureMessage)),
      (loginResponse) async {
        // 🔑 حفظ الـ Token المشفّر فوراً
        if (loginResponse.token != null) {
          await _secureStorageHelper.saveToken(loginResponse.token!);
        }
        emit(AuthSuccess(loginResponse));
      },
    );
  }
}