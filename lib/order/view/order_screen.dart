import 'package:actual/common/common/pagination_list_view.dart';
import 'package:actual/order/component/order_card.dart';
import 'package:actual/order/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_, index, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
