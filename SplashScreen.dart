// ignore: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'app/url.dart';
import 'Animation/FadeAnimation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int login = 0;
  final int splashDuration = 3;
  getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    login = prefs.getInt('ID') ?? 0;
    return login;
  }

  void initState() {
    getID();
    countDownTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100.0,
        child: Image.asset('assets/logokpa.png'),
      ),
    );
    final text2 = Text(judulsingkat,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'Poppins'));

    final text1 = Text(judulpanjang,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white));
//
    final text3 = Text(namaPT,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Warna1,
                Warna2,
              ],
              begin: const FractionalOffset(0.5, 0.0),
              end: const FractionalOffset(0.0, 0.5),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                FadeAnimation(
                  2,
                  logo,
                ),
                const SizedBox(height: 10.0),
                FadeAnimation(
                  2.3,
                  text2,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                FadeAnimation(2.6, text1),
                const SizedBox(height: 10.0),
                FadeAnimation(
                  2.9,
                  text3,
                )
              ]),
        ),
      ),
    );
  }

  countDownTime() async {
    return Timer(Duration(seconds: splashDuration), () {
      if (login == 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginView(),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => home(),
        ));
      }
    });
  }
}
