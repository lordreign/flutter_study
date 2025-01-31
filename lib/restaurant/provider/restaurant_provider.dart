import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  final cpState = state as CursorPagination;

  return cpState.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);

    return RestaurantStateNotifier(repository: repository);
  },
);

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    getRestaurants();
  }

  Future<void> getRestaurants({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading
    // false - 데이터를 유지한 상태에서 fetch
    bool forceRefetch = false,
  }) async {
    // 5가지 가능성
    // 1. CursorPagination - 정상적으로 데이터가 있는 상태
    // 2. CursorPaginationLoading - 데이터를 로딩중인 상태(캐시 없음)
    // 3. CursorPaginationError - 데이터를 가져오는 중 에러가 발생한 상태
    // 4. CursorPaginationRefetching - 데이터를 다시 가져오는 중
    // 5. CursorPaginationFetchingMore - 추가 데이터를 가져오는 중

    try {
      // hasMore = false
      if (state is CursorPagination && !forceRefetch) {
        final cpState = state as CursorPagination;
        if (!cpState.meta.hasMore) {
          return;
        }
      }

      // 로딩중 - fetchMore = true
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // pagination params 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore = true
      if (fetchMore) {
        final cpState = state as CursorPagination;
        state = CursorPaginationFetchingMore(
          meta: cpState.meta,
          data: cpState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: cpState.data.last.id,
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 데이터가 있다면 기존 데이터를 보존한 상태로 진행
        if (state is CursorPagination && !forceRefetch) {
          final cpState = state as CursorPagination;
          state = CursorPaginationRefetching(
            meta: cpState.meta,
            data: cpState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.getRestaurants(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final cpState = state as CursorPaginationFetchingMore;

        state = resp.copyWith(
          data: [
            ...cpState.data,
            ...resp.data,
          ],
        );
      } else {
        // refetch나 loading일 경우
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(
        message: '데이터를 가져오지 못했습니다.',
      );
    }
  }

  void getDetail({
    required String id,
  }) async {
    if (state is! CursorPagination) {
      await this.getRestaurants();
    }

    // 그래도 아니면
    if (state is! CursorPagination) {
      return;
    }

    final cpState = state as CursorPagination;
    final resp = await repository.getRestaurantDetail(id);
    state = cpState.copyWith(
      data: cpState.data
          .map<RestaurantModel>((e) => e.id == id ? resp : e)
          .toList(),
    );
  }
}
