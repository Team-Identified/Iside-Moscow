import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/config.dart';

class SubmitObjectButton extends StatelessWidget {
  final void Function() goSubmit;

  const SubmitObjectButton({Key key, @required this.goSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.8,
      child: TextButton.icon(
        icon: Icon(Icons.edit),
        label: Text(
          "Предложить объект",
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
        onPressed: goSubmit,
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
          primary: themeColorShade,
          backgroundColor: themeColor.withOpacity(0.1),
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
        ),
      ),
    );
  }
}
