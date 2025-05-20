import 'dart:io';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:csv/csv.dart';

class ScriptureInfo {
  String? chapterId;
  String? verseId;
  String? text;

  ScriptureInfo({this.chapterId, this.verseId, this.text});
}

Future<void> convertHtmlToCsv(String inputPath, String outputPath, int bookId) async {
  final inputFile = File(inputPath);
  final outputFile = File(outputPath);

  if (!await inputFile.exists()) {
    print('Error: input.html not found!');
    return;
  }

  final htmlContent = await inputFile.readAsString();
  final document = parse(htmlContent);

  final List<List<dynamic>> csvData = [];
  csvData.add(['bookId', 'IVchapterId', 'IVverseId', 'IVverseText', 'KJVchapterId', 'KJVverseId', 'KJVverseText']);

  final table = document.querySelector('table');
  if (table == null) {
    print('Error: No table found in the HTML.');
    return;
  }

  final rows = table.querySelectorAll('tr');

  for (final row in rows) {
    final cells = row.children.whereType<Element>().toList();

    // Expecting at least 3 <td> elements to access cells[0] and cells[2]
    // The actual structure in the sample often has 4+ elements due to colspans
    // but we are interested in the logical cells.
    if (cells.length < 3) {
      // This check might need adjustment if some rows legitimately have fewer
      // than 3 actual <td> elements that we care about.
      // Given the fixed rule, if a row doesn't have cells[0] and cells[2], it's problematic.
      // For the provided HTML, this check should mostly pass for relevant rows.
      // If it's a row with just <br/>, _parseCellForSingleVerse will handle it.
      if (cells.isNotEmpty &&
          (cells[0].text.trim().isNotEmpty || (cells.length > 2 && cells[2].text.trim().isNotEmpty))) {
        print(
          "Found row with less than 3 significant cells: ${row.innerHtml.substring(0, row.innerHtml.length > 80 ? 80 : row.innerHtml.length)}...",
        );
      }
      // continue; // Might skip header or other structural rows, be cautious.
      // Let's try to process what we can, parseCell will return empty info if cell is invalid.
    }

    Element? ivCell = cells.isNotEmpty ? cells[0] : null;
    Element? kjvCell = cells.length > 2 ? cells[2] : null;

    ScriptureInfo ivInfo = _parseCellForSingleVerse(ivCell);
    ScriptureInfo kjvInfo = _parseCellForSingleVerse(kjvCell);

    // Only add row if there's some actual scripture data
    if (ivInfo.chapterId != null || ivInfo.text!.isNotEmpty || kjvInfo.chapterId != null || kjvInfo.text!.isNotEmpty) {
      csvData.add([
        bookId,
        ivInfo.chapterId,
        ivInfo.verseId,
        ivInfo.text,
        kjvInfo.chapterId,
        kjvInfo.verseId,
        kjvInfo.text,
      ]);
    }
  }

  String csv = const ListToCsvConverter().convert(csvData);
  await outputFile.writeAsString(csv);
  print('CSV data saved to ${outputFile.path}');
}

ScriptureInfo _parseCellForSingleVerse(Element? cell) {
  if (cell == null) {
    return ScriptureInfo(chapterId: null, verseId: null, text: '');
  }

  String? chapterId;
  String? verseId;
  StringBuffer fullRichTextBuffer = StringBuffer();
  String? firstCvPrefixPlainText; // To store the "C:V" from plain text

  // Get all <p> tags or direct children if no <p>
  List<Node> nodesToProcess =
      cell.querySelectorAll('p').isNotEmpty ? cell.querySelectorAll('p').toList() : cell.nodes.toList();

  bool cvFound = false;

  for (int i = 0; i < nodesToProcess.length; i++) {
    var node = nodesToProcess[i];
    String currentBlockPlainText = _extractPlainTextContent(node).trim();

    if (currentBlockPlainText.isEmpty || currentBlockPlainText.toLowerCase() == '<br>') continue;

    if (!cvFound) {
      // Try to find C:V only once, from the plain text of the first relevant block
      final RegExp verseRegex = RegExp(r"^\s*(\d+):(\d+)\s*(.*)", dotAll: true);
      Match? cvMatch = verseRegex.firstMatch(currentBlockPlainText);
      if (cvMatch != null) {
        chapterId = cvMatch.group(1);
        verseId = cvMatch.group(2);
        firstCvPrefixPlainText = "$chapterId:$verseId"; // Store the plain text C:V for cleanup
        cvFound = true;
      }
    }

    // Build rich text for the current node (e.g., <p> or direct text node)
    fullRichTextBuffer.write(_buildRichTextFromNode(node));
    if (i < nodesToProcess.length - 1 && currentBlockPlainText.isNotEmpty) {
      fullRichTextBuffer.write(' '); // Add space between concatenated paragraph/node contents
    }
  }

  String finalRichText = _finalCsvCellCleanup(fullRichTextBuffer.toString(), firstCvPrefixPlainText);

  return ScriptureInfo(chapterId: chapterId, verseId: verseId, text: finalRichText);
}

