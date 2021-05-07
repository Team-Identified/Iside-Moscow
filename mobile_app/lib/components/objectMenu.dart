import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/components/middleButton.dart';
import 'package:mw_insider/config.dart';
import 'package:mw_insider/services/backendCommunicationService.dart';


class ObjMenu extends StatefulWidget {
  final int objectId;

  ObjMenu({Key key, @required this.objectId}) : super(key: key);

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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        primary: Colors.black.withOpacity(0.3),
        elevation: 5,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      onPressed: () {},
      child: PopupMenuButton(
        iconSize: 25,
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
                        MiddleButton(
                          text: "Отправить",
                          press:(){
                            Map requestData = {
                              'obj_id': widget.objectId,
                            };
                            for (String key in values.keys){
                              if (values[key]){
                                if (key == "Категория") requestData['category_problem'] = true;
                                else if (key == "Рус. название") requestData['ru_name_problem'] = true;
                                else if (key == "Англ. название") requestData['en_name_problem'] = true;
                                else if (key == "Рус. Википедия") requestData['ru_wiki_problem'] = true;
                                else if (key == "Англ. Википедия") requestData['en_wiki_problem'] = true;
                                else if (key == "Картинка") requestData['image_problem'] = true;
                                else if (key == "Адрес") requestData['address_problem'] = true;
                                else if (key == "Координаты") requestData['map_location_problem'] = true;
                                else if (key == "Дупликат") requestData['duplicate_problem'] = true;
                                else requestData['other_problem'] = true;
                              }
                            }
                            serverRequest('post', '/reports/new/', requestData);
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
            ]
      ),
    );
  }
}
