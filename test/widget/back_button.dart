import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key, required this.backQuestion});
  final VoidCallback backQuestion;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: backQuestion,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text('К предыдущему', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
      ),
    );
  }
}