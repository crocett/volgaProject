import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class ArticleDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;
  ArticleDetailPage({super.key, required this.article});

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.fromLTRB(24, 24, 24, 24), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article['name'], 
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
            ),
          ),
          Expanded(child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['articl'],
                    style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black),
                  ),
                ],
              ),
            ),
          ))
        ],
      )),
    );
  }
}
