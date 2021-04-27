import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


String capitalize(String line) {
  return "${line[0].toUpperCase()}${line.substring(1)}";
}


IconData getIcon(String category){
  IconData iconObj;
  if (category == "monument")
    iconObj = Icons.account_circle;
  else if (category == "theatre")
    iconObj = Icons.theater_comedy;
  else if (category == "museum")
    iconObj = Icons.museum;
  else if (category == "government building")
    iconObj = Icons.account_balance;
  else if (category == "mall")
    iconObj = Icons.local_mall;
  else if (category == "red square object")
    iconObj = Icons.star;
  else if (category == "religious building")
    iconObj = MdiIcons.bookCross;
  else if (category == "restaurant")
    iconObj = MdiIcons.silverwareForkKnife;
  else if (category == "skyscraper")
    iconObj = MdiIcons.officeBuilding;
  else if (category == "stadium")
    iconObj = MdiIcons.stadium;
  else if (category == "unknown")
    iconObj = MdiIcons.helpCircle;
  else
    iconObj = Icons.location_on;

  return iconObj;
}