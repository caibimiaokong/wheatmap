import 'package:go_router/go_router.dart';

//local import
import 'package:wheatmap/feature/map_feature/views/map_ui.dart';
import 'package:wheatmap/feature/homescreen.dart';
import 'package:wheatmap/feature/article_feature/view/newswebview.dart';
import 'package:wheatmap/feature/login_feature/view/export.dart';

import 'package:shared_preferences/shared_preferences.dart';

//创建一个路由
final GoRouter router = GoRouter(
    // redirect: (context, state) async {
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   final bool? isSignIn = prefs.getBool('signed_in');
    //   if (isSignIn == true) {
    //     return '/home';
    //   }
    //   return '/';
    // },
    routes: [
      GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, state) => const SplashScreen()),
      GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/phone',
          name: 'phone',
          builder: (context, state) => const PhoneAuthScreen()),
      GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeNavigator()),
      GoRoute(
          path: '/map',
          name: 'map',
          builder: (context, state) => const MapScreen()),
      GoRoute(
          path: '/webview/:url',
          name: 'webview',
          builder: (context, state) =>
              WebViewScreen(url: state.pathParameters['url']!)),
    ]);
