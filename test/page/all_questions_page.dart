import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../widget/question_widget.dart';
import '../constants.dart';
import 'package:sqflite/sqflite.dart';
import 'questions_page.dart';
import 'package:flutter/services.dart';

class AllQuestionsPage extends StatefulWidget {
  const AllQuestionsPage({super.key});

  @override
  State<AllQuestionsPage> createState() => _AllQuestionsPageState();
}

class _AllQuestionsPageState extends State<AllQuestionsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _test = [];

  int index = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  //загрузка тестов из maininfo.db
  Future<void> _loadTests() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final Database db = await _dbHelper.mainDb;
      final tables = await db.query(
        'sqlite_master',
        where: 'type = ? AND name = ?',
        whereArgs: ['table', 'test'],
      );

      if (tables.isEmpty) {
        setState(() {
          _errorMessage = 'Таблица test не найдена в БД';
          _isLoading = false;
        });
        return;
      }

      //загружаем все тесты
      final List<Map<String, dynamic>> tests = await db.query('test');
      print('Загружено тестов: ${tests.length}');
      if (tests.isNotEmpty) {
        print('Первый вопрос: ${tests.first}');
      }

      setState(() {
        _test = tests;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки тестов: $e');
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
      backgroundColor: background,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Тесты'),
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
          //контент
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _test.isEmpty
              ? const Center(child: Text('Тесты не найдены'))
              : GridView.builder(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + kToolbarHeight + 20,
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
                  itemCount: _test.length,
                  itemBuilder: (context, index) {
                    final question = _test[index];
                    return GestureDetector(
                      onTap: () async {
                        final testId = question['id'];
                        print('Переходим к тесту id=$testId');

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QuestionsPage(testId: testId),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 247, 248),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(3, 4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question['title'] ?? 'Тест не указан',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(
                              question['descr'] ?? 'Краткого описания нет',
                              style: TextStyle(fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            //Spacer(),
                            //Text(_formatDateTime(article['date']), style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
