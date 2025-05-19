// void main() {}

import 'dart:io';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:csv/csv.dart';

// Helper class to store parsed scripture data temporarily
class ScriptureInfo {
  String? chapterId;
  String? verseId;
  String? text;
  int lineId; // Specifically for IV

  ScriptureInfo({this.chapterId, this.verseId, this.text, this.lineId = 1});

  @override
  String toString() {
    return 'C: $chapterId, V: $verseId, L: $lineId, Text: ${text?.substring(0, (text?.length ?? 0) > 30 ? 30 : (text?.length ?? 0))}...';
  }
}

void main() async {
  final inputFile = File('../html/1.html'); // Assuming your HTML is in this file
  final outputFile = File('output.csv');

  if (!await inputFile.exists()) {
    print('Error: input.html not found!');
    return;
  }

  final htmlContent = await inputFile.readAsString();
  final document = parse(htmlContent);

  final List<List<dynamic>> csvData = [];
  // Add CSV Header
  csvData.add(['IVchapterId', 'IVverseId', 'IVlineId', 'IVverseText', 'KJVchapterId', 'KJVverseId', 'KJVverseText']);

  final table = document.querySelector('table');
  if (table == null) {
    print('Error: No table found in the HTML.');
    return;
  }

  final rows = table.querySelectorAll('tr');
  String? lastIvChapter; // To carry over chapter for unnumbered lines
  String? lastIvVerse; // To carry over verse for unnumbered lines

  for (final row in rows) {
    final cells = row.children.whereType<Element>().toList();
    if (cells.length < 2) continue; // Need at least IV and some other cells

    Element ivCell = cells[0];
    Element? kjvCell;

    // Find KJV cell: It's usually the 4th logical column block.
    // In this HTML, it's often the 3rd Element if colspans are present.
    // Let's check based on width attributes as a heuristic or specific index if consistent.
    // The provided HTML has KJV in the <td> with width="24%" or similar.
    // A more robust way is to check index if structure is consistent:
    // cells[0] = IV, cells[1] (colspan=2), cells[2] (colspan=2) = KJV
    if (cells.length > 2 && cells[2].attributes['width'] == '24%') {
      kjvCell = cells[2];
    } else if (cells.length > 3 && cells[3].attributes['width'] == '24%') {
      // Older structure
      kjvCell = cells[3];
    }

    List<ScriptureInfo> ivVerses = _parseCellForScripture(ivCell, 'IV', lastIvChapter, lastIvVerse);
    List<ScriptureInfo> kjvVerses = _parseCellForScripture(
      kjvCell,
      'KJV',
      null,
      null,
    ); // KJV doesn't need carry-over state

    if (ivVerses.isNotEmpty) {
      lastIvChapter = ivVerses.last.chapterId ?? lastIvChapter;
      lastIvVerse = ivVerses.last.verseId ?? lastIvVerse;
    }

    if (ivVerses.isEmpty && kjvVerses.isNotEmpty) {
      // KJV only, no IV verse in this row to pair with. Create a row for KJV data.
      for (final kjv in kjvVerses) {
        csvData.add([
          null, null, null, null, // IV fields empty
          kjv.chapterId, kjv.verseId, kjv.text,
        ]);
      }
    } else if (ivVerses.isNotEmpty) {
      if (kjvVerses.isEmpty) {
        // IV verses exist, but no KJV verses in this row
        for (final iv in ivVerses) {
          csvData.add([
            iv.chapterId, iv.verseId, iv.lineId, iv.text,
            null, null, null, // KJV fields empty
          ]);
        }
      } else {
        // Both IV and KJV verses exist.
        // The common case seems to be that one KJV verse corresponds to one or more IV verses in the same row.
        // Or, one IV verse corresponds to one KJV verse.
        // For simplicity, if multiple IV and multiple KJV, we'll pair them sequentially as much as possible,
        // then fill remaining with the last one from the shorter list.
        // However, the prompt implies that each IV verse should potentially have its KJV counterpart from that row.
        // If multiple IV verses in a cell and one KJV verse, that KJV verse applies to all those IVs.

        for (int i = 0; i < ivVerses.length; i++) {
          final iv = ivVerses[i];
          // Try to find a KJV verse with the same C:V reference as the IV verse.
          // This is a bit of a guess, as the HTML structure doesn't guarantee direct C:V matching within a row.
          // A simpler approach: if there's one KJV verse, use it for all IVs. If multiple, pair them.
          ScriptureInfo? kjv;
          if (kjvVerses.length == 1) {
            kjv = kjvVerses.first;
          } else if (i < kjvVerses.length) {
            kjv = kjvVerses[i]; // Pair them up if counts are similar
          } else if (kjvVerses.isNotEmpty) {
            kjv = kjvVerses.last; // Or use the last KJV if IVs outnumber KJVs
          }

          csvData.add([iv.chapterId, iv.verseId, iv.lineId, iv.text, kjv?.chapterId, kjv?.verseId, kjv?.text]);
        }
      }
    }
  }

  String csv = const ListToCsvConverter().convert(csvData);
  await outputFile.writeAsString(csv);
  print('CSV data saved to output.csv');
}

