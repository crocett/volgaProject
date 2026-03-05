import 'dart:convert';
import 'package:flutter/material.dart';
import 'page/lk.dart';
import 'page/edit_profile.dart';
import 'page/search.dart';
import 'page/menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  final List<Widget> pages = [
    const Page1(),
    const SearchPage(),
    const PersonalAccount(),
    const MenuPage(),
  ];

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

          IndexedStack(index: pageIndex, children: pages),
        ],
      ),

      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.only(
            // topLeft: Radius.circular(20),
            // bottomLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home_outlined,
                      color: Color.fromARGB(204, 255, 158, 158),
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.red,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.search_outlined,
                      color: Color.fromARGB(204, 255, 158, 158),
                      size: 35,
                    )
                  : const Icon(
                      Icons.search_outlined,
                      color: Colors.red,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.person_outline_outlined,
                      color: Color.fromARGB(204, 255, 158, 158),
                      size: 35,
                    )
                  : const Icon(
                      Icons.person_outline_outlined,
                      color: Colors.red,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? Tab(icon: Image.asset("assets/images/menu.png"))
                  : Tab(icon: Image.asset("assets/images/menu.png")),
            ),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Приветственная страница", style: TextStyle(fontSize: 20)),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Страница поиска", style: TextStyle(fontSize: 20)),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Страница чего-то там", style: TextStyle(fontSize: 20)),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Страница чего-то там", style: TextStyle(fontSize: 20)),
    );
  }
}
