import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// Table names
final String _tableVerses = "verses";
final String _tableStrongsNumbers = "strongs_numbers";

// Column names
final String KEY_ID = "_id";
final String KEY_BOOKID = "bookId";
final String KEY_IV_CHAPTERID = "IVchapterId";
final String KEY_IV_VERSEID = "IVverseId";
final String KEY_IV_LINEID = "IVlineId";
final String KEY_IV_VERSETEXT = "IVverseText";
final String KEY_KJV_CHAPTERID = "KJVchapterId";
final String KEY_KJV_VERSEID = "KJVverseId";
final String KEY_KJV_VERSETEXT = "KJVverseText";
final String KEY_ORIGINAL_VERSETEXT = "originalVerseText";

final String KEY_GREEK_WORD = "greek_word";
final String KEY_STRONGS_NUMBER = "strongs_number";

class DatabaseHelper {
  static final String _databaseFolder = 'assets';
  static final String _databaseName = "text.db";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    Database db;
    try {
      db = await openDatabase(path, readOnly: true);
    } catch (e) {
      print("Error $e");
    }

    if (db == null) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Copy from asset
      ByteData data = await rootBundle.load(join(_databaseFolder, _databaseName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);

      // open the database
      db = await openDatabase(path, readOnly: true);
    } else {
      print("Opening existing database");
    }

    return db;
  }

  // Helper methods

  Future<List<VersesRow>> getChapter(
      bool isInspiredVersion, int bookId, int chapter) async {
    Database db = await database;

    List<String> columnsToSelect = [KEY_ID];
    String chapterColumn =
    (isInspiredVersion) ? KEY_IV_CHAPTERID : KEY_KJV_CHAPTERID;
    String sortOrder = (isInspiredVersion)
        ? '$KEY_IV_CHAPTERID ASC, $KEY_IV_VERSEID ASC'
        : '$KEY_KJV_CHAPTERID ASC, $KEY_KJV_VERSEID ASC';
    String whereString = '$KEY_BOOKID =? AND $chapterColumn =?';
    List<dynamic> whereArguments = [bookId, chapter];
    List<Map> result = await db.query(_tableVerses,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments,
        orderBy: sortOrder);

    int startId = result.first[KEY_ID];
    int endId = result.last[KEY_ID];

    return _getIdRange(db, startId, endId);
  }

  Future<List<VersesRow>> _getIdRange(
      Database db, int startId, int endId) async {
    List<String> columnsToSelect = [
      KEY_BOOKID,
      KEY_IV_CHAPTERID,
      KEY_IV_VERSEID,
      KEY_IV_LINEID,
      KEY_IV_VERSETEXT,
      KEY_KJV_CHAPTERID,
      KEY_KJV_VERSEID,
      KEY_KJV_VERSETEXT,
      KEY_ORIGINAL_VERSETEXT,
    ];
    final whereString = '$KEY_ID >=? AND $KEY_ID <=?';
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

  Future<int> getStrongsNumber(String greekWord) async {
    Database db = await database;

    final columnsToSelect = [KEY_STRONGS_NUMBER];
    final whereString = '$KEY_GREEK_WORD = ?';
    final whereArguments = [greekWord];
    final result = await db.query(_tableStrongsNumbers,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    if (result.length > 0) {
      return result.first[KEY_STRONGS_NUMBER];
    }

    return null;
  }
}

class VersesRow {
  int id;
  int bookId;

  int ivChapter;
  int ivVerse;
  int ivLine;
  String ivText;

  int kjvChapter;
  int kjvVerse;
  String kjvText;

  String originalText;

  VersesRow();

  VersesRow.fromMap(Map<String, dynamic> map) {
    id = map[KEY_ID];
    bookId = map[KEY_BOOKID];
    ivChapter = map[KEY_IV_CHAPTERID];
    ivVerse = map[KEY_IV_VERSEID];
    ivLine = map[KEY_IV_LINEID];
    ivText = map[KEY_IV_VERSETEXT];

    kjvChapter = map[KEY_KJV_CHAPTERID];
    kjvVerse = map[KEY_KJV_VERSEID];
    kjvText = map[KEY_KJV_VERSETEXT];

    originalText = map[KEY_ORIGINAL_VERSETEXT];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      KEY_BOOKID: bookId,
      KEY_IV_CHAPTERID: ivChapter,
      KEY_IV_VERSEID: ivVerse,
      KEY_IV_LINEID: ivLine,
      KEY_IV_VERSETEXT: ivText,
      KEY_KJV_CHAPTERID: kjvChapter,
      KEY_KJV_VERSEID: kjvVerse,
      KEY_KJV_VERSETEXT: kjvText,
      KEY_ORIGINAL_VERSETEXT: originalText
    };
    if (id != null) {
      map[KEY_ID] = id;
    }
    return map;
  }
}
