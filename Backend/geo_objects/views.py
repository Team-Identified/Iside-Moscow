from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework import status
from rest_framework.reverse import reverse
from config import GEOOBJECTS_SEARCH_SIMILARITY
from geo_objects.models import GeoObject, SubmittedGeoObject
from geo_objects.serializers import GeoObjectSerializer, SubmittedGeoObjectSerializer
from geo_objects.tools import get_nearby_objects
from rest_framework.permissions import IsAdminUser, AllowAny
from rest_framework.views import APIView
from rest_framework import viewsets
from fuzzywuzzy import fuzz


class GeoObjectViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list`, `create`, `retrieve`,
    `update` and `destroy` actions.
    """
    queryset = GeoObject.objects.all()
    serializer_class = GeoObjectSerializer
    permission_classes = [IsAdminUser]


class GeoObjectRetrieveViewSet(viewsets.ViewSet):
    def retrieve(self, request, pk=None):
        queryset = GeoObject.objects.all()
        geo_object = get_object_or_404(queryset, pk=pk)
        serializer = GeoObjectSerializer(geo_object, context={'request': request})
        return Response(serializer.data)


class SubmittedGeoObjectViewSet(viewsets.ViewSet):
    queryset = SubmittedGeoObject.objects.all()
    serializer_class = SubmittedGeoObjectSerializer

    def retrieve(self, request, pk=None):
        queryset = SubmittedGeoObject.objects.all()
        geo_object = get_object_or_404(queryset, pk=pk)
        if geo_object.contributor == request.user or request.user.is_staff:
            serializer = SubmittedGeoObjectSerializer(geo_object, context={'request': request})
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            return Response({"detail": "forbidden"}, status=status.HTTP_403_FORBIDDEN)

    def list(self, request):
        if request.user.is_authenticated:
            if request.user.is_staff:
                queryset = SubmittedGeoObject.objects.all()
            else:
                queryset = SubmittedGeoObject.objects.filter(contributor=request.user.id)
            serializer = SubmittedGeoObjectSerializer(queryset, many=True, context={'request': request})
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            return Response({"detail": "Authentication credentials were not provided."},
                            status=status.HTTP_401_UNAUTHORIZED)

    def create(self, request):
        serializer = SubmittedGeoObjectSerializer(data=request.data)
        if serializer.is_valid():
            contributor = None
            if request.user.is_authenticated:
                contributor = request.user
            serializer.save(contributor=contributor)
            return Response({"status": "ok"}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def destroy(self, request, pk=None):
        queryset = SubmittedGeoObject.objects.all()
        geo_object = get_object_or_404(queryset, pk=pk)
        if geo_object.contributor == request.user or request.user.is_staff:
            geo_object.delete()
            return Response({"status": "ok"}, status=status.HTTP_200_OK)
        else:
            return Response({"detail": "forbidden"}, status=status.HTTP_403_FORBIDDEN)


class GetNearbyObjectsForUserView(APIView):
    """
    Get nearby objects for user by coordinates
    """

    permission_classes = [AllowAny]

    @staticmethod
    def post(request):
        data = request.data
        latitude = data['latitude']
        longitude = data['longitude']

        objects = get_nearby_objects(request, (latitude, longitude))
        data = {
            'input': {
                'latitude': latitude,
                'longitude': longitude
            },
            'count': len(objects),
            'objects': objects
        }
        return Response(data=data, status=status.HTTP_200_OK)


class SearchObjectsView(APIView):

    permission_classes = [AllowAny]

    @staticmethod
    def _compare(search_request: str, name_en: str, name_ru: str):
        search_request = search_request.lower()
        name_en = name_en.lower()
        name_ru = name_ru.lower()
        return max(fuzz.WRatio(search_request, name_en), fuzz.WRatio(search_request, name_ru))

    @staticmethod
    def post(request):
        try:
            request_string = request.data["request"]
            if not isinstance(request_string, str):
                raise TypeError
        except (KeyError, TypeError):
            return Response(data={"error": ["field request not found or wrong type"]},
                            status=status.HTTP_400_BAD_REQUEST)

        queryset = GeoObject.objects.all()
        filtered = filter(
            lambda x: SearchObjectsView._compare(request_string, x.name_ru, x.name_en) >= GEOOBJECTS_SEARCH_SIMILARITY,
            queryset)

        serializer = GeoObjectSerializer(filtered, many=True, context={"request": request})

        return Response(data=serializer.data, status=status.HTTP_200_OK)


class APIRootView(APIView):
    @staticmethod
    def get(request):
        endpoints = {
            'get nearby objects': reverse('get_nearby', request=request),
            'search objects by name': reverse('geoobjects-search', request=request),
            'geo object list': request.build_absolute_uri('geo_object-list'),
            'submitted geo object list': request.build_absolute_uri('submitted_geo_objects'),
        }
        return Response(data=endpoints, status=status.HTTP_200_OK)
