import 'package:otaku_fix/classes/popular.dart';
import 'extensions/popular.dart';
import 'package:otaku_fix/constants/url.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Data {
  List<Popular> populars = [];

  Future<Map<String, dynamic>> init() async {
    Document doc = await getAppData();
    List popularTitles = doc.querySelectorAll('.owl-carousel > .item');
    this.populars = await fetchPopulars(popularTitles);
    return {
    "populars": this.populars,
    };
  }

  Future<Document> getAppData() async{
    http.Response response = await http.get(Uri.parse(baseUrl));
    Document doc = parse(response.body);

    return doc;
  }
}

