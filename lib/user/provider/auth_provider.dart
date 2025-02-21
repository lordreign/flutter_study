import 'package:actual/common/view/root_tab.dart';
import 'package:actual/common/view/splash_screen.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:actual/user/provider/user_me_provider.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref: ref));

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, current) {
      if (previous != current) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            name: 'rootTab',
            builder: (_, __) => RootTab(),
            routes: [
              GoRoute(
                path: 'restaurant/:id',
                name: 'restaurantDetail',
                builder: (_, state) =>
                    RestaurantDetailScreen(id: state.pathParameters['id']!),
              ),
            ]),
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (_, __) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (_, __) => LoginScreen(),
        ),
      ];

  Future<String?> redirectLogin(context, GoRouterState state) async {
    final user = ref.read(userMeProvider);
    final login = state.uri.toString() == '/login';

    if (user == null) {
      return login ? null : '/login';
    }

    if (user is UserModel) {
      return login || state.uri.toString() == '/splash' ? '/' : null;
    }

    if (user is UserModelError) {
      return !login ? '/login' : null;
    }

    return null;
  }
}
