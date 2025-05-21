import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/all.dart';
import 'package:flutter/services.dart' show rootBundle;

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  HelpScreenState createState() {
    return HelpScreenState();
  }
}

class HelpScreenState extends State<HelpScreen> {
  String _markdown = '';

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    final String data = await rootBundle.loadString('assets/intro.md');
    setState(() {
      _markdown = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IV Interlinear KJV')),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
        child: MarkdownWidget(data: _markdown),
      ),
    );
  }
}
