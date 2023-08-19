import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// Table names
const String _tableVerses = "verses";
const String _tableStrongsNumbers = "strongs_numbers";

// Column names
const String keyId = "_id";
const String keyBookId = "bookId";
const String keyIvChapterId = "IVchapterId";
const String keyIvVerseId = "IVverseId";
const String keyIvLineId = "IVlineId";
const String keyIvVerseText = "IVverseText";
const String keyKjvChapterId = "KJVchapterId";
const String keyKjvVerseId = "KJVverseId";
const String keyKjvVerseText = "KJVverseText";
const String keyOriginalVerseText = "originalVerseText";

const String keyGreekWord = "greek_word";
const String keyStrongsNumber = "strongs_number";

class DatabaseHelper {
  static const String _databaseFolder = 'assets';
  static const String _databaseName = "text.db";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    Database? db;
    try {
      db = await openDatabase(path, readOnly: true);
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }
    }

    if (db == null) {
      // Should happen only the first time you launch your application
      if (kDebugMode) {
        print("Creating new copy from asset");
      }

      // Copy from asset
      ByteData data =
          await rootBundle.load(join(_databaseFolder, _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);

      // open the database
      db = await openDatabase(path, readOnly: true);
    } else {
      if (kDebugMode) {
        print("Opening existing database");
      }
    }

    return db;
  }

  // Helper methods

  Future<List<VersesRow>> getChapter(
      bool isInspiredVersion, int bookId, int chapter) async {
    Database db = await database;

    List<String> columnsToSelect = [keyId];
    String chapterColumn =
        (isInspiredVersion) ? keyIvChapterId : keyKjvChapterId;
    String sortOrder = (isInspiredVersion)
        ? '$keyIvChapterId ASC, $keyIvVerseId ASC'
        : '$keyKjvChapterId ASC, $keyKjvVerseId ASC';
    String whereString = '$keyBookId =? AND $chapterColumn =?';
    List<dynamic> whereArguments = [bookId, chapter];
    List<Map> result = await db.query(_tableVerses,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments,
        orderBy: sortOrder);

    int startId = result.first[keyId];
    int endId = result.last[keyId];

    return _getIdRange(db, startId, endId);
  }

  Future<List<VersesRow>> _getIdRange(
      Database db, int startId, int endId) async {
    List<String> columnsToSelect = [
      keyBookId,
      keyIvChapterId,
      keyIvVerseId,
      keyIvLineId,
      keyIvVerseText,
      keyKjvChapterId,
      keyKjvVerseId,
      keyKjvVerseText,
      keyOriginalVerseText,
    ];
    const whereString = '$keyId >=? AND $keyId <=?';
    final whereArguments = [startId, endId];
    final results = await db.query(_tableVerses,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    List<VersesRow> returnList = [];
    for (Map map in results) {
      returnList.add(VersesRow.fromMap(map));
    }
    return returnList;
  }

  Future<int?> getStrongsNumber(String greekWord) async {
    Database db = await database;

    final columnsToSelect = [keyStrongsNumber];
    const whereString = '$keyGreekWord = ?';
    final whereArguments = [greekWord];
    final result = await db.query(_tableStrongsNumbers,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    if (result.isNotEmpty) {
      return result.first[keyStrongsNumber] as int;
    }

    return null;
  }
}

class VersesRow {
  VersesRow({
    required this.id,
    required this.bookId,
    required this.ivChapter,
    required this.ivVerse,
    required this.ivLine,
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
  final int? ivLine;
  final String? ivText;

  final int? kjvChapter;
  final int? kjvVerse;
  final String? kjvText;

  final String? originalText;

  factory VersesRow.fromMap(Map<dynamic, dynamic> map) {
    return VersesRow(
        id: map[keyId],
        bookId: map[keyBookId],
        ivChapter: map[keyIvChapterId],
        ivVerse: map[keyIvVerseId],
        ivLine: map[keyIvLineId],
        ivText: map[keyIvVerseText],
        kjvChapter: map[keyKjvChapterId],
        kjvVerse: map[keyKjvVerseId],
        kjvText: map[keyKjvVerseText],
        originalText: map[keyOriginalVerseText]);
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      keyBookId: bookId,
      keyIvChapterId: ivChapter,
      keyIvVerseId: ivVerse,
      keyIvLineId: ivLine,
      keyIvVerseText: ivText,
      keyKjvChapterId: kjvChapter,
      keyKjvVerseId: kjvVerse,
      keyKjvVerseText: kjvText,
      keyOriginalVerseText: originalText
    };
    if (id != null) {
      map[keyId] = id;
    }
    return map;
  }
}
