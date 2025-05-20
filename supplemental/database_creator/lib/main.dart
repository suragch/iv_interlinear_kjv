// void main() {}

import 'dart:io';

import 'html_to_csv.dart';

Future<void> main() async {
  await _convertOtHtmlToCsv();
}

Future<void> _convertOtHtmlToCsv() async {
  await Directory('../original_docs/csv').create(recursive: true);

  for (int i = 1; i <= 39; i++) {
    final inputFile = '../original_docs/html/$i.html';
    final outputFile = '../original_docs/csv/$i.csv';
    await convertHtmlToCsv(inputFile, outputFile, i);
  }
}
