from rest_framework.decorators import api_view
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.reverse import reverse
from rest_framework.views import APIView
from rest_framework import status
from newsapi import NewsApiClient
from config import NEWS_API_KEY


news_api = NewsApiClient(api_key=NEWS_API_KEY)


class GetNews(APIView):
    # permission_classes = [IsAuthenticated]

    def get(self, request):
        page = request.GET.get('page')
        try:
            page = int(page)
        except ValueError:
            return Response({'error': 'page was not specified correctly'}, status=status.HTTP_400_BAD_REQUEST)
        except TypeError:
            return Response({'error': 'page was not specified'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            top_headlines = news_api.get_everything(qintitle='Москва',
                                                    sort_by='publishedAt', page_size=10, page=page)
        except Exception as e:
            return Response({'error': e.__dict__}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        return Response(top_headlines)


@api_view(['GET'])
def api_root(request):
    return Response({
        'get news': reverse('get-news', request=request)
    })
