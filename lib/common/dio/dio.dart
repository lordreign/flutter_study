import 'package:actual/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Do something before request is sent
    print('REQUEST[${options.method}] => URI: ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
        'ERROR[${err.requestOptions.method}][${err.response?.statusCode}] => URI: ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/refresh';
    // 401 에러가 났을때 토큰 재발급 후 새로운 토큰으로 요청
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();
      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        err.requestOptions.headers.addAll({
          'Authorization': 'Bearer $accessToken',
        });

        // 요청 재전송
        final response = await dio.fetch(err.requestOptions);

        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }
    return handler.reject(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.requestOptions.method}] => URI: ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }
}
