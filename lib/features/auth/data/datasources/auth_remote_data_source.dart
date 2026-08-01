import 'package:dio/dio.dart';

import '../../../../core/network/request_extras.dart';
import '../../../../shared/entities/auth_user.dart';
import '../models/login_response_model.dart';

/// `/auth/refresh` is deliberately NOT exposed here: [AuthInterceptor] owns
/// the entire refresh lifecycle (reactive, single-flight, on any 401). A
/// second, repository-level refresh path would risk two independent
/// refresh flows racing each other.
abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthUser> me();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
      options: Options(extra: {RequestExtraKeys.skipAuth: true}),
    );
    return LoginResponseModel.fromJson(response.data!);
  }

  @override
  Future<AuthUser> me() async {
    final response = await _dio.get<Map<String, dynamic>>('/auth/me');
    return AuthUser.fromJson(response.data!);
  }
}
