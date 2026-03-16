import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'model/user.dart';
import 'user_pref.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _mainDatabase;
  static Database? _profileDatabase;

  Future<Database> get mainDb async {
    if (_mainDatabase != null) return _mainDatabase!;
    _mainDatabase = await _initMainDatabase();
    return _mainDatabase!;
  }

  Future<Database> get profileDb async {
    if (_profileDatabase != null) return _profileDatabase!;
    _profileDatabase = await _initProfileDatabase();
    return _profileDatabase!;
  }

  //maininfo.db
  Future<Database> _initMainDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'maininfo.db');

      bool shouldCopy = false;

      if (await databaseExists(path)) {
        final tempDb = await openDatabase(path, readOnly: true);
        final tables = await tempDb.query(
          'sqlite_master',
          where: 'type = ? AND name = ?',
          whereArgs: ['table', 'question'],
        );
        await tempDb.close();
        if (tables.isEmpty) shouldCopy = true;
      } else {
        shouldCopy = true;
      }

      if (shouldCopy) {
        await Directory(dbPath).create(recursive: true);
        final assetData = await rootBundle.load('assets/data/maininfo.db');
        List<int> bytes = assetData.buffer.asUint8List(
          assetData.offsetInBytes,
          assetData.lengthInBytes,
        );
        await File(path).writeAsBytes(bytes, flush: true);
        print('maininfo.db скопирована из assets');
      }

      return await openDatabase(path, readOnly: true);
    } catch (e) {
      print('Ошибка maininfo.db: $e');
      rethrow;
    }
  }

  //profileinfo.db
  Future<Database> _initProfileDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'profileinfo.db');

      if (!await databaseExists(path)) {
        await Directory(dbPath).create(recursive: true);

        final db = await openDatabase(
          path,
          version: 1,
          onCreate: _createProfileTables,
        );
        print('profileinfo.db создана');
        return db;
      }

      return await openDatabase(path);
    } catch (e) {
      print('Ошибка profileinfo.db: $e');
      rethrow;
    }
  }

  Future<void> _createProfileTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE test_result (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_test INTEGER NOT NULL,
        t_result INTEGER NOT NULL,
        UNIQUE(id_test)
      )
    ''');
    print('Таблица test_result создана');

    // Таблица профиля пользователя
    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        name TEXT DEFAULT 'Пользователь',
        photo_path TEXT,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    print('Таблица user_profile создана');

    // Создаём запись профиля по умолчанию
    await db.insert('user_profile', {'id': 1});
    print('Запись профиля по умолчанию создана');
  }

  // Запасной вариант: объединение данных в памяти (если ATTACH не работает)
  Future<List<Map<String, dynamic>>> _getAllResultsInMemory() async {
    final mainDb = await this.mainDb;
    final profileDb = await this.profileDb;

    final results = await profileDb.query(
      'test_result',
      orderBy: 'completed_at DESC',
    );
    final combined = <Map<String, dynamic>>[];

    for (var res in results) {
      final test = await mainDb.query(
        'test',
        where: 'id = ?',
        whereArgs: [res['id_test']],
      );
      if (test.isNotEmpty) {
        final totalQ = await mainDb.rawQuery(
          'SELECT COUNT(*) as cnt FROM question WHERE id_test = ?',
          [res['id_test']],
        );
        combined.add({
          ...res,
          'test_title': test.first['title'],
          'test_description': test.first['descr'],
          'total_questions': totalQ.first['cnt'],
        });
      }
    }
    return combined;
  }

  //------ МЕТОДЫ ДЛЯ PROFILEINFO.DB ------

  //получить результат последнего теста
  Future<Map<String, dynamic>?> getLastTestResult(int idTest) async {
    final db = await profileDb;
    final result = await db.query(
      'test_result',
      where: 'id_test = ?',
      whereArgs: [idTest],
    );
    return result.isNotEmpty ? result.first : null;
  }

  //получить все результаты с информацией о тестах
  Future<List<Map<String, dynamic>>> getAllTestResultsWithStats() async {
    try {
      //final mainDb = await this.mainDb;
      final profileDb = await this.profileDb;
      final dbPath = await getDatabasesPath();
      final mainPath = join(dbPath, 'maininfo.db');

      await profileDb.execute('ATTACH DATABASE ? AS maindb', [mainPath]);

      final results = await profileDb.rawQuery('''
      SELECT 
        tr.id,
        tr.id_test,
        tr.t_result,
        m.title as test_title,
        m.descr as test_description,
        (SELECT COUNT(*) FROM maindb.question WHERE id_test = tr.id_test) as total_questions
      FROM test_result tr
      INNER JOIN test m ON tr.id_test = m.id
      ORDER BY tr.id DESC
    ''');

      await profileDb.execute('DETACH DATABASE maindb');

      print('Загружено результатов: ${results.length}');
      return results;
    } catch (e) {
      print('ATTACH не сработал, используем альтернативу: $e');
      return [];
    }
  }

  Future<int> deleteOldTestResult(int testId) async {
    final db = await profileDb;
    return await db.delete(
      'test_result',
      where: 'id_test = ?',
      whereArgs: [testId],
    );
  }

  //сохранить или обновить результат теста
  Future<int> saveTestResult(int testId, int result) async {
    final db = await profileDb;
    try {
      return await db.insert('test_result', {
        'id_test': testId,
        't_result': result,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Ошибка сохранения результата: $e');
      return -1;
    }
  }

  //получаем данные профиля
  Future<Map<String, dynamic>?> getUserProfile() async {
    final db = await profileDb;
    final result = await db.query('user_profile', where: 'id = 1');
    return result.isNotEmpty ? result.first : null;
  }

  //сохранить или обновить профиль
  Future<bool> saveUserProfile({String? name, String? photoPath}) async {
    try {
      final db = await profileDb;
      print('Сохранение профиля: имя=$name, фото=$photoPath');

      final data = <String, dynamic>{'id': 1};
      if (name != null) data['name'] = name;
      if (photoPath != null) data['photo_path'] = photoPath;
      data['updated_at'] = DateTime.now().toIso8601String();

      await db.insert(
        'user_profile',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Профиль обновлен');
      return true;
    } catch (e) {
      print('Ошибка сохранения профиля: $e');
      return false;
    }
  }

  //обновить только имя
  Future<bool> updateUserName(String newName) async {
    try {
      print('Обновление имени...');
      print('   Новое имя: $newName');

      final db = await profileDb;

      final before = await db.query('user_profile', where: 'id = 1');
      print('   ДО: $before');

      final data = {
        'name': newName,
        'updated_at': DateTime.now().toIso8601String(),
      };
      print('   Данные: $data');

      final count = await db.update(
        'user_profile',
        data,
        where: 'id = ?',
        whereArgs: [1],
      );

      print('   Обновлено строк: $count');

      final after = await db.query('user_profile', where: 'id = 1');
      print('   ПОСЛЕ: $after');

      return count > 0;
    } catch (e) {
      print('Ошибка обновления имени: $e');
      return false;
    }
  }

  //обновить только фото
  Future<bool> updateUserPhoto(String newPhoto) async {
    //return await saveUserProfile(photoPath: newPhoto);
    try {
      print('Обновление фото');
      print('Путь: $newPhoto');

      final db = await profileDb;

      final before = await db.query('user_profile', where: 'id = 1');
      print('   ДО обновления: $before');

      final data = {
        'photo_path': newPhoto,
        'updated_at': DateTime.now().toIso8601String(),
      };
      print('   Данные для записи: $data');

      // Обновляем
      final count = await db.update(
        'user_profile',
        data,
        where: 'id = ?',
        whereArgs: [1],
      );

      print('   Обновлено строк: $count');

      final after = await db.query('user_profile', where: 'id = 1');
      print('   ПОСЛЕ обновления: $after');

      return count > 0;
    } catch (e) {
      print('Ошибка обновления фото: $e');
      return false;
    }
  }

  Future<User> getUserAsModel() async {
    final profile = await getUserProfile();

    if (profile == null) {
      return UserPreferences.myUser;
    }

    return User(
      name: profile['name'] as String ?? UserPreferences.myUser.name,
      imagePath:
          profile['photo_path'] as String ?? UserPreferences.myUser.imagePath,
      level: UserPreferences.myUser.level,
      isDartMode: UserPreferences.myUser.isDartMode,
    );
  }

  //------ МЕТОДЫ ДЛЯ MAININFO.DB ------

  Future<int> getQuestionsCount(int testId) async {
    final db = await mainDb;
    final result = await db.rawQuery(
      '''
    SELECT COUNT(*) as count 
    FROM question 
    WHERE id_test = ?
  ''',
      [testId],
    );

    return result.first['count'] as int? ?? 0;
  }

  Future<List<Map<String, dynamic>>> getTestById(int testId) async {
    final db = await mainDb;
    return await db.query(
      'question',
      where: 'id_test = ?',
      whereArgs: [testId],
      orderBy: 'id ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getAnswersByQuestionId(
    int questionId,
  ) async {
    final db = await mainDb;
    return await db.query(
      'answer',
      where: 'id_question = ?',
      whereArgs: [questionId],
    );
  }

  //----- ОТЛАДКА ------

  Future<void> debugCheckTestResultTable() async {
    try {
      final db = await profileDb;
      final tables = await db.query(
        'sqlite_master',
        where: 'type = ? AND name = ?',
        whereArgs: ['table', 'test_result'],
      );

      if (tables.isEmpty) {
        print('ТАБЛИЦА test_result НЕ СУЩЕСТВУЕТ в базе данных!');
        return;
      }
      print('Таблица test_result найдена');

      final schema = await db.rawQuery('PRAGMA table_info(test_result)');
      print('Структура:');
      for (var col in schema) {
        print('   - ${col['name']} (${col['type']})');
      }
    } catch (e) {
      print('maininfo.db: $e');
    }

    try {
      final profile = await profileDb;
      final tables = await profile.query(
        'sqlite_master',
        where: 'type = ?',
        whereArgs: ['tables'],
      );
      print('profileinfo.db: ${tables.length} таблиц');

      final results = await profile.query('test_result', limit: 3);
      print('Пример результатов: $results');
    } catch (e) {
      print('profileinfo.db: $e');
    }
    print(' ');
  }

  //------ УТИЛИТЫ ------

  Future<void> closeAllDatabase() async {
    if (_mainDatabase != null) {
      await _mainDatabase!.close();
      _mainDatabase = null;
    }
    if (_profileDatabase != null) {
      await _profileDatabase!.close();
      _profileDatabase = null;
    }
  }

  Future<void> forceUpdateFromAssets() async {
    await closeAllDatabase();

    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'maininfo.db');

      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        print('Старая maininfo.db удалена');
      }

      await Directory(dbPath).create(recursive: true);
      final assetData = await rootBundle.load('assets/data/maininfo.db');
      List<int> bytes = assetData.buffer.asUint8List(
        assetData.offsetInBytes,
        assetData.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes, flush: true);
      print('Новая БД скопирована из assets');
    } catch (e) {
      print('Ошибка при обновлении БД: $e');
    }
  }

  //нужно ли здесь поменять?
  //и нужна ли она?
  Future<int> saveOrUpdateTestResult(int testId, int result) async {
    final db = await profileDb;
    print('Сохранение: testId=$testId, result=$result');

    final existing = await db.query(
      'test_result',
      where: 'id_test = ?',
      whereArgs: [testId],
      limit: 1,
    );
    print('Найдено записей: ${existing.length}');

    if (existing.isNotEmpty) {
      final update = await db.update(
        'test_result',
        {'t_result': result},
        where: 'id_test = ?',
        whereArgs: [testId],
      );
      print('Обновление записей: $update');
      return update;
    } else {
      final insert = await db.insert('test_result', {
        'id_test': testId,
        't_result': result,
      });
      return insert;
    }
  }
}
