import 'package:auto_route/auto_route.dart';
import 'package:template_app/core/router/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MainRoute.page, initial: true),
    AutoRoute(page: EpisodeDetailRoute.page),
  ];
}
