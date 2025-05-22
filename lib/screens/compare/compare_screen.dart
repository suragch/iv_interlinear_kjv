import 'package:flutter/material.dart';
import 'package:iv_interlinear_kjv/models/book.dart';
import 'package:iv_interlinear_kjv/services/database_helper.dart';
import 'package:iv_interlinear_kjv/screens/compare/verse_list_tile.dart';

class CompareScreen extends StatefulWidget {
  // final bool isInspiredVersion;
  final int bookId;
  final int chapter;

  const CompareScreen({
    super.key,
    // required this.isInspiredVersion,
    required this.bookId,
    required this.chapter,
  });

  @override
  CompareScreenState createState() {
    return CompareScreenState();
  }
}

class CompareScreenState extends State<CompareScreen> {
  List<VersesRow> verses = [];

  @override
  void initState() {
    _loadVersesFromDatabase().then((results) {
      setState(() {
        verses = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Book.getBookName(widget.bookId))),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return ListView.builder(
            itemCount: verses.length,
            itemBuilder: (context, index) {
              if (orientation == Orientation.portrait) {
                return NarrowVerseListTile(verses: verses, index: index);
              } else {
                return WideVerseListTile(verses: verses, index: index);
              }
            },
          );
        },
      ),
    );
  }

  Future<List<VersesRow>> _loadVersesFromDatabase() async {
    final helper = NtDatabaseHelper.instance;
    return await helper.getChapter(
      true, // TODO: return all verses
      widget.bookId,
      widget.chapter,
    );
  }
}
