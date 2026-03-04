import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: BackButton(),
    elevation: 0,
    backgroundColor: const Color.fromARGB(7, 255, 255, 255),
    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.nightlight_outlined, color: Colors.black),
      ),
    ],
  );
}
