import 'package:mobile_app/models/article.dart';

List<Article> getArticles(){
  List<Article> articles = <Article>[];

  Article article = new Article();
  article.title = 'Москва предупредила Вашингтон о последствиях действий Киева в Донбассе';
  article.sourceName = 'Vesti.ru';
  article.description = 'Представители России и США обсудили ситуацию на юго-востоке Украины, сообщил замглавы МИД РФ Сергей Рябков.';
  article.articleUrl = 'https://www.vesti.ru/article/2546871';
  article.imageUrl = 'https://cdn-st1.rtr-vesti.ru/vh/pictures/xw/213/350/1.jpg';
  article.publishedAt = '2021-04-06T06:47:00Z';

  articles.add(article);

  return articles;
}

