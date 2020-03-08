import 'package:flutter/material.dart';

class LayoutUtils{
  static Widget buildVerticalSpacing(double spacingHeight){
    return SizedBox(
      height: spacingHeight,
    );
  }

  static Widget buildHorizontalSpacing(double spacingWidth){
    return SizedBox(
      width: spacingWidth,
    );
  }

  static Widget buildCircularProgressIndicator(BuildContext context){
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}