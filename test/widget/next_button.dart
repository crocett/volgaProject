import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.nextQuestion});
  final VoidCallback nextQuestion;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: nextQuestion,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text('Следующий вопрос', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
      ),
    );
  }
}