class User {
  final String imagePath;
  final String name;
  final String level;
  final bool isDartMode;

  const User({
    required this.imagePath,
    required this.name,
    required this.level,
    required this.isDartMode,
  });

  User copyWith({String? name, String? imagePath}) {
    return User(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      level: level ?? this.level,
      isDartMode: isDartMode ?? this.isDartMode
    );
  }
}