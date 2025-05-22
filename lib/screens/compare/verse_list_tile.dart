import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iv_interlinear_kjv/services/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class NarrowVerseListTile extends StatelessWidget {
  final int index;
  final List<VersesRow> verses;
  final bool isOT;

  const NarrowVerseListTile({
    super.key,
    required this.index,
    required this.verses,
    required this.isOT,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(_ivTitle(verses[index])),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 10.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: _ivText(verses[index]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(_originalTitle(verses[index])),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 10.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: _originalText(verses[index], isOT),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(_kjvTitle(verses[index])),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 32.0,
                right: 10.0,
                bottom: 10.0,
              ),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: _kjvText(verses[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WideVerseListTile extends StatelessWidget {
  final int index;
  final List<VersesRow> verses;
  final bool isOT;

  const WideVerseListTile({
    super.key,
    required this.index,
    required this.verses,
    required this.isOT,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 4.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _inspiredVersion(context),
            _original(context),
            _kingJamesVersion(context),
          ],
        ),
      ),
    );
  }

  Widget _inspiredVersion(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(_ivTitle(verses[index])),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: _ivText(verses[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _original(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(_originalTitle(verses[index])),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: _originalText(verses[index], isOT),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kingJamesVersion(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(_kjvTitle(verses[index])),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: _kjvText(verses[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _title(String version, String? verseText, int? chapter, int? verse) {
  if (verseText == null || chapter == null || verse == null) {
    return version;
  }
  return '$version ($chapter:$verse)';
}

String _ivTitle(VersesRow row) {
  return _title('Inspired Version', row.ivText, row.ivChapter, row.ivVerse);
}

List<TextSpan> _ivText(VersesRow row) {
  return _text(row.ivText);
}

String _originalTitle(VersesRow row) {
  return _title('Greek', row.kjvText, row.kjvChapter, row.kjvVerse);
}

List<TextSpan> _originalText(VersesRow? row, bool isOT) {
  String? text = row?.originalText;
  List<TextSpan> spans = [];
  if (text == null) {
    spans.add(const TextSpan(text: '---'));
    return spans;
  }

  // \u0370-\u03FF Greek
  // \u1F00-\u1FFF Greek Extended
  // \u0590-\u05FF Hebrew
  // \u200D Zero Width Joiner (occurs in some Hebrew words)
  // The repeat after a space allows multiple words.
  final original = RegExp(
    r'[\u0370-\u03FF\u1F00-\u1FFF\u0590-\u05FF\u200D]+(?:\s[\u0370-\u03FF\u1F00-\u1FFF\u0590-\u05FF\u200D]+)*',
  );

  // const String greek = r'\\u0370-\\u03FF';
  // const String greekExtended = r'\\u1F00-\\u1FFF';
  // const String hebrew = r'\\u0590-\\u05FF';
  // const String zwj =
  //     r'\\u200D'; // Zero Width Joiner (occurs in some Hebrew words)
  // const String original = '$greek$hebrew$greekExtended$zwj';
  // final originalWithSpaces = RegExp('[$original]+(?:\\s[$original]+)*');

  int lastIndex = 0;
  for (Match match in original.allMatches(text)) {
    if (match.start > lastIndex) {
      spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
    }

    spans.add(
      TextSpan(
        text: match.group(0),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _openWordInBrowser(isOT, match.group(0)!);
          },
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
        ),
      ),
    );

    lastIndex = match.end;
  }

  if (lastIndex < text.length) {
    spans.add(TextSpan(text: text.substring(lastIndex)));
  }

  return spans;
}

// int startIndex = 0;
// int endIndex = 0;
// int breakIndex = 0;

// do {
//   startIndex = _indexOfOriginalStart(text, breakIndex);
//   endIndex = _indexOfOriginalEnd(text, startIndex);

//   if (startIndex == -1 || endIndex == -1) {
//     spans.add(TextSpan(text: text.substring(breakIndex)));
//     return spans;
//   }

//   if (startIndex > breakIndex) {
//     spans.add(TextSpan(text: text.substring(breakIndex, startIndex)));
//   }

//   final spanText = text.substring(startIndex, endIndex);
//   spans.add(
//     TextSpan(
//       text: spanText,
//       recognizer: TapGestureRecognizer()
//         ..onTap = () {
//           _openWordInBrowser(isOT, spanText);
//         },
//       style: const TextStyle(
//         color: Colors.blue,
//         decoration: TextDecoration.underline,
//         decorationColor: Colors.blue,
//       ),
//     ),
//   );

//   breakIndex = endIndex;
// } while (breakIndex < text.length);

// return spans;
// }

int _indexOfOriginalStart(String text, int fromIndex) {
  for (int i = fromIndex; i < text.length; i++) {
    if (isOriginal(text.codeUnitAt(i))) {
      return i;
    }
  }
  return -1;
}

int _indexOfOriginalEnd(String text, int fromIndex) {
  if (fromIndex < 0) return -1;
  for (int i = fromIndex; i < text.length; i++) {
    if (!isOriginal(text.codeUnitAt(i))) {
      return i;
    }
  }
  return text.length;
}

_openWordInBrowser(bool isOT, String word) async {
  int? strongsNumber;
  if (isOT) {
    final helper = OtDatabaseHelper.instance;
    strongsNumber = await helper.getStrongsNumber(word);
  } else {
    final helper = NtDatabaseHelper.instance;
    strongsNumber = await helper.getStrongsNumber(word);
  }
  if (strongsNumber == null) {
    return;
  }
  final language = isOT ? 'hebrew' : 'greek';
  final url = Uri.parse('https://biblehub.com/$language/$strongsNumber.htm');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    return;
  }
}

const _greekMin = 0x0370;
const _greekMax = 0x03ff;
const _greekExtendedMin = 0x1f00;
const _greekExtendedMax = 0x1fff;

bool isOriginal(int char) {
  return _isHebrew(char) || _isGreek(char);
}

bool _isGreek(int c) {
  return ((c >= _greekMin && c <= _greekMax) ||
      (c >= _greekExtendedMin && c <= _greekExtendedMax));
}

bool _isHebrew(int c) {
  return c == 0x200d || (c >= 0x0590 && c <= 0x05FF);
}

String _kjvTitle(VersesRow row) {
  return _title(
    'King James Version',
    row.kjvText,
    row.kjvChapter,
    row.kjvVerse,
  );
}

List<TextSpan> _kjvText(VersesRow row) {
  return _text(row.kjvText);
}

List<TextSpan> _text(String? verseText) {
  List<TextSpan> spans = [];
  if (verseText == null) {
    spans.add(const TextSpan(text: '---'));
    return spans;
  }

  const boldStart = '<b>';
  const boldEnd = r'</b>';
  int startIndex = 0;
  int endIndex = 0;
  int breakIndex = 0;

  do {
    startIndex = verseText.indexOf(boldStart, breakIndex);
    endIndex = verseText.indexOf(boldEnd, breakIndex);

    if (startIndex == -1 || endIndex == -1) {
      spans.add(TextSpan(text: verseText.substring(breakIndex)));
      return spans;
    }

    if (startIndex > breakIndex) {
      spans.add(TextSpan(text: verseText.substring(breakIndex, startIndex)));
    }

    startIndex += boldStart.length;
    spans.add(
      TextSpan(
        text: verseText.substring(startIndex, endIndex),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );

    breakIndex = endIndex + boldEnd.length;
  } while (breakIndex < verseText.length);

  return spans;
}
