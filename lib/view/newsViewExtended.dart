import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class MyHomePage extends StatefulWidget {
  //news = name+id
  MyHomePage({Key? key, required this.news}) : super(key: key);
  final String news;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news),
      ),
      body: Text("data"),
    );
  }
}
