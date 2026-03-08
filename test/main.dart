import 'package:flutter/material.dart';
//import 'hello_window.dart';
import 'home_page.dart';
import 'package:splashscreen/splashscreen.dart';
//import 'package:volga/main.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen.timer(
      seconds: 4,
      navigateAfterSeconds: HomePage(),
      title: Text(
        'Сердце Поволжья',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: const Color.fromARGB(255, 221, 27, 27)),
      ),
      image: Image.asset(
        'assets/images/heart.png',
        width: 600,
        height: 600,
        fit: BoxFit.contain,
      ),
      //backgroundColor: Colors.white,
      loaderColor: const Color.fromARGB(255, 221, 27, 27),
    );
  }
}