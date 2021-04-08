from django.db import models


class NewsArticle(models.Model):
    source = models.CharField(max_length=300)
    title = models.TextField()
    description = models.TextField()
    article_url = models.URLField()
    image_url = models.URLField()
    publish_date = models.DateTimeField()
