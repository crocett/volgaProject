import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'article_page.dart';
import '../database_helper.dart';

class ArctirclePage extends StatefulWidget {
  const ArctirclePage({super.key});

  @override
  State<ArctirclePage> createState() => _ArctirclePageState();
}

class _ArctirclePageState extends State<ArctirclePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _articles = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final Database db = await _dbHelper.mainDb;
      final tables = await db.query(
        'sqlite_master',
        where: 'type = ? AND name = ?',
        whereArgs: ['table', 'article'],
      );

      if (tables.isEmpty) {
        setState(() {
          _errorMessage = 'Таблица article не найдена в БД';
          _isLoading = false;
        });
        return;
      }
      
      //загружаем все статьи
      final List<Map<String, dynamic>> articles = await db.query('article');
      print('Загружено статей: ${articles.length}');
      if (articles.isNotEmpty) {
        print('Первая статья: ${articles.first}');
      }

      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузка статей: $e');
      setState(() {
        _errorMessage = 'Ошибка: $e';
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Статьи',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
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
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 60),
                      SizedBox(height: 20),
                      Text(_errorMessage!, textAlign: TextAlign.center),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _loadArticles,
                        child: Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : _articles.isEmpty
              ? Center(child: Text('Статьи не найдены'))
              : GridView.builder(
                  padding: EdgeInsets.only(
                    top:
                        MediaQuery.of(context).padding.top +
                        kToolbarHeight +
                        20,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 3,
                  ),
                  itemCount: _articles.length,
                  itemBuilder: (context, index) {
                    final article = _articles[index];
                    return GestureDetector(
                      onTap: () async {
                        _loadArticles();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ArticleDetailPage(article: article),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.35),
                              offset: Offset(2, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: 90,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: article['icon_image'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        article['icon_image'],
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(Icons.image, color: Colors.white),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    article['articl'],
                                    style: TextStyle(fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  //Spacer(),
                                  //Text(_formatDateTime(article['date']), style: TextStyle(fontSize: 10, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await Navigator.push(context, MaterialPageRoute(builder: (context) => ArctirclePage()));
      //     _loadArticles();
      //   },
      //   child: Icon(Icons.refresh, color: Colors.white),
      // )
    );
  }
}
