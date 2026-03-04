import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
     
    child: Text(text, style: TextStyle(color: Colors.white, fontSize: 17)),
    onPressed: onClicked,
  );
  } 
}