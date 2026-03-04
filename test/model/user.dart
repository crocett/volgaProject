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

  User copy({
    String? imagePath,
    String? name,
    String? level,
    bool? isDartMode,
  }) =>
      User(
        imagePath: imagePath ?? this.imagePath,
        name: name ?? this.name,
        level: level ?? this.level,
        isDartMode: isDartMode ?? this.isDartMode,
      );
  
  static User fromJson(Map<String, dynamic> json) => User(
    imagePath: json['imagePath'],
    name: json['name'],
    level: json['level'],
    isDartMode: json['isDartMode'],
  );

  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'name': name,
    'level': level,
    'isDartMode': isDartMode,
  };
}