import 'package:flutter/material.dart';
import '../constants.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.option,
    required this.color,
    this.isSelected = false,
  });
  final String option;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: color,
        borderRadius: BorderRadius.circular(15),
        border: isSelected
            ? Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 2)
            : null,
      ),
      child: Card(
        color: color,
        child: ListTile(
          title: Text(
            option,
            style: TextStyle(
              fontSize: 20,
              color: color.red != color.green ? Colors.black : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
