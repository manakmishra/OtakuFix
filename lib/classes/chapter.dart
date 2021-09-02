class Chapter {
  String url;
  String text;
  bool isRead = false;
  int lastRead;

  Chapter(this.url, this.text);

  Chapter.withLastRead(this.url, this.text, this.lastRead);
}
