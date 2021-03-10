from geo_objects.models import GeoObject
from geo_objects.serializers import GeoObjectSerializer
from rest_framework import permissions
from geo_objects.permissions import IsContributorOrReadOnly
from rest_framework import viewsets


class GeoObjectViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list`, `create`, `retrieve`,
    `update` and `destroy` actions.
    """
    queryset = GeoObject.objects.all()
    serializer_class = GeoObjectSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly,
                          IsContributorOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(contributor=self.request.user)
