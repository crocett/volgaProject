import 'package:flutter/material.dart';
import '../constants.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
    super.key,
    required this.result,
    required this.questionLength,
    required this.onPressed,
  });
  final int result;
  final int questionLength;
  final VoidCallback onPressed;

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
                  ? Colors.yellow[100]
                  : result < questionLength / 2
                  ? incorrect
                  : correct,
              child: Text(
                '$result/$questionLength',
                style: TextStyle(fontSize: 30, color: background),
              ),
            ),
            SizedBox(height: 20),
            Text(result == questionLength / 2
                  ? 'Almost There'
                  : result < questionLength / 2
                  ? 'Попробуй еще раз'
                  : 'Молодец!',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: onPressed,
              child: Text('Начать сначала', style: TextStyle(fontSize: 20, letterSpacing: 1.0, color: Colors.blue[900]),),
            )
          ],
        ),
      ),
    );
  }
}
