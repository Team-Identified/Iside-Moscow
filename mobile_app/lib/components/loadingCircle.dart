import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/config.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(themeColorShade),
      ),
    );
  }
}
