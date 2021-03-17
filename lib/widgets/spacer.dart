import 'package:flutter/material.dart';

class CustomSpacer extends StatelessWidget {
  final double space;
  final bool isVertical;

  const CustomSpacer({
    Key key,
    @required this.space,
    this.isVertical = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVertical
        ? Padding(padding: EdgeInsets.only(top: space))
        : Padding(padding: EdgeInsets.only(left: space));
  }
}
