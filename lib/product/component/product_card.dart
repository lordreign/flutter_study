import 'package:actual/common/const/colors.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final String id;
  final Image image;
  final String name;
  final String detail;
  final int price;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;

  const ProductCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    this.onAdd,
    this.onSubtract,
  });

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        fit: BoxFit.cover,
        width: 110,
        height: 110,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onSubtract: onSubtract,
      onAdd: onAdd,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        fit: BoxFit.cover,
        width: 110,
        height: 110,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onSubtract: onSubtract,
      onAdd: onAdd,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    // IntrinsicHeight: 자식 위젯의 높이를 최대 높이로 맞추는 위젯
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: image,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      detail,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: BODY_TEXT_COLOR,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '₩$price',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: PRIMARY_COLOR,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _Footer(
              total: (basket.firstWhere((e) => e.product.id == id).count *
                      basket
                          .firstWhere((e) => e.product.id == id)
                          .product
                          .price)
                  .toString(),
              count: basket.firstWhere((e) => e.product.id == id).count,
              onSubtract: onSubtract!,
              onAdd: onAdd!,
            ),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  const _Footer({
    required this.total,
    required this.count,
    required this.onSubtract,
    required this.onAdd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 ₩$total',
            style: const TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            renderButton(
              icon: Icons.remove,
              onTap: onSubtract,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              count.toString(),
              style: const TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            renderButton(
              icon: Icons.add,
              onTap: onAdd,
            ),
          ],
        ),
      ],
    );
  }

  Widget renderButton({
    required IconData icon,
    required Function() onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: PRIMARY_COLOR,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(icon, color: PRIMARY_COLOR),
      ),
    );
  }
}
