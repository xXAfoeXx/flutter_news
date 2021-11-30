import 'package:flutter/material.dart';
import 'package:flutter_news/model/news.dart';
import 'package:flutter_news/view%20model/newsRegistry.dart';
import 'package:provider/src/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ExtendedView extends StatefulWidget {
  ExtendedView({Key? key, required this.news}) : super(key: key);
  final Article news;

  @override
  _ExtendedViewState createState() => _ExtendedViewState();
}

class _ExtendedViewState extends State<ExtendedView> {
  @override
  Widget build(BuildContext context) {
    final registry = context.watch<NewsRegistry>();
    final image = registry.getArticleImage(widget.news);
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          Share.share(widget.news.url);
        },
        icon: Icon(Icons.share),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      appBar: AppBar(),
      body: Column(
        children: [
          Hero(
            tag: widget.news.title,
            child: Text(
              widget.news.title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.timelapse,
                size: 10,
              ),
              if (widget.news.publishedAt != null)
                Text(
                  widget.news.publishedAt!,
                  style: TextStyle(color: Colors.black54, fontSize: 10),
                ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          if (image != null)
            InkWell(
              onTap: () => _launchURL(widget.news.url),
              child: Stack(
                children: [
                  Hero(
                    child: image,
                    tag: widget.news.urlToImage!,
                  ),
                  Positioned(
                    right: -10,
                    top: -10,
                    child: IconButton(
                      onPressed: () {
                        registry.fav(widget.news);
                      },
                      icon: Icon(
                        registry.isFav(widget.news)
                            ? Icons.star
                            : Icons.star_border_outlined,
                        color: Colors.yellow,
                      ),
                    ),
                  )
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.news.source.name != null)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      child: Text(
                        "source : " + widget.news.source.name!,
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      onTap: () => _launchURL(widget.news.url),
                    ),
                  ),
                ),
              if (widget.news.author != null)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "author : " + widget.news.author!,
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (widget.news.content != null) Text(widget.news.content!),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
