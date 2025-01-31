import 'package:actual/common/view/splash_screen.dart';
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

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'notoSansKr',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
