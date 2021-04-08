from rest_framework.decorators import api_view
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.reverse import reverse
from rest_framework.views import APIView
from rest_framework import status
from newsapi import NewsApiClient
from news.models import NewsArticle
from news.serializers import NewsArticleSerializer
from config import NEWS_API_KEY, NEWS_UPDATE_FREQ, NEWS_COUNTER, NEWS_MAX_AGE, NEWS_PAGINATION
import datetime


news_api = NewsApiClient(api_key=NEWS_API_KEY)


def parse_date(time_stamp):
    date_format = "%Y-%m-%dT%H:%M:%SZ"
    date = datetime.datetime.strptime(time_stamp, date_format)
    return date


def delete_old_articles(time_offset):
    now = datetime.datetime.now(datetime.timezone.utc)
    old_articles = NewsArticle.objects.all()
    for old_article in old_articles:
        age = now - old_article.publish_date
        if age.days > time_offset:
            old_article.delete()


def update_news(counter=100, time_offset=30):
    try:
        delete_old_articles(time_offset)

        top_headlines = news_api.get_everything(qintitle='Москва',
                                                sort_by='publishedAt', page_size=counter)
        articles = top_headlines['articles']
        for article in articles:
            publish_date = parse_date(article['publishedAt'])
            age = datetime.datetime.now() - publish_date
            exists = NewsArticle.objects.filter(title=article['title']).count() > 0
            if article['url'] and article['urlToImage'] and age.days <= time_offset and not exists:
                f_article = NewsArticle(
                    source=article['source']['name'],
                    title=article['title'],
                    description=article['description'],
                    article_url=article['url'],
                    image_url=article['urlToImage'],
                    publish_date=publish_date,
                )
                f_article.save()
    except Exception as e:
        raise e


def need_for_update(offset=1):
    try:
        latest_article = NewsArticle.objects.latest('publish_date')
        now = datetime.datetime.now(datetime.timezone.utc)
        age = now - latest_article.publish_date
        if age.days > offset:
            return True
        else:
            return False
    except Exception as e:
        print(f"BD is empty!: {e}")
        return True


class GetNews(APIView):
    # permission_classes = [IsAuthenticated]
    permission_classes = [AllowAny]

    def get(self, request, page):
        if need_for_update(offset=NEWS_UPDATE_FREQ):
            update_news(counter=NEWS_COUNTER, time_offset=NEWS_MAX_AGE)

        articles = NewsArticle.objects.all()
        total_count = len(articles)
        first_ind = (page - 1) * NEWS_PAGINATION
        last_ind = page * NEWS_PAGINATION
        articles = articles[first_ind:last_ind:]
        articles_json = []
        for article in articles:
            articles_json.append(NewsArticleSerializer(article).data)

        return Response({
            "status": "ok",
            "totalResults": total_count,
            "pageResults": len(articles_json),
            "page": page,
            "articles": articles_json,
        }, status=status.HTTP_200_OK)


@api_view(['GET'])
def api_root(request):
    return Response({
        'get news': reverse('news-root', request=request) + 'get_news/1',
    })
