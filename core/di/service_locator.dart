import 'package:dio/dio.dart';
import 'package:e_com/core/cubit/products_cubit.dart';
import 'package:e_com/core/networking/api_endpoints.dart';
import 'package:e_com/core/networking/dio_helper.dart';
import 'package:e_com/core/products_repo.dart';
import 'package:e_com/core/secure_storage_helper.dart';
import 'package:e_com/features/auth/cubit/auth_cubit.dart';
import 'package:e_com/features/auth/repo/auth_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // 1️⃣ Flutter Secure Storage & SecureStorageHelper
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper(getIt<FlutterSecureStorage>()),
  );

  // 2️⃣ Dio (إعدادات شبكة الاتصال)
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Connection': 'keep-alive',
        },
        receiveDataWhenStatusError: true,
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

    return dio;
  });

  // 3️⃣ DioHelper
  getIt.registerLazySingleton<DioHelper>(
    () => DioHelper(getIt<Dio>()),
  );

  // 4️⃣ Authentication (AuthRepo & AuthCubit)
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(getIt<DioHelper>()),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<AuthRepo>(),
      getIt<SecureStorageHelper>(),
    ),
  );

  // 5️⃣ Home & Products (ProductsRepo & ProductsCubit)
  getIt.registerLazySingleton<ProductsRepo>(
    () => ProductsRepo(getIt<DioHelper>()),
  );

  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(getIt<ProductsRepo>()),
  );
}