// Extracts plain text content from a node, normalizing whitespace.
String _extractPlainTextContent(Node node) {
  if (node is Text) return node.text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (node is Element) return node.text.replaceAll(RegExp(r'\s+'), ' ').trim();
  return "";
}

// Builds the rich text string from a single top-level node (like a <p> or a text node)
String _buildRichTextFromNode(Node node) {
  if (node is Text) {
    return node.text; // Keep original spacing for now, _finalCsvCellCleanup will handle it
  }
  if (node is Element) {
    return _buildRichTextFromNodeListRecursive(node.nodes.toList());
  }
  return "";
}

// Recursively builds rich text, keeping <b>, stripping <u>, processing children
String _buildRichTextFromNodeListRecursive(List<Node> nodes) {
  StringBuffer sb = StringBuffer();
  for (var node in nodes) {
    if (node is Text) {
      sb.write(node.text);
    } else if (node is Element) {
      String localName = node.localName!.toLowerCase();
      if (localName == 'b' || localName == 'strong') {
        String innerBoldText = _buildRichTextFromNodeListRecursive(node.nodes.toList());
        // Avoid creating empty <b></b> or <b> </b> if content is just space after recursion
        if (innerBoldText.trim().isNotEmpty) {
          sb.write('<b>$innerBoldText</b>');
        } else {
          sb.write(innerBoldText); // Append if it's just whitespace, to be trimmed later
        }
      } else if (localName == 'u') {
        sb.write(_buildRichTextFromNodeListRecursive(node.nodes.toList())); // Discard <u> but process children
      } else if (localName == 'br') {
        sb.write(' '); // Treat <br> as a space for concatenation
      }
      // For <font>, <p>, <div>, <span> and other container-like tags, process their children.
      // We don't want to re-add <p> tags if we are already processing inside one from _parseCellForSingleVerse.
      // This function is about content *within* a block element like <p> or direct children of <td>.
      else if (['font', 'span', 'div'].contains(localName)) {
        sb.write(_buildRichTextFromNodeListRecursive(node.nodes.toList()));
      } else {
        // For unknown tags, just get their text content to be safe or recurse
        sb.write(_buildRichTextFromNodeListRecursive(node.nodes.toList()));
      }
    }
  }
  return sb.toString();
}

String _finalCsvCellCleanup(String rawRichText, String? plainCvPrefixToRemove) {
  String text = rawRichText;

  if (plainCvPrefixToRemove != null && plainCvPrefixToRemove.isNotEmpty) {
    // Remove the plain text C:V prefix only if it's at the absolute beginning,
    // potentially followed by a space. This is less aggressive.
    String prefixWithSpace = plainCvPrefixToRemove + " ";
    String trimmedTextStart = text.trimLeft(); // Look at the start after trimming leading whitespace

    if (trimmedTextStart.startsWith(prefixWithSpace)) {
      // Find the actual start of the prefix in the *untrimmed* text to remove correctly
      int actualPrefixStartIndex = text.indexOf(prefixWithSpace);
      if (actualPrefixStartIndex != -1) {
        // Should be 0 or near 0 if trimLeft worked
        text = text.substring(actualPrefixStartIndex + prefixWithSpace.length);
      }
    } else if (trimmedTextStart.startsWith(plainCvPrefixToRemove)) {
      int actualPrefixStartIndex = text.indexOf(plainCvPrefixToRemove);
      if (actualPrefixStartIndex != -1) {
        text = text.substring(actualPrefixStartIndex + plainCvPrefixToRemove.length);
      }
    }
  }

  // Normalize multiple spaces (including those from <br>) and newlines to a single space
  text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  // Remove empty bold tags or bold tags with only space
  text = text.replaceAll(RegExp(r'<b>\s*</b>', caseSensitive: false), '').trim();
  // Normalize spaces again after potential tag removal and trim final result
  text = text.replaceAll(RegExp(r'\s{2,}', caseSensitive: false), ' ').trim();

  return text;
}
