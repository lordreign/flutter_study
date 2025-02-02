import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationListView extends ConsumerStatefulWidget {
  const PaginationListView({super.key});

  @override
  ConsumerState<PaginationListView> createState() => _PaginationListViewState();
}

class _PaginationListViewState extends ConsumerState<PaginationListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(listener);
  }

  void listener() {
    // PaginationUtils.paginate(
    //   scrollController: _scrollController,
    //   provider: ref.read(restaurantProvider.notifier),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
