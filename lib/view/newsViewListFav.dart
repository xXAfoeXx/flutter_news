import 'package:flutter/material.dart';
import 'package:flutter_news/view%20model/newsRegistry.dart';
import 'package:flutter_news/view/newsArticlesTile.dart';
import 'package:provider/src/provider.dart';

class NewsFavList extends StatefulWidget {
  NewsFavList({Key? key}) : super(key: key);
  @override
  _NewsFavListState createState() => _NewsFavListState();
}

class _NewsFavListState extends State<NewsFavList> {
  @override
  Widget build(BuildContext context) {
    final registry = context.watch<NewsRegistry>();
    Set<String> favUrlList = registry.getUrlFav();
    return Scaffold(
      appBar: AppBar(
        title: Text("Fav"),
      ),
      body: ListView.builder(
        itemCount: favUrlList.length,
        itemBuilder: (BuildContext context, int index) {
          return ArticlesWidget(
            article: registry.getFav(favUrlList.elementAt(index)),
          );
        },
      ),
    );
  }
}
