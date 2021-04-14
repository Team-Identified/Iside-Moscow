from rest_framework.decorators import api_view
from rest_framework.generics import get_object_or_404
from rest_framework.reverse import reverse
from rest_framework.viewsets import ViewSet
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated, IsAdminUser
from rest_framework.decorators import permission_classes

from geo_objects.models import GeoObject

from .models import Report
from .serializers import ReportSerializer
from .permissions import ReportsMainPermission


class ReportViewSet(ViewSet):

    permission_classes = [ReportsMainPermission]

    @staticmethod
    def create(request, pk=None):
        serializer = ReportSerializer(data=request.data)

        print(request.data)

        try:
            obj = get_object_or_404(GeoObject, id=request.data["obj"])
        except (KeyError, TypeError):
            return Response({
                                "obj": ["field not found"]
                            }, status.HTTP_400_BAD_REQUEST)

        if serializer.is_valid():
            serializer.save(
                user=request.user if request.user.is_authenticated else None,
                obj=obj
            )
            return Response({"status": "ok"}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def retrieve(self, request, pk=None):
        queryset = Report.objects.all()
        report = get_object_or_404(queryset, pk=pk)
        serializer = ReportSerializer(report, context={'request': request})
        self.check_object_permissions(request, report)
        return Response(serializer.data, status.HTTP_200_OK)

    def list(self, request, pk=None):
        if request.user.is_staff:
            queryset = Report.objects.all()
        else:
            queryset = Report.objects.filter(user=request.user)
        self.check_object_permissions(request, queryset)
        serializer = ReportSerializer(queryset, many=True, context={'request': request})
        return Response(serializer.data, status.HTTP_200_OK)

    @staticmethod
    def partial_update(request, pk=None):
        queryset = Report.objects.all()

        obj = None
        if "obj" in request.data:
            try:
                obj = get_object_or_404(GeoObject, id=request.data["obj"])
            except (KeyError, TypeError):
                return Response({
                                    "obj": ["field invalid"]
                                }, status.HTTP_400_BAD_REQUEST)

        serializer = ReportSerializer(get_object_or_404(queryset, pk=pk), data=request.data,
                                      partial=True, context={'request': request})

        if serializer.is_valid():
            if obj is not None:
                serializer.save(obj=obj)
            else:
                serializer.save()
            return Response({"status": "ok"}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @staticmethod
    def destroy(request, pk=None):
        queryset = Report.objects.all()
        report = get_object_or_404(queryset, pk=pk)
        report.delete()
        return Response({"status": "ok"}, status=status.HTTP_200_OK)


@api_view(['GET'])
def api_root(request):
    return Response({
        'create report': reverse('reports-create', request=request),
        'all reports list': reverse('reports-all', request=request),
        'retrieve, update or delete report': reverse('reports-root', request=request) + "1",
    })
