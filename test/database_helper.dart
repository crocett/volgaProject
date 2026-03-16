import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Future<Database> _initDatabase() async {
  //   final dbPath = await getDatabasesPath();

  //   final path = join (dbPath, 'maininfo.db');

  //   if(!await databaseExists(path)){
  //     try{
  //       await Directory(dbPath).create(recursive: true);
  //       ByteData data = await rootBundle.load('assets/data/maininfo.db');

  //       List<int> bytes = data.buffer.asUint8List(
  //         data.offsetInBytes,
  //         data.lengthInBytes
  //       );

  //       await File(path).writeAsBytes(bytes, flush: true);
  //       print('БД взята из assets');
  //     } catch(err){
  //       print('Ошибка копирования БД из assets $err');
  //     }
  //   } else {
  //     print('Открытие существующей БД');
  //   }

  //   return await openDatabase(path);
  // }
  
  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'maininfo.db');

      bool shouldCopyFromAssets = false;

      if (await databaseExists(path)) {
        final tempDb = await openDatabase(path, readOnly: true);
        final tables = await tempDb.query(
          'sqlite_master',
          where: 'type = ? AND name = ?',
          whereArgs: ['table', 'article'],
        );
        await tempDb.close();

        if (tables.isEmpty) {
          print('Таблицы не найдены, нужно скопировать БД из assets');
          shouldCopyFromAssets = true;
          await File(path).delete();
        }
      } else {
        shouldCopyFromAssets = true;
      }

      if (shouldCopyFromAssets) {
        await Directory(dbPath).create(recursive: true);

        final assetData = await rootBundle.load('assets/data/maininfo.db');
        List<int> bytes = assetData.buffer.asUint8List(
          assetData.offsetInBytes,
          assetData.lengthInBytes,
        );
        await File(path).writeAsBytes(bytes, flush: true);
      }

      return await openDatabase(path);
    } catch (e) {
      print('Ошибка: $e');
      rethrow;
    }
  }

  Future<void> forceUpdateFromAssets() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'maininfo.db');
      await closeDatabase();

      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        print('Старая бд удалена');
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

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<int> saveTestResult(int idTest, int result) async {
    final db = await database;
    try {
      return await db.insert('test_result', {
        'id_test': idTest,
        't_result': result,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Ошибка при сохранении: $e');
      return -1;
    }
  }

  Future<int> saveOrUpdateTestResult(int testId, int result) async {
    final db = await database;
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

  Future<void> debugCheckTestResultTable() async {
  final db = await database;
  
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
  print('Структура таблицы:');
  for (var col in schema) {
    print('   - ${col['name']} (${col['type']}) ${col['notnull'] == 1 ? 'NOT NULL' : ''}');
  }
  
  final indexes = await db.rawQuery('PRAGMA index_list(test_result)');
  print('Индексы/ограничения: $indexes');
  
  final data = await db.query('test_result', limit: 5);
  print('Пример данных (${data.length} записей): $data');
}

  // Future<Map<String, dynamic>?> getTestResult({required int idTest}) async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> result = await db.query(
  //     'test_result',
  //     where: 'id_test = ?',
  //     whereArgs: [idTest],
  //   );
  //   if (result.isNotEmpty) {
  //     return result.first;
  //   }
  //   return null;
  // }

  Future<int> getQuestionsCount(int testId) async {
    final db = await database;
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

  Future<List<Map<String, dynamic>>> getAllTestResultsWithStats() async {
    final db = await database;
    try {
    final results = await db.rawQuery('''
      SELECT 
        tr.id,
        tr.id_test,
        tr.t_result,
        t.title as test_title,
        t.descr as test_description,
        (SELECT COUNT(*) FROM question WHERE id_test = tr.id_test) as total_questions
      FROM test_result tr
      INNER JOIN test t ON tr.id_test = t.id
      ORDER BY tr.id DESC
    ''');
    
    print('Загружено результатов: ${results.length}');
    return results;
  } catch (e) {
    print('Ошибка SQL запроса: $e');
    return [];
  }
  }

  Future<Map<String, dynamic>?> getLastTestResult(int idTest) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'test_result',
      where: 'id_test = ?',
      whereArgs: [idTest],
      orderBy: 'id DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteOldTestResult(int testId) async {
    final db = await database;
    return await db.delete(
      'test_result',
      where: 'id_test = ?',
      whereArgs: [testId],
    );
  }
}
