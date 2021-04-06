import 'package:flutter/material.dart';
import 'package:mobile_app/models/article.dart';
import 'package:mobile_app/tools/load_news.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<Article> articles = <Article>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    articles = getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('News'),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.deepPurpleAccent[700],
          ),
          backgroundColor: Colors.grey[300],
          body: Container(
            child: ListView.builder(
              itemCount: articles.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index){
               return NewsArticle(
                title: articles[index].title,
                sourceName: articles[index].sourceName,
                description: articles[index].description,
                articleUrl: articles[index].articleUrl,
                imageUrl: articles[index].imageUrl,
                publishedAt: articles[index].publishedAt,
               );
              }
            )
          ),
        )
    );
  }
}

class NewsArticle extends StatelessWidget {
  final String title;
  final String sourceName;
  final String description;
  final String articleUrl;
  final String imageUrl;
  final String publishedAt;

  const NewsArticle({
    this.title,
    this.sourceName,
    this.description,
    this.articleUrl,
    this.imageUrl,
    this.publishedAt
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(imageUrl)
          ),
        ],
      )
    );
  }
}


