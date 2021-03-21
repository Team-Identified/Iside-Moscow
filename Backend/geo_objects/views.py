from geo_objects.models import GeoObject, SubmittedGeoObject
from geo_objects.serializers import GeoObjectSerializer, SubmittedGeoObjectSerializer
from geo_objects.permissions import IsContributorOrStaffOrReadOnly
from rest_framework.permissions import IsAdminUser
from rest_framework import viewsets


class GeoObjectViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list`, `create`, `retrieve`,
    `update` and `destroy` actions.
    """
    queryset = GeoObject.objects.all()
    serializer_class = GeoObjectSerializer
    permission_classes = [IsAdminUser]


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
