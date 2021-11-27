import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'news.dart';

class NewsService {
  final Uri _baseUrl = Uri.https("newsapi.org", "/v2/everything");
  final String _apiKey = "fbff871225eb4408ba6e2d2e7a732b12";

  Future<Request> get(Map<String, dynamic> search, Set<String> urlsFav) async {
    dynamic responseJson;
    search.addAll({"apiKey": _apiKey, "q": "a"});
    var url = _baseUrl.replace(queryParameters: search);
    final response;
    try {
      response = await Dio().get(url.toString());
    } catch (e) {
      throw new Exception("no connection internet");
    }
    responseJson = returnResponse(response, urlsFav);
    //await Future.delayed(Duration(seconds: 10));
    return responseJson;
  }

  Request returnResponse(Response response, Set<String> urlsFav) {
    switch (response.statusCode) {
      case 200:
        Request responseJson = Request.fromJson(response.data, urlsFav);
        return responseJson;
      case 400:
        throw new Exception(
            "bad request exception : " + response.data.toString());
      case 401:
      case 403:
        throw new Exception(
            "unauthorised exception : " + response.data.toString());
      case 500:
      default:
        throw new Exception(
            "fetch data exception : " + response.statusCode.toString());
    }
  }
}
