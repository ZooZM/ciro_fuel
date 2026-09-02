import 'package:dio/dio.dart';

import '../../domain/entities/profile_user.dart';
import '../models/profile_mapper.dart';

/// `GET/PATCH /users/:id` and `PATCH /users/:id/profile-picture` (spec 005
/// T099/T103), plus `GET /files/:id` to render the picture those requests
/// point at — grouped here rather than a separate "files" feature since
/// profile is the only place the app downloads a file today.
abstract interface class ProfileRemoteDataSource {
  Future<ProfileUser> getProfile(String userId);

  Future<ProfileUser> updateFullName(String userId, String fullName);

  Future<ProfileUser> uploadProfilePicture(String userId, String filePath);

  Future<List<int>> downloadFile(String fileId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ProfileUser> getProfile(String userId) async {
    final response = await _dio.get<Map<String, dynamic>>('/users/$userId');
    return ProfileMapper.fromJson(response.data!);
  }

  @override
  Future<ProfileUser> updateFullName(String userId, String fullName) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/users/$userId',
      data: {'fullName': fullName},
    );
    return ProfileMapper.fromJson(response.data!);
  }

  @override
  Future<ProfileUser> uploadProfilePicture(
    String userId,
    String filePath,
  ) async {
    // Field name is `'file'` — must match the backend's
    // `@UseInterceptors(FileInterceptor('file'))` (users.controller.ts).
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });
    final response = await _dio.patch<Map<String, dynamic>>(
      '/users/$userId/profile-picture',
      data: formData,
    );
    return ProfileMapper.fromJson(response.data!);
  }

  @override
  Future<List<int>> downloadFile(String fileId) async {
    final response = await _dio.get<List<int>>(
      '/files/$fileId',
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data!;
  }
}
