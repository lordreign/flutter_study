import 'package:actual/common/common/pagination_list_view.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            context.go('/restaurant/${model.id}');
            // context.goNamed('라우트명', params: {id: model.id});
          },
          child: RestaurantCard.fromModel(model: model),
        );
      },
    );
  }
}
