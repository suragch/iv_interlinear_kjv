import 'dart:io';

import 'package:database_creator/database_helper.dart';

Future<void> createOtDatabase() async {
  final dbHelper = DatabaseHelper();
  dbHelper.deleteDatabase();
  dbHelper.init();
  await _populateVersesTable(dbHelper);
  await _populateStrongsTable(dbHelper);
}

Future<void> _populateVersesTable(DatabaseHelper dbHelper) async {
  final interlinear = await _makeInterlinearMap();
  for (int i = 1; i <= 39; i++) {
    print('Populating book $i');
    await _populateVersesForBook(dbHelper, i, interlinear);
  }
}

Future<Map<String, String>> _makeInterlinearMap() async {
  final hebrewPath = '../hebrew/interlinear.csv';
  final lines = await File(hebrewPath).readAsLines();
  final map = <String, String>{};
  // skip csv header so start at line 1
  for (int i = 1; i < lines.length; i++) {
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
  // skip csv header so start at line 1
  for (int i = 1; i < lines.length; i++) {
    final line = lines[i];
    final parts = line.split('\t');
    final kjvChapter = int.tryParse(parts[4]);
    final kjvVerse = int.tryParse(parts[5]);
    final key = '$bookId-$kjvChapter-$kjvVerse';
    final hebrewVerse = interlinear[key];
    dbHelper.insertVerseLine(
      bookId: bookId,
      ivChapter: int.tryParse(parts[1]),
      ivVerse: int.tryParse(parts[2]),
      ivText: parts[3] == 'null' ? null : parts[3],
      kjvChapter: kjvChapter,
      kjvVerse: kjvVerse,
      kjvText: parts[5] == 'null' ? null : parts[6],
      originalText: hebrewVerse,
    );
  }
}

Future<void> _populateStrongsTable(DatabaseHelper dbHelper) async {
  final file = File('../hebrew/bsb_tables.csv');
  final lines = file.readAsLinesSync();
  // first row is headers so start from index 1
  final wordStrongsMap = <String, int>{};
  for (int i = 1; i < lines.length; i++) {
    final line = lines[i];
    final columns = line.split('\t');
    final hebrew = columns[5].trim();
    if (hebrew.isEmpty) continue;
    final strongs = int.tryParse(columns[10].trim());
    if (strongs == null) continue;
    wordStrongsMap[hebrew] = strongs;
  }
  print('${wordStrongsMap.length} key-value pairs');
  int counter = 0;
  for (var entry in wordStrongsMap.entries) {
    if (counter % 5000 == 0) {
      print('Processed $counter entries');
    }
    dbHelper.insertStrongsNumber(hebrew: entry.key, strongsNumber: entry.value);
    counter++;
  }
}
