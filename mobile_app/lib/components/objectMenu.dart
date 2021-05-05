import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/config.dart';
import 'package:mobile_app/tools.dart';

import '../tools.dart';
import 'Button.dart';

class ObjMenu extends StatefulWidget {
  @override
  ObjMenuState createState() => new ObjMenuState();
}

class ObjMenuState extends State<ObjMenu> {
  final TextEditingController _commentController = TextEditingController();
  Map<String, bool> values = {
    "Category": false,
    "Russian Name": false,
    "English Name": false,
    "Russian Wiki": false,
    "English Wiki": false,
    "Image": false,
    "Address": false,
    "Map Location": false,
    "Duplicate": false,
    "Other": false,
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (result) {
          if (result == "report") {
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: Text("Report an error"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      actions: <Widget>[
                        Button(
                          text: "OK",
                          press:(){
                            //вставить Запрос
                            Navigator.of(context, rootNavigator: true).pop('dialog');
                          },
                        )
                      ],
                      content: SingleChildScrollView(
                        child: Container(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Divider(),
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.5,
                                  ),
                                  child: ListView(
                                    children: values.keys.map((String key) {
                                      return CheckboxListTile(
                                        title: Text(key),
                                        value: values[key],
                                        onChanged: (bool value) {
                                          setState(() {
                                            values[key] = value;
                                          });
                                        },
                                      );
                                    }).toList(),
                                  )),
                              Divider(),
                              TextField(
                                controller: _commentController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,
                                maxLength: 200,
                                autofocus: false,
                                style: TextStyle(fontSize: 12),
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Describe an error",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                });
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: "report",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 7, 2),
                        child: Icon(Icons.report),
                      ),
                      Text('Report')
                    ],
                  )),
            ]);
  }
}
