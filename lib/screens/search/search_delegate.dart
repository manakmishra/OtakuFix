import 'package:flutter/material.dart';
import 'package:otaku_fix/api/api_base.dart';
import 'package:otaku_fix/api/extensions/mangatown.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/home/widgets/manga_card.dart';

class CustomSearchDelegate extends SearchDelegate {
  final Base _api = MangaTown();
  bool _showClearButton = false;
  bool _notFetching = false;
  Cursor _cursor;

  @override
  String get searchFieldLabel => 'What do you wanna read?';

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        backgroundColor: kBackgroundColor,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
        elevation: 0,
        titleTextStyle: kBodyTextStyle,
        toolbarTextStyle: kBodyTextStyle,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle:
                kBodyTextStyle.copyWith(fontSize: 20, color: kAccentColor),
            labelStyle: kBodyTextStyle.copyWith(fontSize: 20),
            border: InputBorder.none,
          ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                query = '';
              },
            )
          : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
              style: TextStyle(fontFamily: 'Montserrat', color: kAccentColor),
            ),
          )
        ],
      );
    }

    _cursor = _api.getSearchResults(query);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.5),
      child: StreamBuilder(
        stream: _cursor.getNext().asStream(),
        builder: (context, AsyncSnapshot<List<Manga>> snapshot) {
          if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                "No Results Found.",
                style: TextStyle(fontFamily: 'Montserrat', color: kAccentColor),
              ),
            );
          } else {
            var results = snapshot.data;
            return GridView.builder(
              itemCount: results.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                childAspectRatio: 225 / 320,
              ),
              itemBuilder: (BuildContext context, int index) {
                return MangaCard(
                  manga: results[index],
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
