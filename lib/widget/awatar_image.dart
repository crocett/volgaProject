import 'dart:io';

import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final String imagePath;
  final double size;
  final BoxFit fit;

  const AvatarImage({
    super.key,
    required this.imagePath,
    required this.size,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('/')) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (context, error, StackTrace) {
            return _buildPlaceholder();
          },
        );
      } else {
        print('Файл не найден: $imagePath');
        return _buildPlaceholder();
      }
    } else {
      return Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(size/2), 
      ),
      child: Icon(
        Icons.person,
        size: size*0.5,
        color: Colors.grey[600],
      ),
    );
  }
}
