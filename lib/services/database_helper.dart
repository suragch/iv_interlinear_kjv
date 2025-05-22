import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Table names
const String _tableVerses = "verses";
const String _tableStrongsNumbers = "strongs_numbers";

// Column names
const String _keyId = "_id";
const String _keyBookId = "bookId";
const String _keyIvChapterId = "IVchapterId";
const String _keyIvVerseId = "IVverseId";
const String _keyIvVerseText = "IVverseText";
const String _keyKjvChapterId = "KJVchapterId";
const String _keyKjvVerseId = "KJVverseId";
const String _keyKjvVerseText = "KJVverseText";
const String _keyOriginalVerseText = "originalVerseText";

const String _keyGreekWord = "greek_word";
const String _keyHebrewWord = "hebrew_word";
const String _keyStrongsNumber = "strongs_number";

class OtDatabaseHelper {
  static const _databaseName = "ot.db";
  static const _databaseVersion = 4;
  late Database _database;

  Future<void> init() async {
    _database = await _initDatabase(_databaseName, _databaseVersion);
  }

  Future<List<VersesRow>> getChapter(int bookId, int chapter) async {
    return await _getChapter(_database, bookId, chapter);
  }

  Future<int?> getStrongsNumber(String hebrewWord) async {
    return await _getStrongsNumber(_database, hebrewWord, _keyHebrewWord);
  }
}

Future<Database> _initDatabase(String databaseName, int databaseVersion) async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, databaseName);
  var exists = await databaseExists(path);

  if (!exists) {
    log("Creating new copy from asset");
    await _copyDatabaseFromAssets(path, databaseName);
  } else {
    // Check if database needs update
    var currentVersion = await _getDatabaseVersion(path);
    if (currentVersion != databaseVersion) {
      log(
        "Updating $databaseName from version $currentVersion to $databaseVersion",
      );
      await deleteDatabase(path);
      await _copyDatabaseFromAssets(path, databaseName);
    } else {
      log("Opening existing database ($databaseName)");
    }
  }
  return await openDatabase(path, version: databaseVersion);
}

Future<int> _getDatabaseVersion(String path) async {
  var db = await openDatabase(path);
  var version = await db.getVersion();
  await db.close();
  return version;
}

Future<void> _copyDatabaseFromAssets(String path, String databaseName) async {
  await Directory(dirname(path)).create(recursive: true);
  final data = await rootBundle.load(join("assets/databases", databaseName));
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(path).writeAsBytes(bytes, flush: true);
}

Future<List<VersesRow>> _getChapter(
  Database db,
  int bookId,
  int chapter,
) async {
  String sortOrder = '$_keyId ASC';
  List<String> columnsToSelect = [
    _keyBookId,
    _keyIvChapterId,
    _keyIvVerseId,
    _keyIvVerseText,
    _keyKjvChapterId,
    _keyKjvVerseId,
    _keyKjvVerseText,
    _keyOriginalVerseText,
  ];
  String whereString =
      '$_keyBookId =? AND ($_keyIvChapterId =? OR $_keyKjvChapterId =?)';
  List<dynamic> whereArguments = [bookId, chapter, chapter];
  final results = await db.query(
    _tableVerses,
    columns: columnsToSelect,
    where: whereString,
    whereArgs: whereArguments,
    orderBy: sortOrder,
  );

  List<VersesRow> returnList = [];
  for (final map in results) {
    returnList.add(VersesRow.fromMap(map));
  }
  return returnList;
}

Future<int?> _getStrongsNumber(
  Database db,
  String word,
  String columnKey,
) async {
  final columnsToSelect = [_keyStrongsNumber];
  final whereString = '$columnKey = ?';
  final whereArguments = [word];
  final result = await db.query(
    _tableStrongsNumbers,
    columns: columnsToSelect,
    where: whereString,
    whereArgs: whereArguments,
  );
  if (result.isNotEmpty) {
    return result.first[_keyStrongsNumber] as int;
  }
  return null;
}

class NtDatabaseHelper {
  static const _databaseName = "text.db";
  static const _databaseVersion = 1;
  late Database _database;

  Future<void> init() async {
    _database = await _initDatabase(_databaseName, _databaseVersion);
  }

  Future<List<VersesRow>> getChapter(int bookId, int chapter) async {
    return await _getChapter(_database, bookId, chapter);
  }

  Future<int?> getStrongsNumber(String greekWord) async {
    return await _getStrongsNumber(_database, greekWord, _keyGreekWord);
  }
}

class VersesRow {
  VersesRow({
    required this.id,
    required this.bookId,
    required this.ivChapter,
    required this.ivVerse,
    required this.ivText,
    required this.kjvChapter,
    required this.kjvVerse,
    required this.kjvText,
    required this.originalText,
  });

  final int? id;
  final int bookId;

  final int? ivChapter;
  final int? ivVerse;
  final String? ivText;

  final int? kjvChapter;
  final int? kjvVerse;
  final String? kjvText;

  final String? originalText;

  factory VersesRow.fromMap(Map<dynamic, dynamic> map) {
    return VersesRow(
      id: map[_keyId] as int?,
      bookId: map[_keyBookId] as int,
      ivChapter: map[_keyIvChapterId] as int?,
      ivVerse: map[_keyIvVerseId] as int?,
      ivText: map[_keyIvVerseText] as String?,
      kjvChapter: map[_keyKjvChapterId] as int?,
      kjvVerse: map[_keyKjvVerseId] as int?,
      kjvText: map[_keyKjvVerseText] as String?,
      originalText: map[_keyOriginalVerseText] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      _keyBookId: bookId,
      _keyIvChapterId: ivChapter,
      _keyIvVerseId: ivVerse,
      _keyIvVerseText: ivText,
      _keyKjvChapterId: kjvChapter,
      _keyKjvVerseId: kjvVerse,
      _keyKjvVerseText: kjvText,
      _keyOriginalVerseText: originalText,
    };
    if (id != null) {
      map[_keyId] = id;
    }
    return map;
  }
}
