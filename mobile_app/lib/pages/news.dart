import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';

class News extends StatefulWidget {
  final Map news;

  @override
  _NewsState createState() => _NewsState();

  const News({Key key, this.news}) : super(key: key);
}

class _NewsState extends State<News> {
  Map test;

  final _scrollController = FixedExtentScrollController();

  // ignore: non_constant_identifier_names
  @override
  void initState() {
    super.initState();
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build (BuildContext context) {
    test = (ModalRoute.of(context).settings.arguments);
    var fixedTest = test['data'].news4today;


    checkUrls() {
      for (int i = 0; i < fixedTest.length; i++) {
        if (fixedTest[i]['urlToImage'] == null ||
            !isURL(fixedTest[i]['urlToImage'])) {
          fixedTest[i]['urlToImage'] =
              'https://i.pinimg.com/originals/8a/eb/d8/8aebd875fbddd22bf3971c3a7159bdc7.png';
        }
        if (fixedTest[i]['url'] == null || !isURL(fixedTest[i]['url'])) {
          fixedTest[i]['url'] = 'https://google.com';
        }
      }
    }

    checkUrls();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(child: Text('News')),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: ClickableListWheelScrollView(
          scrollController: _scrollController,
          itemHeight: 100,
          itemCount: 100,
          onItemTapCallback: (index) {
            launchURL(fixedTest[index]['url']);
          },
          child: ListWheelScrollView.useDelegate(
              controller: _scrollController,
              itemExtent: 425,
              diameterRatio: 9,
              squeeze: 1.2,
             // physics: PageScrollPhysics(),
              onSelectedItemChanged: (index) {
                // debugPrint(index.toString());
              },
              childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 100,
                  builder: (context, index) => Container(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 4/3,
                          child: Container(
                            height: 350.0,
                             decoration: BoxDecoration(
                               image: DecorationImage(
                                 fit: BoxFit.scaleDown,
                                 alignment: FractionalOffset.center,
                                 image: NetworkImage(
                               fixedTest[index]['urlToImage'])
                               ),
                             ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 285),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              // child: new RichText(
                              //   text: new TextSpan(text: 'Non touchable. ', children: [
                              //     new TextSpan(
                              //       text: 'Tap here.',
                              //       recognizer: new TapGestureRecognizer()..onTap = () => print('Tap Here onTap'),
                              //     )
                              //   ]),
                              // )

                                child: Text(
                                  fixedTest[index]['title'],
                                  style: TextStyle(fontSize: 16),
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                )),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))),
        ));
  }
}
