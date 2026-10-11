import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:e_com/core/networking/api_endpoints.dart';
import 'package:e_com/core/networking/dio_helper.dart';
import 'package:e_com/features/auth/models/login_response_model.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepo {
  final DioHelper dioHelper;

  // استقبال التبعية عبر الـ Constructor (Dependency Injection)
  AuthRepo(this.dioHelper);

  Future<Either<String, LoginResponseModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      // استخدام الكائن الممرر بدلاً من الاستدعاء الساكن
      final response = await dioHelper.postRequest(
        endPoint: ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      dev.log("Status: ${response?.statusCode}", name: 'AuthRepo');
      dev.log("Body: ${response?.data}", name: 'AuthRepo');

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final loginResponse = LoginResponseModel.fromJson(response.data);

        dev.log(
          "✅ Login Success! Token: ${loginResponse.token}",
          name: 'AuthRepo',
        );

        return Right(loginResponse);
      } else {
        dev.log(
          "❌ Login Failed with status: ${response?.statusCode}",
          name: 'AuthRepo',
          error: response?.data,
        );

        return const Left("Invalid username or password.");
      }
    } on DioException catch (e) {
      dev.log("Dio Error on Login: ${e.message}", name: 'AuthRepo', error: e);

      String errorMessage = "Connection error with the server.";
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            "Connection timeout. Please check your internet connection.";
      } else if (e.response != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage =
              e.response?.data['message'].toString() ?? "Server error occurred.";
        } else {
          errorMessage =
              e.response?.data.toString() ?? "An unexpected server error occurred.";
        }
      }

      return Left(errorMessage);
    } catch (e, stackTrace) {
      dev.log(
        "Unexpected Error",
        name: 'AuthRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left("An unexpected error occurred: ${e.toString()}");
    }
  }
}