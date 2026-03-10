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

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath(); 

    final path = join (dbPath, 'maininfo.db');

    if(!await databaseExists(path)){
      try{
        await Directory(dbPath).create(recursive: true);
        ByteData data = await rootBundle.load('assets/data/maininfo.db');

        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes
        );

        await File(path).writeAsBytes(bytes, flush: true);
        print('БД взята из assets');
      } catch(err){
        print('Ошибка копирования БД из assets $err');
      }
    } else {
      print('Открытие существующей БД');
    }

    return await openDatabase(path);
  }

  Future<void> closeDatabase() async{
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}