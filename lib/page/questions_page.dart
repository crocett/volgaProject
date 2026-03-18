import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import '../constants.dart';
import '../database_helper.dart';
import '../widget/question_widget.dart';
import '../widget/next_button.dart';
import '../widget/option_card.dart';
import '../widget/result_box.dart';
import '../database_helper.dart';
import 'lk.dart';

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
  int? _selectedOptionId;
  String? _selectedAnswerDescr;
  bool _showAnswerDescr = false;

  @override
  void initState() {
    super.initState();
    DatabaseHelper().debugCheckTestResultTable();
    _initPage();
  }

  Future<void> _initPage() async {
    final existingRes = await _dbHelper.getLastTestResult(widget.testId);

    if (existingRes != null) {
      _showAlreadyPassedDialog(existingRes['t_result']);
      return;
    }
    await _loadQuestion();
  }

  //загрузка вопросов
  Future<void> _loadQuestion() async {
    try {
      final db = await _dbHelper.mainDb;
      final questions = await db.query(
        'question',
        where: 'id_test = ?',
        whereArgs: [widget.testId],
        orderBy: 'id ASC',
      );

      final List<Map<String, dynamic>> questionVariant = [];
      for (var q in questions) {
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
        score = 0;
        index = 0;
        _selectedOptionId = null;
      });
    } catch (e) {
      print('Ошибка загрузки вопросов: $e');
      setState(() => _isLoading = false);
    }
  }

  //если тест уже пройден
  void _showAlreadyPassedDialog(int previousResult) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Вы уже прошли данный тест', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundColor:
                  previousResult >=
                      (_questions.isEmpty ? 5 : _questions.length / 2)
                  ? correct
                  : incorrect,
              child: Text(
                '$previousResult/${_questions.isEmpty ? '1' : _questions.length}',
                style: TextStyle(fontSize: 30, color: background),
              ),
            ),
            SizedBox(height: 20),
            Text('Ваш предыдущий результат', style: TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Вернуться', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startTestRetake();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600]),
            child: Text('Пройти заново', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  //перепрохождение теста
  void _startTestRetake() async {
    setState(() {
      _isLoading = false;
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
      _selectedOptionId = null;
      _questions = [];
    });
    _loadQuestion();

    // if (mounted) {
    //   Navigator.pop(context);
    // }
    // await Future.delayed(Duration(microseconds: 300));
    // if (!mounted) {
    //   return;
    // }
    
    //_loadQuestion();
    // if (_questions.isEmpty) {
    //   _loadQuestion();
    // }
  }

  //следующий вопрос/завершение
  void nextQuestion() async {
    if (index == _questions.length - 1) {
      print('Тест завершён!');
      print('testId: ${widget.testId}, score: $score');
      
      try {
        await _dbHelper.saveOrUpdateTestResult(widget.testId, score);
        print('Результат сохранен: $score');

        final persAccount = PersonalAccount.of(context);
        if (persAccount != null) {
          persAccount.refreshTests();
          print('Личный кабинет обновлен');
        } else {
          print('PersonalAccount не найден в контексте');
        }
        
        final check = await _dbHelper.profileDb.then((db) => db.query(
          'test_result',
          where: 'id_test = ?',
          whereArgs: [widget.testId]
        ));
        print('Проверка, найдено записей = ${check.length}');
        if (check.isEmpty) {
          print('Данные: ${check.first}');
        }
      } catch (e) {
        print('Ошибка сохранения результата: $e');
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ResultBox(
          result: score,
          questionLength: _questions.length,

          onPressed: () {
            Navigator.pop(context);
          },
          onReturnToTests: () {
            Navigator.pop(context);
            Navigator.pop(context, score);
          },
        ),
      );
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
          _showAnswerDescr = false;
        _selectedAnswerDescr = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Пожалуйста выберите ответ'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color.fromARGB(255, 94, 94, 94),
            //margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          ),
        );
      }
    }
  }

  //проверка
  void checkAnswerAndUpdate(bool value, int optionId) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      final questionData = _questions[index];
      final descr = questionData['answ_descr']?.toString();
        print('🔍 [DEBUG] после toString(): "$descr"');
  print('🔍 [DEBUG] isEmpty: ${descr?.isEmpty}');
  print('🔍 [DEBUG] _showAnswerDescr будет: ${descr != null && descr.trim().isNotEmpty}');
        
      setState(() {
        _selectedOptionId = optionId;
        isPressed = true;
        isAlreadySelected = true;
        _selectedAnswerDescr = descr;
        _showAnswerDescr = descr != null && descr.isNotEmpty;
      });
    }
  }

  //перезапуск
  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        //backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Вернуться назад', style: TextStyle()),
          backgroundColor: Colors.transparent,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_questions.length, (i){
                bool isCurrent = i == index;
                bool isPassed = i < index;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent
                    ? Colors.red
                    :isPassed
                    ? const Color.fromARGB(255, 199, 191, 191)
                    :neutral,
                  ),
                );
              }),
            ),

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
                    onTap: () => checkAnswerAndUpdate(
                      variant['is_correct'] == 1,
                      variant['id'],
                    ),
                    child: OptionCard(
                      option: (variant['descr']?.toString() ?? 'Вариант'),
                      color: isPressed
                          ? (variant['id'] == _selectedOptionId)
                                ? (variant['is_correct'] == 1)
                                      ? correct
                                      : incorrect
                                : neutral
                          : neutral,
                      isSelected:
                          isPressed && (variant['id'] == _selectedOptionId),
                    ),
                  );
                }).toList() ??
                []),
                SizedBox(height: 10),

                if(_showAnswerDescr && _selectedAnswerDescr != null)
                AnimatedContainer(duration: Duration(milliseconds: 300),
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(16),
                width: double.infinity,
                 decoration: BoxDecoration(
      color: const Color.fromARGB(255, 242, 234, 234),
      borderRadius: BorderRadius.circular(12),
    ),
                   child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8,),
                    Text(
                      _selectedAnswerDescr?? 'Пусто',
                      style: TextStyle( fontSize: 16, height: 1.4),
                    ),
                  ],
                )
                ),
             
            SizedBox(height: 30),
            NextButton(nextQuestion: nextQuestion),
          ],
        ),
      ),
    );
  }
}
