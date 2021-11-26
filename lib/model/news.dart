class Request {
  String status;
  int totalResults;
  Article articles;

  Request.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        totalResults = json['totalResults'],
        articles = Article.fromJson(json['articles']);
}

class Article {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  Article.fromJson(Map<String, dynamic> json)
      : source = Source.fromJson(json['source']),
        author = json['author'],
        title = json['title'],
        description = json['description'],
        url = json['url'],
        urlToImage = json['urlToImage'],
        publishedAt = json['publishedAt'],
        content = json['content'];
}

class Source {
  String id;
  String name;

  Source.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
