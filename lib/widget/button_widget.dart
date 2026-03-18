import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({super.key, required this.text, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          //color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            decoration: TextDecoration.underline,
            decorationColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
