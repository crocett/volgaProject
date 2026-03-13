import 'package:flutter/material.dart';
import '../constants.dart';
import '../database_helper.dart';
import '../widget/question_widget.dart';
import '../widget/next_button.dart';
import '../widget/option_card.dart';
import '../widget/result_box.dart';

class QuestionsPage extends StatefulWidget {
  final int testId;
  QuestionsPage({super.key, required this.testId});

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  State<QuestionsPage> createState() => QuestionsPageState();
}

class QuestionsPageState extends State<QuestionsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _questions = [];
  int index = 0;
  int score = 0;
  bool _isLoading = true;
  bool isPressed = false;
  bool isAlreadySelected = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    try {
      final db = await _dbHelper.database;
      final data = await db.query(
        'question',
        where: 'id_test = ?',
        whereArgs: [widget.testId],
        orderBy: 'id ASC',
      );

      final List<Map<String, dynamic>> questionVariant = [];
      for (var q in data) {
        final variants = await db.query(
          'variant',
          where: 'id_quest = ?',
          whereArgs: [q['id']],
          orderBy: 'id ASC',
        );

        questionVariant.add({...q, 'options': variants});
      }

      setState(() {
        _questions = questionVariant;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки вопросов: $e');
      setState(() => _isLoading = false);
    }
  }

  void nextQuestion() {
    if (index == _questions.length - 1) {
      //здесь наверное можно будет прописать что-то другое, так как он останавливает, когда мы доходим до последнего вопроса
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => ResultBox(
          result: score,
          questionLength: _questions.length,
          onPressed: startOver,
        ),
      );
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Пожалуйста выберите ответ'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color.fromARGB(255, 114, 199, 220),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          ),
        );
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = false;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: const Text('Вернуться назад'),
          backgroundColor: background,
          actions: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('Score: $score', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
        body: Center(child: Text('Вопросы не найдены')),
      );
    }
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Вернуться назад'),
        backgroundColor: background,
        actions: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Score: $score', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 20),
            QuestionWidget(
              question:
                  _questions[index]['descr']?.toString() ??
                  'Вопросы не найдены',
              indexAction: index,
              totalQuestions: _questions.length,
            ),
            Divider(color: neutral),
            SizedBox(height: 25),
            ...((_questions[index]['options'] as List?)?.map((variant) {
                  return GestureDetector(
                    onTap: () =>
                        checkAnswerAndUpdate(variant['is_correct'] == 1),
                    child: OptionCard(
                      option: (variant['descr']?.toString() ?? 'Вариант'),
                      color: isPressed
                          ? (variant['is_correct'] == 1)
                                ? correct
                                : incorrect
                          : neutral,
                    ),
                  );
                }).toList() ??
                []),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: NextButton(nextQuestion: nextQuestion),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
