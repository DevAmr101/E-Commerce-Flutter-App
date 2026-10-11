import 'dart:developer';
import 'package:dio/dio.dart';

class DioHelper {
  final Dio dio;

  DioHelper(this.dio);

  Future<Response?> getRequest({
    required String endPoint,
    Map<String, dynamic>? query,
  }) async {
    try {
      Response response = await dio.get(
        endPoint,
        queryParameters: query,
      );
      return response;
    } on DioException catch (e) {
      log("DioError in GET ($endPoint): ${e.message}");
      if (e.response != null) {
        return e.response;
      }
      rethrow;
    } catch (e) {
      log("General Error in GET ($endPoint): $e");
      rethrow;
    }
  }

  Future<Response?> postRequest({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await dio.post(
        endPoint,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      log("DioError in POST ($endPoint): ${e.message}");
      if (e.response != null) {
        return e.response;
      }
      rethrow;
    } catch (e) {
      log("General Error in POST ($endPoint): $e");
      rethrow;
    }
  }
}