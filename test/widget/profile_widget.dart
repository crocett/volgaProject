import 'package:flutter/material.dart';
import 'awatar_image.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    super.key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(bottom: 0, right: 4, child: buildEditIcon(color)),
        ],
      ),
    );
  }

  Widget buildImage() {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClicked,
          child: AvatarImage(
            imagePath: imagePath,
            size: 128,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      child: Icon(
        isEdit ? Icons.add_a_photo_outlined : Icons.edit,
        color: Colors.white, size: 20),
      color: color,
      all: 8,
    ),
  );

  Widget buildCircle({
    required Widget child,
    required Color color,
    required double all,
  }) => ClipOval(
    child: Container(padding: EdgeInsets.all(all), color: color, child: child),
  );
}
