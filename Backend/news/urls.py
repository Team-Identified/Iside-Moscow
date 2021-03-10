from django.urls import path
from news import views


urlpatterns = [
    path('', views.api_root, name='news-root'),
    path('get_news/', views.GetNews.as_view(), name='get-news'),
]
