import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/config.dart';

class ArticleImage extends StatelessWidget {
  final String imgUrl;
  
  const ArticleImage({this.imgUrl});
  
  @override
  Widget build(BuildContext context) {
    try {
      return Image.network(
        imgUrl,
        errorBuilder: (BuildContext context, Object exception,
            StackTrace stackTrace) {
          return Image.asset("assets/images/AnimeGirls.jpg");
        },
        loadingBuilder: (context, child, progress) {
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
      );
    }
    catch(e){
      print('Image loading error: $e');
      return Image.asset("AnimeGirls.jpg");
    }
  }
}
