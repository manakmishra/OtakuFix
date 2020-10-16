import 'package:flutter/material.dart';
import 'package:otaku_fix/constants/text_styles.dart';

class SliverHeadingText extends StatelessWidget {
  const SliverHeadingText({
    Key key,
    this.text
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, bottom: 18.0, top: 15.0),
        child: Text(
          text,
          style: kBodyTitleStyle,
        ),
      ),
    );
  }
}