import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:otaku_fix/classes/chapter.dart';

Future<Document> getManga(String url) async {
  http.Response response = await http.get(url);
  Document document = parse(response.body);
  return document;
}

class Manga {
  String name;
  String url;
  String img;
  String alternative;
  String status;
  String updated;
  String views;
  String description;
  List<Chapter> chapters = [];
  bool old;

  Manga(Document document) {
    init(document);
  }
  Future init(Document document) async {
    try {
      var element = document.querySelector('.panel-story-info');

      var table = element.querySelectorAll('tr > .table-value');

      var some = element.querySelectorAll('.story-info-right-extent > p');
      var ch = document.querySelectorAll('.row-content-chapter > .a-h > a');

      ch.forEach((element) {
        this
            .chapters
            .add(Chapter(name: element.text, url: element.attributes['href']));
      });

      this.img = element.querySelector('img.img-loading').attributes['src'];
      this.name = element.querySelector('img.img-loading').attributes['title'];
      this.alternative = table[0].text;
      this.status = table[2].text;
      this.updated = some[0].querySelector('.stre-value').text;
      this.views = some[1].querySelector('.stre-value').text;
      this.description =
          document.querySelector(".panel-story-info-description").text;
      this.old = true;
    } catch (e) {
      this.old = false;
      List<Element> elements =
      document.querySelectorAll(".manga-info-text > li");
      this.name = elements[0].querySelector('h1').text;
      try {
        this.alternative = elements[0].querySelector('h2').text;
      } catch (e) {
        this.alternative = "None";
      }

      this.status = elements[2].text;
      this.updated = elements[3].text;
      this.views = elements[5].text;
      this.img = document.querySelector(".manga-info-pic > img").attributes['src'];

      this.description = document.querySelector("#noidungm").text;
      var ch = document.querySelectorAll('.chapter-list > .row > span > a');

      ch.forEach((element) {
        this
            .chapters
            .add(Chapter(name: element.text, url: element.attributes['href']));
      });
    }
  }
}