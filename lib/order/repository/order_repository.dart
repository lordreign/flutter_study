import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/logger/parse_error_logger.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
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
abstract class OrderRepository
    implements IBasePaginationRepository<OrderModel> {
  factory OrderRepository(Dio dio,
      {String baseUrl, ParseErrorLogger? errorLogger}) = _OrderRepository;

  @GET('/order')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<OrderModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @POST('/order')
  @Headers({'accessToken': 'true'})
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
