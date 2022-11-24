// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:monitoring_kebersihan/app/url.dart';
import 'Animation/FadeAnimation.dart';
import 'app/login_controller.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _loginController = Get.put(LoginController());

  final _formKey = GlobalKey<FormState>();

  bool _isObsecure = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWill,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 300,
                child: Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: OvalBottomBorderClipper(),
                      child: Container(
                        height: 400,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blue, Colors.blueAccent],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      width: MediaQuery.of(context).size.width * 1,
                      height: 250,
                      child: Center(
                        child: FadeAnimation(
                            1.3,
                            Image.asset(
                              'assets/logokpa.png',
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.3,
                            )),
                      ),
                    ),
                    Positioned(
                      child: FadeAnimation(
                          1.6,
                          Container(
                            margin: const EdgeInsets.only(top: 110),
                            child: const Center(
                              child: Text(
                                "Daily Inspection\n         QHSE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                // ignore: prefer_const_literals_to_create_immutables
                                boxShadow: [
                                  const BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]!))),
                                  child: TextField(
                                    controller: _loginController.username,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Masukan Username",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _loginController.password,
                                    obscureText: _isObsecure,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        suffixIcon: IconButton(
                                          icon: Icon(_isObsecure
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              _isObsecure = !_isObsecure;
                                            });
                                          },
                                        ),
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                )
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _loginController.apiLogin();
                          }
                        },
                        child: FadeAnimation(
                          2,
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // ignore: prefer_const_literals_to_create_immutables
                                gradient: const LinearGradient(
                                    colors: [Colors.blue, Colors.blueAccent])),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      FadeAnimation(
                          1.5,
                          Text(
                            namaPT,
                            style: TextStyle(color: Colors.grey[500]),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWill() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Keluar?',
            style: TextStyle(color: Colors.black, fontSize: 20.0)),
        content: const Text('Apakah anda yakin akan keluar?'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              // this line exits the app.
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: const Text('Ya', style: TextStyle(fontSize: 18.0)),
          ),
          ElevatedButton(
            onPressed: () =>
                Get.offNamed('/loginview'), // this line dismisses the dialog
            child: const Text('Tidak', style: TextStyle(fontSize: 18.0)),
          )
        ],
      ),
    );
    return true;
  }
}
