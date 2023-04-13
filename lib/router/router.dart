import 'package:auto_route/auto_route.dart';

import '../main.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: MyApp, initial: true),

  ],
)
class $Routera {}
