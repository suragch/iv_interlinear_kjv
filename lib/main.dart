import 'package:flutter/material.dart';

import 'package:iv_interlinear_kjv/compare_screen.dart';
import 'package:iv_interlinear_kjv/database_helper.dart';
import 'package:iv_interlinear_kjv/help_screen.dart';

import 'package:iv_interlinear_kjv/book.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      title: 'IV Interlinear KJV',
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IV Interlinear KJV'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _navigateToHelpScreen(context);
            },
          ),
        ],
      ),
      body: const HomepageBody(),
    );
  }

  void _navigateToHelpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpScreen()),
    );
  }
}

// widget class
class HomepageBody extends StatefulWidget {
  const HomepageBody({Key? key}) : super(key: key);

  @override
  State<HomepageBody> createState() => _HomepageBodyState();
}

enum Version {
  iv,
  interlinear,
  kjv,
}

class _HomepageBodyState extends State<HomepageBody> {
  String appVersionNumber = '';
  Version _character = Version.iv;
  int bookId = Book.firstNtBook;
  String bookName = '';
  int chapterNumber = 1;
  bool isInspiredVersion = true;

  @override
  void initState() {
    _getVersionNumber();
    super.initState();
  }

  void _getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersionNumber = packageInfo.version;
    });
  }

  // The State class must include this method, which builds the widget
  @override
  Widget build(BuildContext context) {
    bookName = Book.getBookName(bookId);
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _narrowMainLayout(context);
        } else {
          return _wideMainLayout(context);
        }
      },
    );
  }

  Widget _narrowMainLayout(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _optionControls(),
            _compareButton(),
          ],
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: _copyrightInfo(),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: _appVersionInfo(),
        ),
      ],
    );
  }

  Widget _wideMainLayout(BuildContext context) {
    return Stack(
      children: <Widget>[
        _optionControls(),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: _compareButton(),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: _copyrightInfo(),
        ),
        Align(
          alignment: Alignment.topRight,
          child: _appVersionInfo(),
        ),
      ],
    );
  }

  Widget _optionControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 32, bottom: 16),
          child: Row(
            children: <Widget>[
              ElevatedButton(
                child: Text(bookName),
                onPressed: () {
                  _onBookClick(context);
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                child: Text('$chapterNumber'),
                onPressed: () {
                  _onChapterClick(context);
                },
              ),
            ],
          ),
        ),
        RadioListTile<Version>(
          title: const Text('Inspired Version'),
          value: Version.iv,
          groupValue: _character,
          onChanged: (Version? value) {
            setState(() {
              _character = value ?? Version.iv;
              isInspiredVersion = true;
            });
          },
        ),
        RadioListTile<Version>(
          title: const Text('Greek'),
          value: Version.interlinear,
          groupValue: _character,
          onChanged: (Version? value) {
            setState(() {
              _character = value ?? Version.interlinear;
              isInspiredVersion = false;
            });
          },
        ),
        RadioListTile<Version>(
          title: const Text('King James Version'),
          value: Version.kjv,
          groupValue: _character,
          onChanged: (Version? value) {
            setState(() {
              _character = value ?? Version.kjv;
              isInspiredVersion = false;
            });
          },
        ),
      ],
    );
  }

  Widget _compareButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        child: const Text('Compare'),
        onPressed: () {
          _onCompareClick(context);
        },
      ),
    );
  }

  Widget _copyrightInfo() {
    return const SafeArea(
      minimum: EdgeInsets.all(8.0),
      child: Text(
        'The Holy Bible, Berean Interlinear Bible\n'
        'Copyright © 2016 by Bible Hub\n'
        'Used by permission. All Rights Reserved Worldwide.',
        style: TextStyle(fontSize: 8.0),
      ),
    );
  }

  Widget _appVersionInfo() {
    return SafeArea(
      minimum: const EdgeInsets.all(8.0),
      child: Text(
        appVersionNumber,
        style: const TextStyle(fontSize: 8.0),
      ),
    );
  }

  void _onBookClick(BuildContext context) {
    final books = Book.getBookListForTestament(Book.newTestament);
    List<SimpleDialogOption> bookOptions =
        List.generate(books.length, (int index) {
      return SimpleDialogOption(
        child: Text(books[index]),
        onPressed: () {
          setState(() {
            bookId = Book.getBookId(Book.newTestament, index);
            if (Book.getNumberOfChapters(bookId) < chapterNumber) {
              chapterNumber = 1;
            }
          });

          Navigator.of(context).pop();
        },
      );
    });

    SimpleDialog dialog = SimpleDialog(
      title: const Text('Choose a book'),
      children: bookOptions,
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  void _onChapterClick(BuildContext context) {
    int numberOfChapters = Book.getNumberOfChapters(bookId);

    Widget content = GridView.count(
        crossAxisCount: 6,
        children: List<Widget>.generate(numberOfChapters, (index) {
          return GridTile(
            child: Card(
              child: InkResponse(
                child: Center(
                  child: Text('${index + 1}'),
                ),
                onTap: () {
                  setState(() {
                    chapterNumber = index + 1;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        }));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Choose a chapter"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: content,
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onCompareClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CompareScreen(
                isInspiredVersion: isInspiredVersion,
                bookId: bookId,
                chapter: chapterNumber,
              )),
    );
  }
}
