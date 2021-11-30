import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter_news/api.secret.dart';

import 'news.dart';

class NewsService {
  final String _baseUrl = "newsapi.org";
  final String _apiKey = kApiKey;

  Future<Request> get(Map<String, dynamic> search, String typeSearch) async {
    dynamic responseJson;
    Uri _baseUrl = Uri.https(this._baseUrl, typeSearch);
    search.addAll({"apiKey": _apiKey});
    var url = _baseUrl.replace(queryParameters: search as Map<String, dynamic>);
    dev.log("Querying ${url}");
    final response;
    try {
      response = await Dio().get(url.toString());
    } catch (e) {
      throw new Exception("no connection internet");
    }
    responseJson = returnResponse(response);
    // if (Random().nextInt(2) == 0 && search["page"] != "1")
    //   throw Exception("L'internet ? Connais pas ...");
    // if (search["page"] != "3") await Future.delayed(Duration(seconds: 4));
    return responseJson;
  }

  Request returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        Request responseJson = Request.fromJson(response.data);
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

  Future<String> getImageB64(String urlToImage) async {
    var response;
    try {
      response = await Dio()
          .get(urlToImage, options: Options(responseType: ResponseType.bytes));
    } catch (e) {
      throw new Exception("error download image");
    }
    var bytes = response.data;
    return base64Encode(bytes);
  }
}
