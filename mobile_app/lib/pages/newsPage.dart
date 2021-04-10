import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/components/unauthorizedPage.dart';
import 'package:mobile_app/tools.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/config.dart';


class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Map> newsArticles = [];
  int currentPage = 0;
  bool reachedEnd = false;
  bool loggedIn = true;

  Future<void> getMoreNews() async {
    bool realLog = await isLoggedIn();
    if (loggedIn != realLog){
      setState(() {
        loggedIn = realLog;
      });
    }

    if (!loggedIn)
        return;

    if (reachedEnd)
      return;

    currentPage++;
    Map data = await serverRequest('get', 'news/get_news/$currentPage', null);
    var jsonArticles = data['articles'];
    int articlesOnPage = data['pageResults'];
    List<Map> articles = [];
    for (int i = 0; i < jsonArticles.length; ++i){
      articles.add(jsonArticles[i]);
    }

    setState(() {
      newsArticles.addAll(articles);
      if (articlesOnPage == 0){
        setState(() {
          reachedEnd = true;
        });
      }
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (!loggedIn){
      getMoreNews();
      return UnauthorizedPage();
    }
    else {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("News"),
            centerTitle: true,
            backgroundColor: themeColor,
          ),
          backgroundColor: Colors.grey[300],
          body: ListView.separated(
            itemCount: newsArticles.length + 1,
            addAutomaticKeepAlives: false,
            cacheExtent: 100.0,
            itemBuilder: (context, index) {
              if (index < newsArticles.length) {
                return Article(
                  title: newsArticles[index]['title'],
                  source: newsArticles[index]['source'],
                  description: newsArticles[index]['description'],
                  articleUrl: newsArticles[index]['article_url'],
                  imgUrl: newsArticles[index]['image_url'],
                  publishedAt: DateTime.parse(
                      newsArticles[index]['publish_date']),
                );
              }
              else {
                getMoreNews();
                return Container(
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepPurple),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                );
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 15.0);
            },
          ),
        ),
      );
    }
  }
}

class Article extends StatelessWidget {
  final String title;
  final String source;
  final String description;
  final String articleUrl;
  final String imgUrl;
  final DateTime publishedAt;

  const Article({
    this.title,
    this.source,
    this.description,
    this.articleUrl,
    this.imgUrl,
    this.publishedAt
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            source,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat('EEEE d MMMM H:mm').format(publishedAt),
            style: TextStyle(
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 5.0),
          GestureDetector(
            onTap: (){
              tryLaunch(articleUrl);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imgUrl,
                errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace){
                  return Image.network(
                    animeGirlsUrl,
                    loadingBuilder: (context, child, progress){
                      return progress == null
                          ? child
                          : Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace){
                      return Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                          ),
                        ),
                      );
                    },
                  );
                },
                loadingBuilder: (context, child, progress){
                  return progress == null
                  ? child
                  : Container(
                    color: Colors.grey[300],
                    padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          Text(
            description,
            maxLines: 5,
            style: TextStyle(
              wordSpacing: 3.0,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
      color: Colors.white,
    );
  }
}

