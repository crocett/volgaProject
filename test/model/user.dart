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

  factory User.fromProfileData(Map<String, dynamic> data, User defaults) {
    return User(
      name: data['name'] as String? ?? defaults.name,
      imagePath: data['image'] as String? ?? defaults.imagePath,
      level: defaults.level,
      isDartMode: defaults.isDartMode,
    );
  }
}