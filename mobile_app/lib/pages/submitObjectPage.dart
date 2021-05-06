import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mw_insider/config.dart';
import 'package:mw_insider/services/backendCommunicationService.dart';


class SubmitObjectPage extends StatefulWidget {
  final VoidCallback onGoBack;

  SubmitObjectPage({Key key, @required this.onGoBack}) : super(key: key);

  @override
  _SubmitObjectPageState createState() => _SubmitObjectPageState();
}

class _SubmitObjectPageState extends State<SubmitObjectPage> {
  int category = 11;
  TextEditingController nameRuController;
  TextEditingController nameEnController;
  TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameRuController = TextEditingController();
    nameEnController = TextEditingController();
    addressController = TextEditingController();
    // _searchController.addListener(() {
    //   setState(() {
    //     _searchText = _searchController.text;
    //   });
    // });
  }

  Widget title = Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Center(
            child: Text(
              "Предложить объект",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 23.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            height: 4.0,
            child: Container(color: themeColor),
          ),
        )
      ],
    ),
  );

  Widget getForm(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            title: Text("Категория"),
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            trailing: Theme(
              data: ThemeData(
                primaryColor: themeColor,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: category,
                  isExpanded: false,
                  items: [
                    DropdownMenuItem(
                      child: Text("Памятник"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("Театр"),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text("Музей"),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: Text("Здание правительства"),
                      value: 4,
                    ),
                    DropdownMenuItem(
                      child: Text("Торговый центр"),
                      value: 5,
                    ),
                    DropdownMenuItem(
                      child: Text("Объект Красной Площади"),
                      value: 6,
                    ),
                    DropdownMenuItem(
                      child: Text("Религиозное строение"),
                      value: 7,
                    ),
                    DropdownMenuItem(
                      child: Text("Ресторан"),
                      value: 8,
                    ),
                    DropdownMenuItem(
                      child: Text("Небоскрёб"),
                      value: 9,
                    ),
                    DropdownMenuItem(
                      child: Text("Стадион"),
                      value: 10,
                    ),
                    DropdownMenuItem(
                      child: Text("Другое"),
                      value: 11,
                    ),
                  ],
                  onChanged: (value){
                    if (mounted){
                      setState(() {
                        category = value;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Theme(
            data: ThemeData(
              primaryColor: themeColor,
            ),
            child: TextField(
              controller: nameRuController,
              decoration: InputDecoration(
                hintText: "Название на русском",
                prefixIcon: Icon(Icons.language),
              ),
            ),
          ),
          SizedBox(height: 10),
          Theme(
            data: ThemeData(
              primaryColor: themeColor,
            ),
            child: TextField(
              controller: nameEnController,
              decoration: InputDecoration(
                hintText: "Название на английском",
                prefixIcon: Icon(Icons.language),
              ),
            ),
          ),
          SizedBox(height: 10),
          Theme(
            data: ThemeData(
              primaryColor: themeColor,
            ),
            child: TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: "Адрес",
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget getGoBackButton(double screenWidth){
    return Container(
      width: screenWidth * 0.7,
      child: TextButton.icon(
        icon: Icon(MdiIcons.arrowLeft),
        label: Text("Вернуться"),
        onPressed: widget.onGoBack,
        style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            primary: themeColorShade,
            backgroundColor: themeColor.withOpacity(0.1),
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
        ),
      ),
    );
  }

  String getCategory(int value) {
    if (value == 1) return 'MN';
    else if (value == 2) return 'TR';
    else if (value == 3) return 'MS';
    else if (value == 4) return 'GB';
    else if (value == 5) return 'ML';
    else if (value == 6) return 'RS';
    else if (value == 7) return 'RB';
    else if (value == 8) return 'RT';
    else if (value == 9) return 'SS';
    else if (value == 10) return 'SD';
    else return 'OT';
  }

  void onSubmit() async {
    String categoryName = getCategory(category);
    if (nameRuController.text.isNotEmpty){
      Map requestData = {
        "category": categoryName,
        "name_ru": nameRuController.text,
        "name_en": nameEnController.text,
        "address": addressController.text,
      };
      print(requestData);
      await serverRequest('post', '/geo_objects/submitted_geo_objects/', requestData);
    }
    widget.onGoBack();
  }

  Widget getSubmitButton(double screenWidth){
    return Container(
      width: screenWidth * 0.8,
      height: 60.0,
      child: TextButton(
        child: Text(
          "Предложить",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        onPressed: onSubmit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: [
          SizedBox(height: 10.0),
          title,
          getGoBackButton(screenWidth),
          SizedBox(height: 25.0),
          Flexible(child: getForm()),
          Spacer(),
          getSubmitButton(screenWidth),
          SizedBox(height: 7.0),
        ],
      ),
    );
  }
}
