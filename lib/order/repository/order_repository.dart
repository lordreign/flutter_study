import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/logger/parse_error_logger.dart';
import 'package:actual/order/model/order_model.dart';
import 'package:actual/order/model/post_order_body.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderRepository(dio);
});

@RestApi()
abstract class OrderRepository {
  factory OrderRepository(Dio dio,
      {String baseUrl, ParseErrorLogger? errorLogger}) = _OrderRepository;

  @POST('/order')
  @Headers({'accessToken': 'true'})
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
