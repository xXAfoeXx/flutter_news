import 'package:flutter/material.dart';
import 'package:flutter_news/view%20model/newsRegistry.dart';
import 'package:flutter_news/view/newsArticlesTile.dart';
import 'package:flutter_news/view/newsViewListFav.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class NewsList extends StatefulWidget {
  NewsList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  TextEditingController search = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registry = context.watch<NewsRegistry>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsFavList(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: search,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      registry.searchArticle(search.text);
                    },
                    child: Text("submit")),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: !registry.isLoadingFirstBatch
                ? ListView.builder(
                    itemCount: registry.nbArticles,
                    itemBuilder: (BuildContext context, int index) {
                      return ArticlesWidget(
                        article: registry.getArticleFromList(index),
                      );
                    },
                  )
                : registry.error != null
                    ? Text(registry.error.toString())
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
          ),
        ],
      ),
    );
  }
}
