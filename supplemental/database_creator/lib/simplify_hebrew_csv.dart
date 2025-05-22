import 'dart:io';

void createHebrewInterlinear() {
  final file = File('../hebrew/bsb_tables.csv');
  final lines = file.readAsLinesSync();
  final text = StringBuffer();
  text.write('bookId\tchapter\tverse\ttext');

  int bookId = -1;
  int chapter = -1;
  int verse = -1;
  List<VerseWord> verseWords = [];

  const colLanguage = 4;
  const colHebrew = 5;
  const colReference = 12;
  const colEnglish = 18;
  const colPunctuation = 19;
  // int lineCount = 0;

  for (int i = 1; i < lines.length; i++) {
    var line = lines[i];
    final columns = line.split('\t');
    final language = columns[colLanguage];
    if (language == 'Greek') break;

    final hebrew = columns[colHebrew].trim();

    final reference = columns[colReference];
    if (reference.isNotEmpty) {
      (bookId, chapter, verse) = _parseReference(reference);
    }

    if (hebrew.isEmpty) {
      if (verseWords.isNotEmpty) {
        _writeVerseLine(text, verseWords, bookId, chapter, verse);
        verseWords = [];
        bookId = -1;
        chapter = -1;
        verse = -1;
      }
      continue;
    }

    final english = columns[colEnglish].trim();
    final punctuation = columns[colPunctuation].trim();
    verseWords.add(
      VerseWord(hebrew: hebrew, english: english, punctuation: punctuation),
    );
  }
  final outputFile = File('../hebrew/interlinear.csv');
  outputFile.createSync(recursive: true);
  outputFile.writeAsStringSync(text.toString());
}

void _writeVerseLine(
  StringBuffer text,
  List<VerseWord> verseWords,
  int bookId,
  int chapter,
  int verse,
) {
  text.write('\n$bookId\t$chapter\t$verse\t');
  for (var word in verseWords) {
    text.write('${word.hebrew} (${word.english})${word.punctuation}');
  }
}

(int bookId, int chapter, int verse) _parseReference(String reference) {
  // reference is in the form: "1 Corinthians 1:1"

  final refIndex = reference.lastIndexOf(' ');
  final bookName = reference.substring(0, refIndex);
  final chapterVerse = reference.substring(refIndex + 1).split(':');
  final chapter = int.parse(chapterVerse[0]);
  final verse = int.parse(chapterVerse[1]);

  // Get book ID from the full name
  final bookId = _fullNameToBookIdMap[bookName]!;

  return (bookId, chapter, verse);
}

const _fullNameToBookIdMap = {
  'Genesis': 1,
  'Exodus': 2,
  'Leviticus': 3,
  'Numbers': 4,
  'Deuteronomy': 5,
  'Joshua': 6,
  'Judges': 7,
  'Ruth': 8,
  '1 Samuel': 9,
  '2 Samuel': 10,
  '1 Kings': 11,
  '2 Kings': 12,
  '1 Chronicles': 13,
  '2 Chronicles': 14,
  'Ezra': 15,
  'Nehemiah': 16,
  'Esther': 17,
  'Job': 18,
  'Psalm': 19,
  'Psalms': 19,
  'Proverbs': 20,
  'Ecclesiastes': 21,
  'Song of Solomon': 22,
  'Isaiah': 23,
  'Jeremiah': 24,
  'Lamentations': 25,
  'Ezekiel': 26,
  'Daniel': 27,
  'Hosea': 28,
  'Joel': 29,
  'Amos': 30,
  'Obadiah': 31,
  'Jonah': 32,
  'Micah': 33,
  'Nahum': 34,
  'Habakkuk': 35,
  'Zephaniah': 36,
  'Haggai': 37,
  'Zechariah': 38,
  'Malachi': 39,
  'Matthew': 41,
  'Mark': 42,
  'Luke': 43,
  'John': 44,
  'Acts': 45,
  'Romans': 46,
  '1 Corinthians': 47,
  '2 Corinthians': 48,
  'Galatians': 49,
  'Ephesians': 50,
  'Philippians': 51,
  'Colossians': 52,
  '1 Thessalonians': 53,
  '2 Thessalonians': 54,
  '1 Timothy': 55,
  '2 Timothy': 56,
  'Titus': 57,
  'Philemon': 58,
  'Hebrews': 59,
  'James': 60,
  '1 Peter': 61,
  '2 Peter': 62,
  '1 John': 63,
  '2 John': 64,
  '3 John': 65,
  'Jude': 66,
  'Revelation': 67,
};

class VerseWord {
  VerseWord({
    required this.hebrew,
    required this.english,
    required this.punctuation,
  });
  final String hebrew;
  final String english;
  final String? punctuation;
}
