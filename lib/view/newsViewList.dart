import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_news/model/newsService.dart';
import 'package:flutter_news/view%20model/newsRegistry.dart';
import 'package:provider/src/provider.dart';
import 'package:share_plus/share_plus.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final registry = context.watch<NewsRegistry>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder(
        future: registry.isLoading,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return ListView.builder(
              itemCount: registry.nbArticles,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Stack(children: [
                              Container(
                                color: Colors.amber,
                                child: Center(child: Text("Image")),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.star_border_outlined),
                                  onPressed: null,
                                ),
                              ),
                            ]),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: ListTile(
                            minVerticalPadding: 10,
                            isThreeLine: true,
                            title:
                                Text(registry.getArticleFromList(index)!.title),
                            subtitle: Text(
                                registry.getArticleFromList(index)!.author),
                            trailing: IconButton(
                                onPressed: () {
                                  Share.share(
                                      registry.getArticleFromList(index)!.url);
                                },
                                icon: Icon(Icons.share)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          else if (snapshot.hasError)
            return Text((snapshot.error as Exception).toString());
          return CircularProgressIndicator();
        },
      )),
    );
  }
}
