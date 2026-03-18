import 'package:flutter/material.dart';
import '../constants.dart';
import '../page/all_questions_page.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
    super.key,
    required this.result,
    required this.questionLength,
    required this.onPressed,
    required this.onReturnToTests,
  });
  final int result;
  final int questionLength;
  final VoidCallback onPressed;
  final VoidCallback onReturnToTests;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 215, 215, 215),
      content: Padding(
        padding: EdgeInsets.all(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Результат',
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundColor: result == questionLength / 2
                  ? const Color.fromARGB(255, 184, 178, 129)
                  : result < questionLength / 2
                  ? incorrect
                  : correct,
              child: Text(
                '$result/$questionLength',
                style: TextStyle(fontSize: 30, color: background),
              ),
            ),
            SizedBox(height: 20),
            Text(
              result == questionLength / 2
                  ? 'Еще бы чуть-чуть'
                  : result < questionLength / 2
                  ? 'Попробуй еще раз'
                  : 'Молодец!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 45),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[500],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Начать сначала?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: onReturnToTests,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[500],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Вернуться к тестам',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
