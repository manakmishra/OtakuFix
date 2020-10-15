import 'package:html/dom.dart';
import 'package:otaku_fix/classes/popular.dart';

Future<List<Popular>> fetchPopulars(List<Element> elements) async {
  List<Popular> populars = [];
  elements.forEach((element) {
    Element slideCaption = element.querySelector('.slide-caption > h3 > a');
    var p = Popular(
        img: element.querySelector('img').attributes['src'],
        url: slideCaption.attributes['href'],
        name: slideCaption.attributes['title']);
    populars.add(p);
  });
  return populars;
}