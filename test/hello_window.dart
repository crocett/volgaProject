import 'package:flutter/material.dart';

class HomeWindowScreen extends StatefulWidget {
  const HomeWindowScreen({super.key});

  @override
  State<HomeWindowScreen> createState() => _HomeWindowScreenState();
}

class _HomeWindowScreenState extends State<HomeWindowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Text('Сердце Поволжья', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
