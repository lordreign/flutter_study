import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data.length == 0) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.separated(
              itemCount: data.length,
              itemBuilder: (_, index) {
                final parsedItem = data[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(
                          id: parsedItem.id,
                        ),
                      ),
                    );
                  },
                  child: RestaurantCard.fromModel(model: parsedItem),
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(height: 16);
              },
            )),
      ),
    );
  }
}
