import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iv_interlinear_kjv/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class NarrowVerseListTile extends StatelessWidget {
  final int index;
  final List<VersesRow> verses;

  const NarrowVerseListTile({
    super.key,
    required this.index,
    required this.verses,
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
              child: Text(
                _ivTitle(verses[index]),
              ),
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
              child: Text(
                _originalTitle(verses[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 10.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: _originalText(verses[index]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _kjvTitle(verses[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 10.0, bottom: 10.0),
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

  const WideVerseListTile({
    super.key,
    required this.index,
    required this.verses,
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
            _greek(context),
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
            child: Text(
              _ivTitle(verses[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
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

  Widget _greek(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              _originalTitle(verses[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: _originalText(verses[index]),
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
            child: Text(
              _kjvTitle(verses[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
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
  return _title(
    'Inspired Version',
    row.ivText,
    row.ivChapter,
    row.ivVerse,
  );
}

List<TextSpan> _ivText(VersesRow row) {
  return _text(row.ivText);
}

String _originalTitle(VersesRow row) {
  return _title('Greek', row.kjvText, row.kjvChapter, row.kjvVerse);
}

List<TextSpan> _originalText(VersesRow? row) {
  String? text = row?.originalText;
  List<TextSpan> spans = [];
  if (text == null) {
    spans.add(const TextSpan(text: '---'));
    return spans;
  }

  int startIndex = 0;
  int endIndex = 0;
  int breakIndex = 0;

  do {
    startIndex = _indexOfGreekStart(text, breakIndex);
    endIndex = _indexOfGreekEnd(text, startIndex);

    if (startIndex == -1 || endIndex == -1) {
      spans.add(TextSpan(text: text.substring(breakIndex)));
      return spans;
    }

    if (startIndex > breakIndex) {
      spans.add(TextSpan(text: text.substring(breakIndex, startIndex)));
    }

    final spanText = text.substring(startIndex, endIndex);
    spans.add(
      TextSpan(
        text: spanText,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _openWordInBrowser(spanText);
          },
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
        ),
      ),
    );

    breakIndex = endIndex;
  } while (breakIndex < text.length);

  return spans;
}

int _indexOfGreekStart(String text, int fromIndex) {
  for (int i = fromIndex; i < text.length; i++) {
    if (_isGreek(text[i])) {
      return i;
    }
  }
  return -1;
}

int _indexOfGreekEnd(String text, int fromIndex) {
  if (fromIndex < 0) return -1;
  for (int i = fromIndex; i < text.length; i++) {
    if (!_isGreek(text[i])) {
      return i;
    }
  }
  return text.length;
}

_openWordInBrowser(String greekWord) async {
  final helper = DatabaseHelper.instance;
  final strongsNumber = await helper.getStrongsNumber(greekWord);
  if (strongsNumber == null) {
    return;
  }

  final url = Uri.parse('https://biblehub.com/greek/$strongsNumber.htm');
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

bool _isGreek(String char) {
  final c = char.codeUnitAt(0);
  return ((c >= _greekMin && c <= _greekMax) || (c >= _greekExtendedMin && c <= _greekExtendedMax));
}

String _kjvTitle(VersesRow row) {
  return _title('King James Version', row.kjvText, row.kjvChapter, row.kjvVerse);
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
    spans.add(TextSpan(
        text: verseText.substring(startIndex, endIndex),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        )));

    breakIndex = endIndex + boldEnd.length;
  } while (breakIndex < verseText.length);

  return spans;
}
