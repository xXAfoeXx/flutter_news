import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_news/model/news.dart';
import 'package:flutter_news/model/newsService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsRegistry extends ChangeNotifier {
  List<Article> articleRegistry = [];
  int nbArticles = 0;
  NewsService service = new NewsService();

  late SharedPreferences prefs;
  late Future<bool> isLoading;
  Exception? error;

  NewsRegistry() {
    isLoading = initLocalFav();
  }

  Future<bool> initLocalFav() async {
    //local
    this.prefs = await SharedPreferences.getInstance();
    //online
    var response;
    // try {
    response = await service.get({}, prefs.getKeys());
    // } catch (e) {
    //   //this.error = e as Exception;
    //   log(e.toString());
    //   throw e;
    // }
    this.nbArticles = response.totalResults;
    this.articleRegistry = response.articles;
    notifyListeners();
    return true;
  }

  Set<String> getUrlFav() {
    return prefs.getKeys();
  }

  Article? getFav(String url) {
    var temp = prefs.getString(url);
    if (temp == null)
      return null;
    else {
      return Article.fromJson(json.decode(temp), prefs.getKeys().contains(url));
    }
  }

  bool isFav(String url) {
    return this.prefs.containsKey(url);
  }

  setFav(url) {
    var tempArticle =
        articleRegistry.firstWhere((element) => element.url == url);
    this.prefs.setString(url, json.encode(tempArticle));
    notifyListeners();
  }

  unSetFav(url) {
    this.prefs.remove(url);
    notifyListeners();
  }

  getArticle() async {
    var response = await service.get({}, prefs.getKeys());
    this.nbArticles = response.totalResults;
    this.articleRegistry = response.articles;
    notifyListeners();
  }

  searchArticle(String searchWord) async {
    searchWord = searchWord.replaceAll(" ", " OR ");
    var response = await service.get({"q": searchWord}, prefs.getKeys());
    this.nbArticles = response.totalResults;
    this.articleRegistry = response.articles;
    notifyListeners();
  }

  Article? getArticleFromList(int i) {
    if (nbArticles < i || i < 0) return null;
    return articleRegistry[i];
  }
}
