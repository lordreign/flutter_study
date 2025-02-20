import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/logger/parse_error_logger.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>(
  (ref) => UserMeRepository(ref.watch(dioProvider)),
);

@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio,
      {String baseUrl, ParseErrorLogger? errorLogger}) = _UserMeRepository;

  @GET('/user/me')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getMe();
}
