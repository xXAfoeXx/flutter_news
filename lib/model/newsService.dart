import 'package:dio/dio.dart';
import 'dart:convert';

class NewsService {
  final String _baseUrl = "";

  Future<dynamic> get(String url) async {
    dynamic responseJson;
    try {
      final response = await Dio().get(_baseUrl + 'http://www.google.com');
      responseJson = returnResponse(response);
    } catch (error) {
      //il faut tenir compte des autres erreur leve dans returnResponse
      throw new Exception("No Internet Connection");
    }
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.data);
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
