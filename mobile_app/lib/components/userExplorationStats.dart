import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/components/indicator.dart';
import 'package:mw_insider/components/loadingCircle.dart';
import 'package:mw_insider/config.dart';
import 'package:mw_insider/services/backendCommunicationService.dart';
import 'package:mw_insider/services/uiService.dart';


class UserExplorationStats extends StatefulWidget {
  const UserExplorationStats({Key key}) : super(key: key);

  @override
  _UserExplorationStatsState createState() => _UserExplorationStatsState();
}

class _UserExplorationStatsState extends State<UserExplorationStats> {
  Map stats;
  bool loaded = false;

  final List<Color> colors = [
    Colors.deepPurpleAccent,
    Colors.orange,
    Colors.amber,
    Colors.blueAccent,
    Colors.red,
    Colors.green,
    Colors.teal,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.grey,
    Colors.indigo,
    Colors.greenAccent,
  ];

  Widget title = Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            "Ваша статистика",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18.0,
            ),
          ),
        ),
        Container(
          child: SizedBox(
            height: 2.0,
            child: Container(color: themeColor),
          ),
        )
      ],
    ),
  );

  void loadData() async {
    Map response = await serverRequest('get', '/geo_objects/my_stats', null);
    if (mounted){
      setState(() {
        stats = response;
        loaded = true;
      });
    }
  }

  Widget composePieChart(){
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 0.0,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    // read about it in the PieChartData section
                    sections: composeChartSections(),
                    centerSpaceRadius: double.infinity,
                  ),
                  swapAnimationDuration: Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear, // Optional
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: composeStatsColumn(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> composeStatsColumn(){
    List<Widget> lines = [];
    int index = 0;
    for (String key in stats.keys){
      if (key != 'total') {
        String russianCategory = getRussianCategoryMNCH(key);
        russianCategory = capitalize(russianCategory);
        Widget line = Indicator(
          color: colors[index],
          text: russianCategory,
          isSquare: true,
        );
        lines.add(line);
        lines.add(SizedBox(height: 4.0));
        index++;
      }
    }
    return lines;
  }


  List<PieChartSectionData> composeChartSections(){
    List<PieChartSectionData> sections = [];
    int index = 0;
    for (String key in stats.keys){
      if (key != 'total') {
        int value = stats[key];
        PieChartSectionData section = PieChartSectionData(
          color: colors[index],
          value: value.toDouble(),
          title: '$value',
          // radius: 30.0,
          titleStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
        sections.add(section);
        index++;
      }
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (!loaded){
      loadData();
      return Container(child: Center(child: LoadingCircle()));
    }
    else{
      // Widget statsColumn = composeStatsColumn();
      Widget pieChart = composePieChart();
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                child: pieChart,
              ),
            )
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
            //   child: Text(
            //     "Всего открыто: ${stats['total']}",
            //     style: TextStyle(
            //       fontSize: 17.0,
            //     ),
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
            //   child: statsColumn
            // ),
          ],
        ),
      );
    }
  }
}
