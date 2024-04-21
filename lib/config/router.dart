import 'package:go_router/go_router.dart';

//local import
import 'package:wheatmap/feature/map_feature/views/map_ui.dart';

//创建一个路由
final GoRouter router = GoRouter(routes: [
  GoRoute(
      path: '/', name: 'map', builder: (context, state) => const MapScreen()),
]);
