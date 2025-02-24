import 'package:actual/product/model/product_model.dart';
import 'package:actual/user/model/bakset_item_model.dart';
import 'package:actual/user/model/patch_basket_body.dart';
import 'package:actual/user/repository/user_me_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  return BasketProvider(userMeRepository: userMeRepository);
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository userMeRepository;

  BasketProvider({
    required this.userMeRepository,
  }) : super([]);

  Future<void> patchBasket() async {
    await userMeRepository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;
    if (exists) {
      state = state
          .map((e) => e.product.id == product.id
              ? e.copyWith(
                  count: e.count + 1,
                )
              : e)
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        )
      ];
    }

    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDeleteForce = false,
  }) async {
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;
    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);
    if (existingProduct.count == 1 || isDeleteForce) {
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = state
          .map((e) => e.product.id == product.id
              ? e.copyWith(
                  count: e.count - 1,
                )
              : e)
          .toList();
    }

    await patchBasket();
  }
}
