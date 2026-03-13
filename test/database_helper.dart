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
      final tables = await tempDb.query('sqlite_master', 
          where: 'type = ? AND name = ?', whereArgs: ['table', 'article']);
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

  Future<void> closeDatabase() async{
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  
}