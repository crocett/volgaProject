import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import 'questions_page.dart';

class ArticleDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;
  ArticleDetailPage({super.key, required this.article});

  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool get hasTest {
    return article['id_test'] != null && article['id_test'] > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(article['image'], fit: BoxFit.cover),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black26],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['name'],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    minChildSize: 0.3,
                    maxChildSize: 1,
                    snap: true,
                    snapSizes: [0.4, 0.7, 1],
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                            Expanded(
                              child: SingleChildScrollView(
                                controller: scrollController,
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    Text(
                                      article['articl'],
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: Colors.black,
                                      ),
                                    ),

                                    if (hasTest) ...[
                                      const SizedBox(height: 40),

                                      Container(
                                        height: 2,
                                        color: Colors.red[100],
                                      ),

                                      const SizedBox(height: 30),

                                      Center(
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Готов проверить свои знания?',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),

                                            const SizedBox(height: 20),

                                            // Кнопка "Пройти тест"
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuestionsPage(
                                                          testId:
                                                              article['id_test']
                                                                  as int,
                                                        ),
                                                  ),
                                                );
                                                // print('Нажат тест для статьи: ${article['name']}');
                                                // print('ID теста: ${article['id_test']}');

                                                // ScaffoldMessenger.of(context).showSnackBar(
                                                //   const SnackBar(
                                                //     content: Text('Страница теста в разработке'),
                                                //     duration: Duration(seconds: 2),
                                                //   ),
                                                // );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red[600],
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 15,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text(
                                                'Пройти тест',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 20),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
