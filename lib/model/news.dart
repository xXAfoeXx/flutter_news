class Request {
  String status;
  int totalResults;
  List<Article> articles;

  Request.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        totalResults = json['totalResults'],
        articles = List<Article>.from(json['articles'].map((x) {
          return Article.fromJson(x);
        }));
}

class Article {
  Source source;
  String? author;
  String title;
  String? description;
  String url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Article.fromJson(Map<String, dynamic> json)
      : source = Source.fromJson(json['source']),
        author = json['author'],
        title = json['title'],
        description = json['description'],
        url = json['url'],
        urlToImage = json['urlToImage'] == "" ? null : json['urlToImage'],
        publishedAt = json['publishedAt'],
        content = json['content'];

  Article.fromFavJson(Map<String, dynamic> json)
      : source = Source.fromJson(json['source']),
        author = json['author'],
        title = json['title'],
        description = json['description'],
        url = json['url'],
        urlToImage = json['urlToImage'],
        publishedAt = json['publishedAt'],
        content = json['content'];

  Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": content,
      };
}

class Source {
  String? id;
  String? name;

  Source.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
