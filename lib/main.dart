import 'package:actual/common/provider/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
    observers: [
      // Logger(),
    ],
    child: _App(),
  ));
}

class _App extends ConsumerWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'notoSansKr',
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
