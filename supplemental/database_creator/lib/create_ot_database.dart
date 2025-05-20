import 'dart:io';

import 'package:database_creator/database_helper.dart';

Future<void> createOtDatabase() async {
  final dbHelper = DatabaseHelper();
  dbHelper.init();
  dbHelper.deleteDatabase();
  await _populateVersesTable();
  await _populateStrongsTable();
}

Future<void> _populateVersesTable() async {
  final hebrewPath = '../hebrew/interlinear.csv';
  final hebrewLines = await File(hebrewPath).readAsLines();
  final interlinear = _makeInterlinearMap(hebrewLines);
  final dbHelper = DatabaseHelper();

  for (int i = 1; i <= 39; i++) {
    print('Populating book $i');
    await _populateVersesForBook(dbHelper, i, interlinear);
  }
}

Map<String, String> _makeInterlinearMap(List<String> lines) {
  final map = <String, String>{};
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final parts = line.split('\t');
    final key = '${parts[0]}-${parts[1]}-${parts[2]}';
    map[key] = parts[3];
  }
  return map;
}

Future<void> _populateVersesForBook(DatabaseHelper dbHelper, int bookId, Map<String, String> interlinear) async {
  final inputFile = File('../original_docs/csv/$bookId.csv');
  final lines = await inputFile.readAsLines();
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final parts = line.split('\t');
    final kjvChapter = int.tryParse(parts[3]);
    final kjvVerse = int.tryParse(parts[4]);
    final key = '$bookId-$kjvChapter-$kjvVerse';
    final hebrewVerse = interlinear[key];
    dbHelper.insertVerseLine(
      bookId: bookId,
      ivChapter: int.tryParse(parts[0]),
      ivVerse: int.tryParse(parts[1]),
      ivText: parts[2] == 'null' ? null : parts[2],
      kjvChapter: kjvChapter,
      kjvVerse: kjvVerse,
      kjvText: parts[5] == 'null' ? null : parts[5],
      originalText: hebrewVerse,
    );
  }
}

Future<void> _populateStrongsTable() async {}
