import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/login_response.dart';
import 'package:actual/common/model/token_response.dart';
import 'package:actual/common/utils/data_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepository(dio: ref.watch(dioProvider)));

class AuthRepository {
  final Dio dio;

  AuthRepository({
    required this.dio,
  });

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final serialized = DataUtils.plainToBase64('$username:$password');
    final resp = await dio.post(
      '/auth/login',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $serialized',
        },
      ),
    );

    return LoginResponse.fromJson(resp.data);
  }

  Future<TokenResponse> token() async {
    final resp = await dio.post(
      '/auth/token',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'refreshToken': 'true',
        },
      ),
    );

    return TokenResponse.fromJson(resp.data);
  }
}
