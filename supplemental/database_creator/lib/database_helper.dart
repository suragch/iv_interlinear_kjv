import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

class DatabaseHelper {
  final String _databaseName = "ot.db";
  late Database _database;

  void init() {
    _database = sqlite3.open(_databaseName);
    _createVersesTable();
    _createStrongsTable();
  }

  void deleteDatabase() {
    final file = File(_databaseName);
    if (file.existsSync()) {
      print('Deleting database file: $_databaseName');
      file.deleteSync();
    }
  }

  void _createVersesTable() {
    _database.execute(Schema.createVerseTable);
  }

  void _createStrongsTable() {
    _database.execute(Schema.createStrongsTable);
  }

  void insertVerseLine({
    required int bookId,
    required int? ivChapter,
    required int? ivVerse,
    required String? ivText,
    required int? kjvChapter,
    required int? kjvVerse,
    required String? kjvText,
    required String? originalText,
  }) {
    _database.execute(
      '''
      INSERT INTO ${Schema.versesTable} (
        ${Schema.colBookId},
        ${Schema.colIvChapter},
        ${Schema.colIvVerse},
        ${Schema.colIvText},
        ${Schema.colKjvChapter},
        ${Schema.colKjvVerse},
        ${Schema.colKjvText},
        ${Schema.colOriginal}
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [bookId, ivChapter, ivVerse, ivText, kjvChapter, kjvVerse, kjvText, originalText],
    );
  }

  void insertStrongsNumber({required String hebrew, required int strongsNumber}) {
    _database.execute(
      '''
      INSERT INTO ${Schema.strongsTable} (
        ${Schema.colHebrew},
        ${Schema.colStrongsNumber}
      ) VALUES (?, ?)
      ''',
      [hebrew, strongsNumber],
    );
  }
}

class Schema {
  static const String versesTable = "verses";

  // verse column names
  static const String colId = '_id';
  static const String colBookId = 'bookId';
  static const String colIvChapter = 'IVchapterId';
  static const String colIvVerse = 'IVverseId';
  static const String colIvText = 'IVverseText';
  static const String colKjvChapter = 'KJVchapterId';
  static const String colKjvVerse = 'KJVverseId';
  static const String colKjvText = 'KJVverseText';
  static const String colOriginal = 'originalVerseText';

  // SQL statements
  static const String createVerseTable = '''
  CREATE TABLE IF NOT EXISTS $versesTable (
    $colId INTEGER PRIMARY KEY AUTOINCREMENT,
    $colBookId INTEGER NOT NULL,
    $colIvChapter INTEGER,
    $colIvVerse INTEGER,
    $colIvText TEXT,
    $colKjvChapter INTEGER,
    $colKjvVerse INTEGER,
    $colKjvText TEXT,
    $colOriginal TEXT
  )
  ''';

  // Strong's number table
  static const String strongsTable = "strongs";

  // strongs column names
  static const String strongsColId = '_id';
  static const String colHebrew = 'hebrew_word';
  static const String colStrongsNumber = 'strongs_number';

  // SQL statements
  static const String createStrongsTable = '''
  CREATE TABLE IF NOT EXISTS $strongsTable (
    $strongsColId INTEGER PRIMARY KEY AUTOINCREMENT,
    $colHebrew TEXT NOT NULL,
    $colStrongsNumber INTEGER NOT NULL
  )
  ''';
}