List<ScriptureInfo> _parseCellForScripture(Element? cell, String type, String? lastChapter, String? lastVerse) {
  List<ScriptureInfo> entries = [];
  if (cell == null) return entries;

  final paragraphs = cell.querySelectorAll('p');
  List<Node> nodesToParse;

  if (paragraphs.isNotEmpty) {
    nodesToParse = paragraphs;
  } else {
    // If no <p> tags, consider direct child nodes of the cell
    nodesToParse = cell.nodes.toList();
  }

  String? currentChapterForCell = lastChapter;
  String? currentVerseForCell = lastVerse;
  int lineCounterForVerse = 1;

  for (var node in nodesToParse) {
    if (node.nodeType == Node.ELEMENT_NODE || node.nodeType == Node.TEXT_NODE) {
      String rawText = _getNodeText(node).trim();
      if (rawText.isEmpty || rawText == r'\n' || rawText == '<br>') continue;

      // Regex to capture "C:V Text" or "C:V " (verse number only)
      // It tries to find C:V at the beginning of the string.
      final RegExp verseRegex = RegExp(r"^(\d+):(\d+)\s*(.*)", dotAll: true, multiLine: false);
      Match? match = verseRegex.firstMatch(rawText);

      String? chapterId, verseId, verseText;

      if (match != null) {
        chapterId = match.group(1);
        verseId = match.group(2);
        verseText = _cleanText(match.group(3) ?? "");

        if (chapterId == currentChapterForCell && verseId == currentVerseForCell) {
          lineCounterForVerse++;
        } else {
          currentChapterForCell = chapterId;
          currentVerseForCell = verseId;
          lineCounterForVerse = 1;
        }
      } else {
        // No C:V match, this might be a continuation or a line without a number
        verseText = _cleanText(rawText);
        // For IV, if it's a continuation, use last known C:V and increment line
        if (type == 'IV') {
          chapterId = currentChapterForCell; // Use last seen chapter from this cell or row
          verseId = currentVerseForCell; // Use last seen verse
          lineCounterForVerse++; // Assume it's a new line for the current verse
        } else {
          // For KJV, if no C:V, it might be an empty line or something else
          if (verseText.trim().isEmpty || verseText.trim() == '<br>') {
            continue;
          }
          // KJV usually has C:V for each verse, so if not found, it's likely not a standard verse entry
          chapterId = null;
          verseId = null;
          lineCounterForVerse = 1;
        }
      }

      if (verseText.isNotEmpty || chapterId != null) {
        // Add if there's text or a C:V reference
        entries.add(
          ScriptureInfo(
            chapterId: chapterId,
            verseId: verseId,
            text: verseText,
            lineId: (type == 'IV') ? lineCounterForVerse : 1, // IVlineId logic
          ),
        );
      }
    }
  }
  return entries;
}

String _getNodeText(Node node) {
  if (node is Text) {
    return node.text;
  }
  if (node is Element) {
    // Special handling for <br> tags if they are not converted to \n by .text
    // However, .text usually handles this well.
    // For specific needs, one might iterate node.nodes recursively.
    return node.text;
  }
  return '';
}

String _cleanText(String text) {
  return text.replaceAllMapped(RegExp(r'\s*\n\s*|\s{2,}'), (match) {
    if (match.group(0)!.contains('\n')) return ' '; // Replace newlines and surrounding spaces with a single space
    return ' '; // Replace multiple spaces with a single space
  }).trim();
}
