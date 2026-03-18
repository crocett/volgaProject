import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'all_arctircle_page.dart';
import 'questions_page.dart';
import 'search.dart';
import 'all_questions_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Widget? _currentContent;
  String _buttonClose = "Вернуться в меню";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.red,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 10,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
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
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentContent != null) ...[
                      Expanded(child: _currentContent!),
                    ] else ...[
                      ..._menuButton,
                    ],
                  ],
                ),

                if (_currentContent != null)
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            offset: Offset(2, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () => setState(() {
                          _currentContent = null;
                        }),
                        child: Text(
                          _buttonClose,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => SearchPage()),
                //       );
                //     },
                //     //child: Text('Поиск', style: TextStyle(fontSize: 25)),
                //     style: TextButton.styleFrom(
                //       foregroundColor: Colors.white,
                //       backgroundColor: Colors.red,
                //       minimumSize: Size(double.infinity, 60),
                //       shadowColor: Colors.black.withOpacity(0.2),
                //       elevation: 10,
                //     ),
                //     child: Row(
                //       children: [
                //         SizedBox(width: 15),
                //         Icon(Icons.search, size: 25),
                //         SizedBox(width: 15),
                //         Text('Поиск', style: TextStyle(fontSize: 25)),
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                //   child: TextButton(
                //     onPressed: () {},
                //     //child: Text('Тесты', style: TextStyle(fontSize: 25)),
                //     style: TextButton.styleFrom(
                //       foregroundColor: Colors.white,
                //       backgroundColor: Colors.red,
                //       minimumSize: Size(double.infinity, 60),
                //       shadowColor: Colors.black.withOpacity(0.2),
                //       elevation: 10,
                //     ),
                //     child: Row(
                //       children: [
                //         SizedBox(width: 15),
                //         Icon(Icons.text_snippet_sharp, size: 25),
                //         SizedBox(width: 15),
                //         Text('Тесты', style: TextStyle(fontSize: 25)),
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (context) => ArctirclePage(),
                //         ),
                //       );
                //     },
                //     //child: Text('Статьи', style: TextStyle(fontSize: 25)),
                //     style: TextButton.styleFrom(
                //       foregroundColor: Colors.white,
                //       backgroundColor: Colors.red,
                //       minimumSize: Size(double.infinity, 60),
                //       shadowColor: Colors.black.withOpacity(0.2),
                //       elevation: 10,
                //     ),
                //     child: Row(
                //       children: [
                //         SizedBox(width: 15),
                //         Icon(Icons.article_outlined, size: 25),
                //         SizedBox(width: 15),
                //         Text('Статьи', style: TextStyle(fontSize: 25)),
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                //   child: TextButton(
                //     onPressed: () {},
                //     //child: Text('Настройки', style: TextStyle(fontSize: 25)),
                //     style: TextButton.styleFrom(
                //       foregroundColor: Colors.white,
                //       backgroundColor: Colors.red,
                //       minimumSize: Size(double.infinity, 60),
                //       shadowColor: Colors.black.withOpacity(0.2),
                //       elevation: 10,
                //     ),
                //     child: Row(
                //       children: [
                //         SizedBox(width: 15),
                //         Icon(Icons.settings, size: 25),
                //         SizedBox(width: 15),
                //         Text('Настройки', style: TextStyle(fontSize: 25)),
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                //   child: TextButton(
                //     onPressed: () {},
                //     style: TextButton.styleFrom(
                //       foregroundColor: Colors.white,
                //       backgroundColor: Colors.red,
                //       minimumSize: Size(double.infinity, 60),
                //       shadowColor: Colors.black.withOpacity(0.2),
                //       elevation: 10,
                //     ),
                //     child: Row(
                //       children: [
                //         SizedBox(width: 15),
                //         Icon(Icons.contact_phone_rounded, size: 25),
                //         SizedBox(width: 15),
                //         Text('Контакты', style: TextStyle(fontSize: 25)),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get _menuButton => [
    _buildMenuButton("Поиск", Icons.search, () {
      setState(() {
        //_currentContent = SearchPage();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
      });
    }),
    _buildMenuButton('Тесты', Icons.text_snippet_sharp, () {
      setState(() {
        //_currentContent = QuestionsPage();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllQuestionsPage()));
      });
    }),
    _buildMenuButton('Статьи', Icons.article_outlined, () {
      setState(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArctirclePage()));
        //_currentContent = ArctirclePage();
      });
    }),
    _buildMenuButton('Настройки', Icons.settings, () {
      setState(() {
        _currentContent = Center(child: Text('Страница настройки'));
      });
    }),
    _buildMenuButton('Контакты', Icons.contact_phone_rounded, () {
      setState(() {
        _currentContent = Center(child: Text('Страница контакты'));
      });
    }),
  ];

  Widget _buildMenuButton(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
      child: TextButton(
        onPressed: onTap,
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
            Icon(icon, size: 25),
            SizedBox(width: 15),
            Text(title, style: TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}
