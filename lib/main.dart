import 'package:flutter/material.dart';
import 'package:flutter_news/model/newsService.dart';
import 'package:flutter_news/view%20model/newsRegistry.dart';
import 'package:flutter_news/view/newsViewList.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter News Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<NewsRegistry>(
            create: (context) => NewsRegistry(),
          )
        ],
        child: MyHomePage(title: 'News'),
      ),
    );
  }
}
