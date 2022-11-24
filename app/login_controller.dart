// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'request.dart';
import 'url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  late TextEditingController username;
  late TextEditingController password;
  bool showHide = true;
  bool _isObsecure = true;
  @override
  void onInit() {
    username = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  void apiLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Request request = Request(url: phplogin, body: {
      'access': 'apickb',
      'user': username.text,
      'pass': password.text
    });

    request.post().then((value) {
      var a = jsonDecode(value.body);
      if (a['message'] == 200) {
        pref.setString("id_user", a['id_user']);
        pref.setString("nama_user", a['nama_user']);
        pref.setString("nama_kantor", a['nama_kantor']);
        pref.setString("nama_jabatan", a['nama_jabatan']);
        pref.setString("foto", a['foto']);
        pref.setString("id_kantor", a['id_kantor']);
        pref.setString("id_jabatan", a['id_jabatan']);
        pref.setInt("ID", 1);
        Get.offNamed('/homeview');
      } else {
        Get.dialog(AlertDialog(
          title: const Text("Informasi"),
          content: const Text("User atau Password tidak ditemukan."),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () => Get.back(),
            ),
          ],
        ));
      }
    }).catchError((onError) {
      Get.dialog(AlertDialog(
        title: const Text("Informasi"),
        content: const Text("Tidak terhubung, periksa kembali jaringan anda."),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("OK"),
            onPressed: () => Get.back(),
          ),
        ],
      ));
    });
  }

  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }
}
