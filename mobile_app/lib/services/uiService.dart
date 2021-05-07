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


String getRankIconPath(String rank){
  if (rank == 'Новичок') return 'assets/images/rangs/rang_0.png';
  else if (rank == 'Любитель') return 'assets/images/rangs/rang_1.png';
  else if (rank == 'Знаток') return 'assets/images/rangs/rang_2.png';
  else if (rank == 'Продвинутый') return 'assets/images/rangs/rang_3.png';
  else if (rank == 'Эксперт') return 'assets/images/rangs/rang_4.png';
  else if (rank == 'Мастер') return 'assets/images/rangs/rang_5.png';
  else if (rank == 'Просветленный') return 'assets/images/rangs/rang_6.png';
  else if (rank == 'Гуру') return 'assets/images/rangs/rang_7.png';
  else if (rank == 'Дока') return 'assets/images/rangs/rang_8.png';
  else if (rank == 'Богоподобный') return 'assets/images/rangs/rang_10.png';
  else return 'assets/images/rangs/rang_0.png';
}


List<int> getPointsBoundaries(String rank){
  if (rank == 'Новичок') return [0, 14];
  else if (rank == 'Любитель') return [15, 74];
  else if (rank == 'Знаток') return [75, 249];
  else if (rank == 'Продвинутый') return [250, 499];
  else if (rank == 'Эксперт') return [500, 1499];
  else if (rank == 'Мастер') return [1500, 4999];
  else if (rank == 'Просветленный') return [5000, 14999];
  else if (rank == 'Гуру') return [15000, 49999];
  else if (rank == 'Дока') return [50000, 99999];
  else if (rank == 'Богоподобный') return [100000, 691337];
  else return [0, 691337];
}
