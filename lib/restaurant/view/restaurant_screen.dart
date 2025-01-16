import 'package:actual/common/const/data.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://$ip',
      ),
    );

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final resp = await dio.get(
      '/restaurant',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, snapshot) {
              if (!snapshot.hasData &&
                  snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text('에러가 발생했습니다.');
              }

              print(snapshot.error);
              print(snapshot.data);

              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final parsedItem =
                      RestaurantModel.fromJson(snapshot.data![index]);

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
              );
            },
          ),
        ),
      ),
    );
  }
}
