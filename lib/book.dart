class Book {
  static final String TESTAMENT_ID_KEY = "testament";
  static final String BOOK_ID_KEY = "bookId";
  static final String CHAPTER_NUMBER_KEY = "chapter";

  static final int OLD_TESTAMENT = 0;
  static final int NEW_TESTAMENT = 1;

  static final int SEARCH_OT = 100;
  static final int SEARCH_NT = 101;
  static final int SEARCH_ALL = 102;
  static final int SEARCH_CURRENT = 103;

  static final int GENESIS = 1;
  static final int OBADIAH = 31;
  static final int PHILEMON = 58;
  static final int IIJOHN = 64;
  static final int IIIJOHN = 65;
  static final int JUDE = 66;
  static final int REVELATION = 67;

  static final int NUMBER_OF_CHAPTERS_IN_REVELATION = 22;
  static final int NUMBER_OF_CHAPTERS_IN_BIBLE = 1189;
  static final int NUMBER_OF_CHAPTERS_IN_OT = 929;

  static final int FIRST_OT_BOOK = 1;
  static final int LAST_OT_BOOK = 39;
  static final int FIRST_NT_BOOK = 41;
  static final int LAST_NT_BOOK = 67;

  static final _OT_CHAPTERS_PER_BOOK = [
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
    4
  ];
  static final _NT_CHAPTERS_PER_BOOK = [
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
    22
  ];

  static final _OT_BOOK_NAMES = [
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
    "Malachi"
  ];

  static final _NT_BOOK_NAMES = [
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
    "Revelation"
  ];

  static String getBookName(int bookId) {
    if (isOtBookId(bookId)) {
      return _OT_BOOK_NAMES[bookId - FIRST_OT_BOOK];
    } else if (isNtBookId(bookId)) {
      return _NT_BOOK_NAMES[bookId - FIRST_NT_BOOK];
    }
    throw ArgumentError("not a valid BookId");
  }

  static int getNumberOfChapters(int bookId) {
    if (isOtBookId(bookId)) {
      return _OT_CHAPTERS_PER_BOOK[bookId - FIRST_OT_BOOK];
    } else if (isNtBookId(bookId)) {
      return _NT_CHAPTERS_PER_BOOK[bookId - FIRST_NT_BOOK];
    }
    throw ArgumentError("not a valid BookId");
  }

  static bool isOtBookId(int id) {
    return id >= FIRST_OT_BOOK && id <= LAST_OT_BOOK;
  }

  static bool isNtBookId(int id) {
    return id >= FIRST_NT_BOOK && id <= LAST_NT_BOOK;
  }

  static bool isSingleChapterBook(int bookId) {
    return bookId == OBADIAH ||
        bookId == PHILEMON ||
        bookId == IIJOHN ||
        bookId == IIIJOHN ||
        bookId == JUDE;
  }

  static List<String> getBookList() {
    return List.from(_OT_BOOK_NAMES)..addAll(_NT_BOOK_NAMES);
  }

  static List<String> getBookListForTestament(int testamentId) {
    if (testamentId == OLD_TESTAMENT) return _OT_BOOK_NAMES;
    return _NT_BOOK_NAMES;
  }

  static int getBookId(int testament, int index) {
    if (testament == OLD_TESTAMENT) {
      return index + FIRST_OT_BOOK;
    }
    return index + FIRST_NT_BOOK;
  }

  static Chapter getBookAndChapter(int chapterIndexInBible) {
    if (chapterIndexInBible < 0) return new Chapter(GENESIS, 1);

    int bookId;
    int sum;
    List<int> chaptersPerBook;

    if (chapterIndexInBible < NUMBER_OF_CHAPTERS_IN_OT) {
      bookId = FIRST_OT_BOOK;
      sum = 0;
      chaptersPerBook = _OT_CHAPTERS_PER_BOOK;
    } else {
      bookId = FIRST_NT_BOOK;
      sum = NUMBER_OF_CHAPTERS_IN_OT;
      chaptersPerBook = _NT_CHAPTERS_PER_BOOK;
    }

    for (int numChapters in chaptersPerBook) {
      if (chapterIndexInBible < sum + numChapters) {
        int chapter = chapterIndexInBible - sum + 1;
        return new Chapter(bookId, chapter);
      }
      sum += numChapters;
      bookId++;
    }

    return new Chapter(REVELATION, NUMBER_OF_CHAPTERS_IN_REVELATION);
  }

  static int getChapterIndexInBible(int bookId, int chapter) {
    int chapterIndex = chapter - 1;

    List<int> chaptersPerBook;
    int endBookIndex;

    if (bookId < FIRST_NT_BOOK) {
      endBookIndex = bookId - 1;
      chaptersPerBook = _OT_CHAPTERS_PER_BOOK;
    } else {
      endBookIndex = bookId - FIRST_NT_BOOK;
      chapterIndex += NUMBER_OF_CHAPTERS_IN_OT;
      chaptersPerBook = _NT_CHAPTERS_PER_BOOK;
    }

    for (int i = 0; i < endBookIndex; i++) {
      chapterIndex += chaptersPerBook[i];
    }

    return chapterIndex;
  }

  static int getNextBook(int bookId) {
    if (bookId < GENESIS) return GENESIS;
    if (bookId == LAST_OT_BOOK) return FIRST_NT_BOOK;
    if (bookId >= REVELATION) throw ArgumentError('Index out of bounds');
    return bookId + 1;
  }

  static int getPreviousBook(int bookId) {
    if (bookId > REVELATION) return REVELATION;
    if (bookId == FIRST_NT_BOOK) return LAST_OT_BOOK;
    if (bookId <= GENESIS) throw ArgumentError('Index out of bounds');
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
