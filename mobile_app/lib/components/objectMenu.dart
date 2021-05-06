import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import 'Button.dart';


class ObjMenu extends StatefulWidget {
  @override
  ObjMenuState createState() => new ObjMenuState();
}

class ObjMenuState extends State<ObjMenu> {
  Map<String, bool> values = {
    "Категория": false,
    "Рус. название": false,
    "Англ. название": false,
    "Рус. Википедия": false,
    "Англ. Википедия": false,
    "Картинка": false,
    "Адрес": false,
    "Координаты": false,
    "Дупликат": false,
    "Другое": false,
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
                      title: Text("Сообщить об ошибке"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      actions: <Widget>[
                        Button(
                          text: "Отправить",
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
                                        MediaQuery.of(context).size.height * 0.5,
                                  ),
                                  child: ListView(
                                    children: values.keys.map((String key) {
                                      return Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: themeColor,
                                        ),
                                        child: CheckboxListTile(
                                          activeColor: themeColor,
                                          title: Text(key),
                                          value: values[key],
                                          onChanged: (bool value) {
                                            setState(() {
                                              values[key] = value;
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  )),
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
                        child: Icon(Icons.report, color: themeColor,),
                      ),
                      Text('Сообщить об ошибке')
                    ],
                  )),
            ]);
  }
}
