import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final bool automaticallyImplyLeading;

  const DefaultLayout({
    super.key,
    required this.child,
    this.title,
    this.bottomNavigationBar,
    this.backgroundColor = Colors.white,
    this.automaticallyImplyLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    }
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Text(
        title!,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevation: 0,
      centerTitle: true,
    );
  }
}
