import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news/model/news.dart';
import 'package:flutter_news/view%20model/newsRegistry.dart';
import 'package:flutter_news/view/newsViewExtended.dart';
import 'package:provider/src/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ArticlesWidget extends StatelessWidget {
  const ArticlesWidget({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article? article;

  @override
  Widget build(BuildContext context) {
    final registry = context.watch<NewsRegistry>();
    if (article == null) return _buildLoading();
    final image = registry.getArticleImage(
      article!,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return _buildLoadingImage();
      },
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new ExtendedView(news: article!)),
          )
        },
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: (image != null)
                  ? Stack(
                      children: [
                        Hero(
                          tag: article!.urlToImage!,
                          child: image,
                        ),
                        Positioned(
                          right: -10,
                          top: -10,
                          child: IconButton(
                            onPressed: () {
                              registry.fav(article!);
                            },
                            icon: Icon(
                              registry.isFav(article!)
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              color: Colors.yellow,
                            ),
                          ),
                        )
                      ],
                    )
                  : IconButton(
                      onPressed: () {
                        registry.fav(article!);
                      },
                      icon: Icon(
                        registry.isFav(article!)
                            ? Icons.star
                            : Icons.star_border_outlined,
                        color: Colors.yellow,
                      ),
                    ),
            ),
            Expanded(
              flex: 18,
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 16),
                horizontalTitleGap: 0,
                minVerticalPadding: 10,
                title: Hero(
                  flightShuttleBuilder: (flightContext, animation,
                          flightDirection, fromHeroContext, toHeroContext) =>
                      AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return DefaultTextStyle(
                        style: TextStyleTween(
                          begin:
                              ((fromHeroContext.widget as Hero).child as Text)
                                  .style,
                          end: ((toHeroContext.widget as Hero).child as Text)
                              .style,
                        ).lerp(
                          (flightDirection.index - animation.value)
                              .abs(), //swap annimation for other annimation
                        ),
                        child: Text(
                          article!.title,
                        ),
                      );
                    },
                  ),
                  tag: article!.title,
                  child: Text(
                    article!.title,
                    style: DefaultTextStyle.of(context).style,
                  ),
                ),
                subtitle: Text(article!.author ?? ""),
                trailing: IconButton(
                  onPressed: () {
                    Share.share(article!.url);
                  },
                  icon: Icon(
                    Icons.share,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SkeletonLoader _buildLoading() => SkeletonLoader(
      baseColor: Colors.black12,
      builder: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 16),
                horizontalTitleGap: 0,
                minVerticalPadding: 10,
                isThreeLine: true,
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  height: 15,
                ),
                subtitle: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  height: 10,
                ),
                trailing: IconButton(onPressed: () {}, icon: Icon(Icons.share)),
              ),
            ),
          ],
        ),
      ));

  SkeletonLoader _buildLoadingImage() => SkeletonLoader(
        baseColor: Colors.black12,
        builder: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            height: 10,
            width: 10,
          ),
        ),
      );
}
