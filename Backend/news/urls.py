from django.urls import path
from news import views


urlpatterns = [
    path('', views.api_root, name='news-root'),
    path('get_news/<int:page>', views.GetNews.as_view(), name='get-news'),
]
