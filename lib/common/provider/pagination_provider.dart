import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PaginationInfo {
  final int fetchCount;

  // 추가로 데이터 더 가져오기
  // true - 추가로 데이터 더 가져옴
  // false - 새로고침
  final bool fetchMore;

  // 강제로 다시 로딩하기
  // true - CursorPaginationLoading
  // false - 데이터를 유지한 상태에서 fetch
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  U repository;
  final paginationThrottle = Throttle(
    const Duration(milliseconds: 700),
    initialValue: _PaginationInfo(),
    checkEquality: false, // true: 실행할때 마다 값이 똑같으면 실행하지 않음(기본값)
  );

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();

    paginationThrottle.values.listen((state) {
      _throttlePagination(state);
    });
  }

  Future<void> paginate({
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
    paginationThrottle.setValue(_PaginationInfo(
      fetchCount: fetchCount,
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
    ));
  }

  _throttlePagination(_PaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;
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
        final cpState = state as CursorPagination<T>;
        state = CursorPaginationFetchingMore<T>(
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
          final cpState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
            meta: cpState.meta,
            data: cpState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final cpState = state as CursorPaginationFetchingMore<T>;

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
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(
        message: '데이터를 가져오지 못했습니다.',
      );
    }
  }
}
