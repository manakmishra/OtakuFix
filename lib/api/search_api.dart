import 'package:http/http.dart' as http;
import 'dart:convert';

List<SearchResults> resultsFromJson(String jsonFile) {
  return List<SearchResults>.from(
    json.decode(jsonFile).map((x) => SearchResults.fromJson(x)));
}

String resultsToJson(List<SearchResults> results) {
  return json.encode(List<dynamic>.from(results.map((x) => x.toJson())));
}

class SearchResults {
  String id;
  String idEncode;
  String name;
  String nameUnsigned;
  String lastChapter;
  String image;
  String author;

  SearchResults({
    this.id,
    this.idEncode,
    this.name,
    this.nameUnsigned,
    this.lastChapter,
    this.image,
    this.author,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      id: json["id"],
      idEncode: "https://manganelo.com/manga/${json["id_encode"]}",
      name: json["name"],
      nameUnsigned: json["nameunsigned"],
      lastChapter: json["lastchapter"],
      image: json["image"],
      author: json["author"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_encode": idEncode,
    "name": name,
    "nameunsigned": nameUnsigned,
    "lastchapter": lastChapter,
    "image": image,
    "author": author,
  };
}

Future<List<SearchResults>> search(String keyword) async{
  Map<String, String> body = {"searchword": keyword};

  http.Response response = await http.post(Uri.parse('https://manganelo.com/getstorysearchjson'), body: body);

  final results = resultsFromJson(utf8.decode(response.bodyBytes));
  return results;
}
