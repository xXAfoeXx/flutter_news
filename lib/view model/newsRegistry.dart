import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/model/news.dart';
import 'package:flutter_news/model/newsService.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void DataCallback(int page, Request r);
typedef void ErrorCallback(int page, Exception r);

class PaginatedQuery {
  final int numArticlePerPage;
  final NewsService service;
  final DataCallback onPageLoaded;
  final ErrorCallback onError;

  Map<String, String> query = {};
  String endpoint = "";

  Set<int> pageLoad = {};
  int generation = 0;

  PaginatedQuery({
    required this.service,
    required this.onPageLoaded,
    required this.onError,
    this.numArticlePerPage = 20,
  });

  int pageToFirstId(int page) {
    return (page - 1) * numArticlePerPage;
  }

  int idToPage(int id) {
    return (id / 20).floor() + 1;
  }

  setQuery({
    required String endpoint,
    required Map<String, String> query,
  }) {
    log("Changing query ...");

    generation++;
    pageLoad.clear();
    // TODO: Need to stop all pending query ...

    this.query = query;
    this.endpoint = endpoint;
  }

  loadPage(int page) async {
    int startGeneration = generation;
    if (pageLoad.contains(page)) return;
    pageLoad.add(page);
    log("Query page ${page}");

    var res;
    try {
      res = await service.get(
          {}
            ..addAll(query)
            ..addAll({
              "page": page.toString(),
              "pageSize": numArticlePerPage.toString(),
            }),
          endpoint);
    } on Exception catch (e) {
      log("Page ${page} failed to load : ${e}");
      onError(page, e);
      // We can remove the page from loaded so it will automatically retry the request
      // But this will spam request, we would need to throttle the number of query
      // pageLoad.remove(page);
      return;
    }

    if (startGeneration != generation) {
      // Query has changed since begining of the request, discard result
      log("Page ${page} was too long to load, search changed ...");
      return;
    }

    log("Page ${page} loaded");
    onPageLoaded(page, res);
  }
}

class NewsRegistry extends ChangeNotifier {
  static const String kSearchLastCountry = "/v2/top-headlines";
  static const String kSearchEverything = "/v2/everything";

  List<Article?> articleRegistry = [];
  int nbArticles = 0;

  late PaginatedQuery service;

  late SharedPreferences prefs;
  bool isLoadingFirstBatch = false;
  Exception? error;

  NewsRegistry() {
    service = PaginatedQuery(
      onPageLoaded: this.handleResult,
      onError: this.onError,
      service: NewsService(),
    );

    initLocalFav();
  }

  initLocalFav() async {
    //local
    this.prefs = await SharedPreferences.getInstance();
    //online
    searchArticle("");
  }

  Set<String> getUrlFav() {
    return prefs
        .getKeys()
        .where((url) => !url.startsWith(kImagePrefix))
        .toSet();
  }

  Article? getFav(String url) {
    var temp = prefs.getString(url);
    if (temp == null)
      return null;
    else {
      return Article.fromFavJson(json.decode(temp));
    }
  }

  bool isFav(Article a) {
    return this.prefs.containsKey(a.url);
  }

  fav(Article article) {
    if (isFav(article))
      unSetFav(article);
    else
      setFav(article);
  }

  setFav(Article article) async {
    // No await here, we want to start the downloading of the image without waiting for it
    if (article.urlToImage != null) saveFavImage(article);

    log("Saving article ${article.url}");
    this.prefs.setString(article.url, json.encode(article.toJson()));
    notifyListeners();
  }

  static const String kImagePrefix = "image_";
  saveFavImage(Article a) async {
    if (a.urlToImage == null || a.urlToImage == "") return;

    String? imageB64 = this.prefs.getString(kImagePrefix + a.urlToImage!);
    if (imageB64 != null) {
      return;
    }
    this.prefs.setString(kImagePrefix + a.urlToImage!, "");
    imageB64 = await service.service.getImageB64(a.urlToImage!);
    log("save image");
    if (!this.prefs.containsKey(kImagePrefix + a.urlToImage!)) {
      log("Download over, but already unfaved ...");
      return;
    }
    this.prefs.setString(kImagePrefix + a.urlToImage!, imageB64);
  }

  Map<String, Image> cacheImage = {};

  Image? getArticleImage(Article a, {ImageLoadingBuilder? loadingBuilder}) {
    if (a.urlToImage == null || a.urlToImage == "") return null;

    if (cacheImage.containsKey(a.urlToImage)) {
      return cacheImage[a.urlToImage];
    }
    String? imageB64 = this.prefs.getString(kImagePrefix + a.urlToImage!);
    log("Image downloaded from ${imageB64 != null ? "Memory " : "Network"}: ${a.urlToImage}");
    var image = (imageB64 != null && imageB64 != "")
        ? Image.memory(base64Decode(imageB64))
        : Image.network(
            a.urlToImage!,
            errorBuilder: null,
            loadingBuilder: loadingBuilder,
          );
    cacheImage[a.urlToImage!] = image;
    return image;
  }

  unSetFav(Article a) {
    this.prefs.remove(a.url);
    if (a.urlToImage != null) this.prefs.remove(kImagePrefix + a.urlToImage!);
    notifyListeners();
  }

  searchArticle(String searchWord) {
    if (searchWord.isEmpty) {
      service.setQuery(endpoint: kSearchLastCountry, query: {"country": "us"});
    } else {
      service.setQuery(endpoint: kSearchLastCountry, query: {"q": searchWord});
    }

    error = null;
    isLoadingFirstBatch = true;
    service.loadPage(1);
    notifyListeners();
  }

  // addImageToArticle(int index) async {
  //   var article = articleRegistry[index]!;
  //   if (article.urlToImage != null && article.image == null) {
  //     articleRegistry[index]!.image =
  //         await service.service.getImageB64(article.urlToImage!);
  //   }
  // }

  Article? getArticleFromList(int i) {
    Article? a = null;
    if (i >= 0 && i < articleRegistry.length) {
      // addImageToArticle(i);
      a = articleRegistry[i];
    }
    if (a == null) {
      // Ask to load this page
      service.loadPage(service.idToPage(i));
    }
    return a;
  }

  loadPage(int page) async {
    await service.loadPage(page);
  }

  handleResult(int page, Request response) {
    // If first page, clear the list, and initialize it at full size
    if (page == 1) {
      this.articleRegistry = List.empty(growable: true);
      this.nbArticles = response.totalResults;
    }

    assert(this.nbArticles == response.totalResults);

    int firstId = service.pageToFirstId(page);
    while (this.articleRegistry.length < firstId)
      this.articleRegistry.add(null);

    this.articleRegistry.insertAll(firstId, response.articles);

    isLoadingFirstBatch = false;
    notifyListeners();
  }

  onError(int page, Exception e) {
    error = e;
    isLoadingFirstBatch = false;
    notifyListeners();
  }
}
