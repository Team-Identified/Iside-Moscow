from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework import status
from rest_framework.reverse import reverse
from geo_objects.models import GeoObject, SubmittedGeoObject
from geo_objects.serializers import GeoObjectSerializer, SubmittedGeoObjectSerializer
from geo_objects.permissions import IsContributorOrStaffOrReadOnly
from geo_objects.tools import get_nearby_objects
from rest_framework.permissions import IsAdminUser, IsAuthenticated, AllowAny
from rest_framework.views import APIView
from rest_framework import viewsets


class GeoObjectViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list`, `create`, `retrieve`,
    `update` and `destroy` actions.
    """
    queryset = GeoObject.objects.all()
    serializer_class = GeoObjectSerializer
    permission_classes = [IsAdminUser]
    # permission_classes = [AllowAny]


class GeoObjectRetrieveViewSet(viewsets.ViewSet):
    def retrieve(self, request, pk=None):
        queryset = GeoObject.objects.all()
        geo_object = get_object_or_404(queryset, pk=pk)
        serializer = GeoObjectSerializer(geo_object, context={'request': request})
        return Response(serializer.data)


class SubmittedGeoObjectViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list`, `create`, `retrieve`,
    `update` and `destroy` actions.
    """
    queryset = SubmittedGeoObject.objects.all()
    serializer_class = SubmittedGeoObjectSerializer
    permission_classes = [IsContributorOrStaffOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(contributor=self.request.user)


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


class APIRootView(APIView):
    @staticmethod
    def get(request):
        endpoints = {
            'get nearby objects': reverse('get_nearby', request=request),
            'geo object list': request.build_absolute_uri('geo_object-list'),
            'submitted geo object list': request.build_absolute_uri('submitted_geo_object-list'),
        }
        return Response(data=endpoints, status=status.HTTP_200_OK)
