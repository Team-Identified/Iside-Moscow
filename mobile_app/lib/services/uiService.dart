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


String getRussianCategory(String category){
  if (category == "monument") return "памятник";
  else if (category == "theatre") return "театр";
  else if (category == "museum") return "музей";
  else if (category == "government building") return "здание правительства";
  else if (category == "mall") return "торговый центр";
  else if (category == "Red square object") return "объект Красной Площади";
  else if (category == "religious building") return "религиозная постройка";
  else if (category == "restaurant") return "ресторан";
  else if (category == "skyscraper") return "небоскрёб";
  else if (category == "stadium") return "стадион";
  else if (category == "unknown") return "неизвестно";
  else if (category == "other") return "другое";
  else return "неизвестная категория";
}


// То же самое, но в множественном числе
String getRussianCategoryMNCH(String category){
  if (category == "monument") return "памятники";
  else if (category == "theatre") return "театры";
  else if (category == "museum") return "музеи";
  else if (category == "government building") return "здания правительства";
  else if (category == "mall") return "торговые центры";
  else if (category == "Red square object") return "объекты Красной Площади";
  else if (category == "religious building") return "религиозные постройки";
  else if (category == "restaurant") return "рестораны";
  else if (category == "skyscraper") return "небоскрёбы";
  else if (category == "stadium") return "стадионы";
  else if (category == "unknown") return "неизвестные";
  else if (category == "other") return "другие";
  else return "неизвестной категории";
}
