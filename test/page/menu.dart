import 'package:flutter/material.dart';

import 'search.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/fon_backg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                    //child: Text('Поиск', style: TextStyle(fontSize: 25)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 60),
                      shadowColor: Colors.black.withOpacity(0.2),
                      elevation: 10,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Icon(Icons.search, size: 25),
                        SizedBox(width: 15),
                        Text('Поиск', style: TextStyle(fontSize: 25)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: TextButton(
                    onPressed: () {},
                    //child: Text('Тесты', style: TextStyle(fontSize: 25)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 60),
                      shadowColor: Colors.black.withOpacity(0.2),
                      elevation: 10,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Icon(Icons.text_snippet_sharp, size: 25),
                        SizedBox(width: 15),
                        Text('Тесты', style: TextStyle(fontSize: 25)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: TextButton(
                    onPressed: () {},
                    //child: Text('Статьи', style: TextStyle(fontSize: 25)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 60),
                      shadowColor: Colors.black.withOpacity(0.2),
                      elevation: 10,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Icon(Icons.article_outlined, size: 25),
                        SizedBox(width: 15),
                        Text('Статьи', style: TextStyle(fontSize: 25)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: TextButton(
                    onPressed: () {},
                    //child: Text('Настройки', style: TextStyle(fontSize: 25)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 60),
                      shadowColor: Colors.black.withOpacity(0.2),
                      elevation: 10,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Icon(Icons.settings, size: 25),
                        SizedBox(width: 15),
                        Text('Настройки', style: TextStyle(fontSize: 25)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 60),
                      shadowColor: Colors.black.withOpacity(0.2),
                      elevation: 10,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Icon(Icons.contact_phone_rounded, size: 25),
                        SizedBox(width: 15),
                        Text('Контакты', style: TextStyle(fontSize: 25)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
