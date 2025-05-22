import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iv_interlinear_kjv/services/database_helper.dart';
import 'package:iv_interlinear_kjv/services/service_locator.dart';
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
                  children: _ivText(
                    verses[index],
                    Theme.of(context).textTheme.bodyMedium!.color!,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(_originalTitle(verses[index], isOT)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 32.0, right: 10.0),
              child: RichText(
                textDirection: isOT ? TextDirection.rtl : TextDirection.ltr,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: _originalText(
                    verses[index],
                    isOT,
                    Theme.of(context).colorScheme.primary,
                  ),
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
                  children: _kjvText(
                    verses[index],
                    Theme.of(context).textTheme.bodyMedium!.color!,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String fontFamilyForTestament(bool isOT) {
  return (isOT) ? 'Ezra' : 'Galatia';
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
            _original(context, isOT),
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
                children: _ivText(
                  verses[index],
                  Theme.of(context).textTheme.bodyMedium!.color!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _original(BuildContext context, bool isOT) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(_originalTitle(verses[index], isOT)),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: RichText(
              textDirection: isOT ? TextDirection.rtl : TextDirection.ltr,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: _originalText(
                  verses[index],
                  isOT,
                  Theme.of(context).colorScheme.primary,
                ),
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
                children: _kjvText(
                  verses[index],
                  Theme.of(context).textTheme.bodyMedium!.color!,
                ),
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

List<TextSpan> _ivText(VersesRow row, Color underlineColor) {
  return _text(row.ivText, underlineColor);
}

String _originalTitle(VersesRow row, bool isOT) {
  final version = isOT ? 'Hebrew' : 'Greek';
  return _title(version, row.kjvText, row.kjvChapter, row.kjvVerse);
}

List<TextSpan> _originalText(VersesRow? row, bool isOT, Color highlightColor) {
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
        style: TextStyle(
          fontFamily: fontFamilyForTestament(isOT),
          color: highlightColor,
          decoration: TextDecoration.underline,
          decorationColor: highlightColor,
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

void _openWordInBrowser(bool isOT, String word) async {
  int? strongsNumber;
  if (isOT) {
    final helper = getIt<OtDatabaseHelper>();
    strongsNumber = await helper.getStrongsNumber(word);
  } else {
    final helper = getIt<NtDatabaseHelper>();
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

String _kjvTitle(VersesRow row) {
  return _title(
    'King James Version',
    row.kjvText,
    row.kjvChapter,
    row.kjvVerse,
  );
}

List<TextSpan> _kjvText(VersesRow row, Color underlineColor) {
  return _text(row.kjvText, underlineColor);
}

List<TextSpan> _text(String? verseText, Color underlineColor) {
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
        style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: underlineColor,
        ),
      ),
    );

    breakIndex = endIndex + boldEnd.length;
  } while (breakIndex < verseText.length);

  return spans;
}
