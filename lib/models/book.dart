class Book {
  static const String testamentIdKey = "testament";
  static const String bookIdKey = "bookId";
  static const String chapterNumberKey = "chapter";

  static const int oldTestament = 0;
  static const int newTestament = 1;

  static const int searchOT = 100;
  static const int searchNT = 101;
  static const int searchAll = 102;
  static const int searchCurrent = 103;

  static const int genesis = 1;
  static const int obadiah = 31;
  static const int philemon = 58;
  static const int iiJohn = 64;
  static const int iiiJohn = 65;
  static const int jude = 66;
  static const int revelation = 67;

  static const int numberOfChaptersInRevelation = 22;
  static const int numberOfChaptersInBible = 1189;
  static const int numberOfChaptersInOT = 929;

  static const int firstOtBook = 1;
  static const int lastOtBook = 39;
  static const int firstNtBook = 41;
  static const int lastNtBook = 67;

  static const _otChaptersPerBook = [
    50,
    40,
    27,
    36,
    34,
    24,
    21,
    4,
    31,
    24,
    22,
    25,
    29,
    36,
    10,
    13,
    10,
    42,
    150,
    31,
    12,
    8,
    66,
    52,
    5,
    48,
    12,
    14,
    3,
    9,
    1,
    4,
    7,
    3,
    3,
    3,
    2,
    14,
    4,
  ];
  static const _ntChaptersPerBook = [
    28,
    16,
    24,
    21,
    28,
    16,
    16,
    13,
    6,
    6,
    4,
    4,
    5,
    3,
    6,
    4,
    3,
    1,
    13,
    5,
    5,
    3,
    5,
    1,
    1,
    1,
    22,
  ];

  static const otBookNames = [
    "Genesis",
    "Exodus",
    "Leviticus",
    "Numbers",
    "Deuteronomy",
    "Joshua",
    "Judges",
    "Ruth",
    "1 Samuel",
    "2 Samuel",
    "1 Kings",
    "2 Kings",
    "1 Chronicles",
    "2 Chronicles",
    "Ezra",
    "Nehemiah",
    "Esther",
    "Job",
    "Psalm",
    "Proverbs",
    "Ecclesiastes",
    "Song of Solomon",
    "Isaiah",
    "Jeremiah",
    "Lamentations",
    "Ezekiel",
    "Daniel",
    "Hosea",
    "Joel",
    "Amos",
    "Obadiah",
    "Jonah",
    "Micah",
    "Nahum",
    "Habakkuk",
    "Zephaniah",
    "Haggai",
    "Zechariah",
    "Malachi",
  ];

  static const ntBookNames = [
    "Matthew",
    "Mark",
    "Luke",
    "John",
    "Acts",
    "Romans",
    "1 Corinthians",
    "2 Corinthians",
    "Galatians",
    "Ephesians",
    "Philippians",
    "Colossians",
    "1 Thessalonians",
    "2 Thessalonians",
    "1 Timothy",
    "2 Timothy",
    "Titus",
    "Philemon",
    "Hebrews",
    "James",
    "1 Peter",
    "2 Peter",
    "1 John",
    "2 John",
    "3 John",
    "Jude",
    "Revelation",
  ];

  static String getBookName(int bookId) {
    if (isOtBookId(bookId)) {
      return otBookNames[bookId - firstOtBook];
    } else if (isNtBookId(bookId)) {
      return ntBookNames[bookId - firstNtBook];
    }
    throw ArgumentError("not a valid BookId");
  }

  static int getNumberOfChapters(int bookId) {
    if (isOtBookId(bookId)) {
      return _otChaptersPerBook[bookId - firstOtBook];
    } else if (isNtBookId(bookId)) {
      return _ntChaptersPerBook[bookId - firstNtBook];
    }
    throw ArgumentError("not a valid BookId");
  }

  static bool isOtBookId(int id) {
    return id >= firstOtBook && id <= lastOtBook;
  }

  static bool isNtBookId(int id) {
    return id >= firstNtBook && id <= lastNtBook;
  }

  static bool isSingleChapterBook(int bookId) {
    return bookId == obadiah ||
        bookId == philemon ||
        bookId == iiJohn ||
        bookId == iiiJohn ||
        bookId == jude;
  }

  static List<String> getBookList() {
    return List.from(otBookNames)..addAll(ntBookNames);
  }

  // static List<String> getBookListForTestament(int testamentId) {
  //   if (testamentId == oldTestament) return _otBookNames;
  //   return _ntBookNames;
  // }

  static int getBookId(int testament, int index) {
    if (testament == oldTestament) {
      return index + firstOtBook;
    }
    return index + firstNtBook;
  }

  static Chapter getBookAndChapter(int chapterIndexInBible) {
    if (chapterIndexInBible < 0) return Chapter(genesis, 1);

    int bookId;
    int sum;
    List<int> chaptersPerBook;

    if (chapterIndexInBible < numberOfChaptersInOT) {
      bookId = firstOtBook;
      sum = 0;
      chaptersPerBook = _otChaptersPerBook;
    } else {
      bookId = firstNtBook;
      sum = numberOfChaptersInOT;
      chaptersPerBook = _ntChaptersPerBook;
    }

    for (int numChapters in chaptersPerBook) {
      if (chapterIndexInBible < sum + numChapters) {
        int chapter = chapterIndexInBible - sum + 1;
        return Chapter(bookId, chapter);
      }
      sum += numChapters;
      bookId++;
    }

    return Chapter(revelation, numberOfChaptersInRevelation);
  }

  static int getChapterIndexInBible(int bookId, int chapter) {
    int chapterIndex = chapter - 1;

    List<int> chaptersPerBook;
    int endBookIndex;

    if (bookId < firstNtBook) {
      endBookIndex = bookId - 1;
      chaptersPerBook = _otChaptersPerBook;
    } else {
      endBookIndex = bookId - firstNtBook;
      chapterIndex += numberOfChaptersInOT;
      chaptersPerBook = _ntChaptersPerBook;
    }

    for (int i = 0; i < endBookIndex; i++) {
      chapterIndex += chaptersPerBook[i];
    }

    return chapterIndex;
  }

  static int getNextBook(int bookId) {
    if (bookId < genesis) return genesis;
    if (bookId == lastOtBook) return firstNtBook;
    if (bookId >= revelation) throw ArgumentError('Index out of bounds');
    return bookId + 1;
  }

  static int getPreviousBook(int bookId) {
    if (bookId > revelation) return revelation;
    if (bookId == firstNtBook) return lastOtBook;
    if (bookId <= genesis) throw ArgumentError('Index out of bounds');
    return bookId - 1;
  }

  static bool chapterIsValid(int bookId, int chapter) {
    return chapter > 0 && chapter <= getNumberOfChapters(bookId);
  }

  static String getReference(int bookId, int chapter, int verse) {
    return '${getBookName(bookId)} $chapter:$verse';
  }
}

class Chapter {
  int book;
  int chapter;

  Chapter(this.book, this.chapter);
}
