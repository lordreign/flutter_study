import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/order/provider/order_provider.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    if (basket.isEmpty) {
      return DefaultLayout(
        automaticallyImplyLeading: true,
        title: '장바구니',
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart,
                size: 100,
                color: Colors.grey.shade500,
              ),
              Text(
                '장바구니가 비어있습니다.',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }
    final productsTotal = basket.fold(
      0,
      (p, n) => p + n.product.price * n.count,
    );
    final deliveryFee =
        basket.isNotEmpty ? basket.first.product.restaurant.deliveryFee : 0;

    return DefaultLayout(
      automaticallyImplyLeading: true,
      title: '장바구니',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) {
                    return Divider(
                      height: 32.0,
                      color: Colors.grey.shade200,
                    );
                  },
                  itemBuilder: (_, index) {
                    final model = basket[index];

                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeFromBasket(product: model.product);
                      },
                    );
                  },
                  itemCount: basket.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '장바구니 금액',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      Text(
                        '₩' + productsTotal.toString(),
                        // style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '배달비',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      Text(
                        '₩' + deliveryFee.toString(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총액',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '₩' + (productsTotal + deliveryFee).toString(),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final resp =
                            await ref.read(orderProvider.notifier).postOrder();
                        if (resp) {
                          context.go('/order_done');
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('결제 실패')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('결제하기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
