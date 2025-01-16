import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://$ip',
      ),
    );

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final resp = await dio.get(
      '/restaurant/$id',
      options: Options(
        headers: {
          'Content-Type': 'application',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      automaticallyImplyLeading: true,
      title: '불타는 떡볶이',
      child: FutureBuilder(
          future: getRestaurantDetail(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('에러가 발생했습니다.'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('데이터가 없습니다.'));
            }

            final item = RestaurantDetailModel.fromJson(snapshot.data!);
            return CustomScrollView(
              slivers: [
                renderTop(model: item),
                renderLabel(),
                renderProducts(item.products),
              ],
            );
          }),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProducts(List<RestaurantProductModel> products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ProductCard.fromModel(model: product),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
