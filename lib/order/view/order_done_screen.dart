import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDoneScreen extends StatelessWidget {
  const OrderDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.thumb_up_alt_outlined,
              size: 50,
              color: PRIMARY_COLOR,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              '결제가 완료되었습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('홈으로'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PRIMARY_COLOR,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
