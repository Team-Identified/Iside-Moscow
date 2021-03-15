from geo_objects.models import GeoObject
from geo_objects.serializers import GeoObjectSerializer
from geo_objects.permissions import IsContributorOrStaffOrReadOnly
from rest_framework import viewsets


class GeoObjectViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list`, `create`, `retrieve`,
    `update` and `destroy` actions.
    """
    queryset = GeoObject.objects.all().filter(approved=True)
    serializer_class = GeoObjectSerializer
    permission_classes = [IsContributorOrStaffOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(contributor=self.request.user)
