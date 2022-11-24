// ignore: file_names, import_of_legacy_library_into_null_safe
import 'package:get/get.dart';
import 'package:monitoring_kebersihan/login.dart';
import 'package:monitoring_kebersihan/home.dart';
import 'package:monitoring_kebersihan/SplashScreen.dart';
import 'package:monitoring_kebersihan/tescheckbox.dart';
import 'package:monitoring_kebersihan/user.dart';
import 'package:monitoring_kebersihan/inspeksi.dart';

class Ruter {
  static final route = [
    GetPage(
      name: '/splash',
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: '/loginview',
      page: () => LoginView(),
    ),
    GetPage(name: '/homeview', page: () => home()),
    GetPage(name: '/user', page: () => const User()),
    GetPage(name: '/kategori', page: () => const Inspeksi())
  ];
}
