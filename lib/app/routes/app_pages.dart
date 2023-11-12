import 'package:get/get.dart';

import '../../utils/loading_animation.dart';
import '../modules/googlesignin.dart/views/splash.dart';
import '../modules/homepage.dart/bindings/homepage_dart_binding.dart';
import '../modules/homepage.dart/views/home.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () =>  Home(),
      binding: HomepageDartBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () =>  Splash(),
    ),
    GetPage(
      name: _Paths.LOADINGANIMATION,
      page: () =>  LoadingAnimation(),
    ),

  ];
}
