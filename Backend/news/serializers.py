from rest_framework import serializers
from news.models import NewsArticle


class NewsArticleSerializer(serializers.ModelSerializer):
    class Meta:
        model = NewsArticle
        fields = [
            'source',
            'title',
            'description',
            'article_url',
            'image_url',
            'publish_date',
        ]
