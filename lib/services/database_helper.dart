import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// TODO: combine databases into one

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
const String keyHebrewWord = "hebrew_word";
const String keyStrongsNumber = "strongs_number";

class OtDatabaseHelper {
  static const _databaseName = "ot.db";
  static const _databaseVersion = 4;
  late Database _database;

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _databaseName);
    var exists = await databaseExists(path);

    if (!exists) {
      log("Creating new copy from asset");
      await _copyDatabaseFromAssets(path);
    } else {
      // Check if database needs update
      var currentVersion = await getDatabaseVersion(path);
      if (currentVersion != _databaseVersion) {
        log(
          "Updating $_databaseName from version $currentVersion to $_databaseVersion",
        );
        await deleteDatabase(path);
        await _copyDatabaseFromAssets(path);
      } else {
        log("Opening existing database ($_databaseName)");
      }
    }
    _database = await openDatabase(path, version: _databaseVersion);
  }

  Future<int> getDatabaseVersion(String path) async {
    var db = await openDatabase(path);
    var version = await db.getVersion();
    await db.close();
    return version;
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    await Directory(dirname(path)).create(recursive: true);
    final data = await rootBundle.load(join("assets/databases", _databaseName));
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await File(path).writeAsBytes(bytes, flush: true);
  }

  // Helper methods

  Future<List<VersesRow>> getChapter(int bookId, int chapter) async {
    // Database db = await database;

    String sortOrder = '$keyId ASC';
    List<String> columnsToSelect = [
      keyBookId,
      keyIvChapterId,
      keyIvVerseId,
      keyIvVerseText,
      keyKjvChapterId,
      keyKjvVerseId,
      keyKjvVerseText,
      keyOriginalVerseText,
    ];
    String whereString =
        '$keyBookId =? AND ($keyIvChapterId =? OR $keyKjvChapterId =?)';
    List<dynamic> whereArguments = [bookId, chapter, chapter];
    final results = await _database.query(
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

  Future<int?> getStrongsNumber(String hebrewWord) async {
    // Database db = await database;

    final columnsToSelect = [keyStrongsNumber];
    const whereString = '$keyHebrewWord = ?';
    final whereArguments = [hebrewWord];
    final result = await _database.query(
      _tableStrongsNumbers,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: whereArguments,
    );

    if (result.isNotEmpty) {
      return result.first[keyStrongsNumber] as int;
    }

    return null;
  }
}

class NtDatabaseHelper {
  static const _databaseName = "text.db";
  static const _databaseVersion = 1;
  late Database _database;

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _databaseName);
    var exists = await databaseExists(path);

    if (!exists) {
      log("Creating new copy from asset");
      await _copyDatabaseFromAssets(path);
    } else {
      // Check if database needs update
      var currentVersion = await getDatabaseVersion(path);
      if (currentVersion != _databaseVersion) {
        log(
          "Updating database from version $currentVersion to $_databaseVersion",
        );
        await deleteDatabase(path);
        await _copyDatabaseFromAssets(path);
      } else {
        log("Opening existing database");
      }
    }
    _database = await openDatabase(path, version: _databaseVersion);
  }

  Future<int> getDatabaseVersion(String path) async {
    var db = await openDatabase(path);
    var version = await db.getVersion();
    await db.close();
    return version;
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    await Directory(dirname(path)).create(recursive: true);
    final data = await rootBundle.load(join("assets/databases", _databaseName));
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await File(path).writeAsBytes(bytes, flush: true);
  }

  // static const String _databaseFolder = 'assets/databases';
  // static const String _databaseName = "text.db";
  // static const int _databaseVersion = 1; // Add version number

  // NtDatabaseHelper._privateConstructor();
  // static final NtDatabaseHelper instance =
  //     NtDatabaseHelper._privateConstructor();

  // static Database? _database;
  // Future<Database> get database async {
  //   if (_database != null) return _database!;
  //   _database = await _initDatabase();
  //   return _database!;
  // }

  // Future<Database> _initDatabase() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, _databaseName);

  //   // Check if we need to copy the database
  //   bool shouldCopy = false;
  //   try {
  //     Database db = await openDatabase(path, readOnly: true);
  //     int version = await db.getVersion();
  //     if (version != _databaseVersion) {
  //       await db.close();
  //       shouldCopy = true;
  //     } else {
  //       return db;
  //     }
  //   } catch (e) {
  //     shouldCopy = true;
  //   }

  //   if (shouldCopy) {
  //     // Delete existing database if it exists
  //     try {
  //       await File(path).delete();
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print("Error deleting old database: $e");
  //       }
  //     }

  //     // Copy from asset
  //     if (kDebugMode) {
  //       print("Creating new NT db copy from asset");
  //     }
  //     ByteData data = await rootBundle.load(
  //       join(_databaseFolder, _databaseName),
  //     );
  //     List<int> bytes = data.buffer.asUint8List(
  //       data.offsetInBytes,
  //       data.lengthInBytes,
  //     );
  //     await File(path).writeAsBytes(bytes);

  //     // Open and set version
  //     Database db = await openDatabase(path, readOnly: true);
  //     await db.setVersion(_databaseVersion);
  //     return db;
  //   }

  //   return await openDatabase(path, readOnly: true);
  // }

  // Helper methods

  Future<List<VersesRow>> getChapter(
    bool isInspiredVersion,
    int bookId,
    int chapter,
  ) async {
    // Database db = await database;

    List<String> columnsToSelect = [keyId];
    String chapterColumn = (isInspiredVersion)
        ? keyIvChapterId
        : keyKjvChapterId;
    String sortOrder = (isInspiredVersion)
        ? '$keyIvChapterId ASC, $keyIvVerseId ASC'
        : '$keyKjvChapterId ASC, $keyKjvVerseId ASC';
    String whereString = '$keyBookId =? AND $chapterColumn =?';
    List<dynamic> whereArguments = [bookId, chapter];
    final result = await _database.query(
      _tableVerses,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: whereArguments,
      orderBy: sortOrder,
    );

    final startId = result.first[keyId] as int;
    final endId = result.last[keyId] as int;

    return _getIdRange(_database, startId, endId);
  }

  Future<List<VersesRow>> _getIdRange(
    Database db,
    int startId,
    int endId,
  ) async {
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
    final results = await db.query(
      _tableVerses,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: whereArguments,
    );

    List<VersesRow> returnList = [];
    for (final map in results) {
      returnList.add(VersesRow.fromMap(map));
    }
    return returnList;
  }

  Future<int?> getStrongsNumber(String greekWord) async {
    // Database db = await database;

    final columnsToSelect = [keyStrongsNumber];
    const whereString = '$keyGreekWord = ?';
    final whereArguments = [greekWord];
    final result = await _database.query(
      _tableStrongsNumbers,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: whereArguments,
    );

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
      id: map[keyId] as int?,
      bookId: map[keyBookId] as int,
      ivChapter: map[keyIvChapterId] as int?,
      ivVerse: map[keyIvVerseId] as int?,
      ivLine: map[keyIvLineId] as int?,
      ivText: map[keyIvVerseText] as String?,
      kjvChapter: map[keyKjvChapterId] as int?,
      kjvVerse: map[keyKjvVerseId] as int?,
      kjvText: map[keyKjvVerseText] as String?,
      originalText: map[keyOriginalVerseText] as String?,
    );
  }

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
      keyOriginalVerseText: originalText,
    };
    if (id != null) {
      map[keyId] = id;
    }
    return map;
  }
}
