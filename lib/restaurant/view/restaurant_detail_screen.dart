import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    final state = ref.watch(restaurantDetailProvider(widget.id));

    if (state == null) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      automaticallyImplyLeading: true,
      title: '불타는 떡볶이',
      child: CustomScrollView(
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel) renderProducts(state.products),
        ],
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            1,
            (index) => SizedBox(
              height: MediaQuery.of(context).size.height / 2,

              /// 나중에 바꿔보기
              child: Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Bone.circle(size: 48),
                        title: Bone.text(words: 2),
                        subtitle: Bone.text(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
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
