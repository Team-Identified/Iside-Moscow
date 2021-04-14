from rest_framework.decorators import api_view
from rest_framework.generics import get_object_or_404
from rest_framework.reverse import reverse
from rest_framework.viewsets import ViewSet
from rest_framework.response import Response
from rest_framework import status
from .models import Report
from .serializers import ReportViewSerializer, ReportCreateSerializer
from .permissions import ReportsMainPermission


class ReportViewSet(ViewSet):
    permission_classes = [ReportsMainPermission]

    queryset = Report.objects.all()
    serializer_class = ReportCreateSerializer

    @staticmethod
    def create(request):
        serializer = ReportCreateSerializer(data=request.data)
        if serializer.is_valid():
            user = request.user if request.user.is_authenticated else None
            serializer.save(user=user)
            return Response({"status": "ok"}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def retrieve(self, request, pk=None):
        queryset = Report.objects.all()
        report = get_object_or_404(queryset, pk=pk)
        if report.user == request.user or request.user.is_staff:
            serializer = ReportViewSerializer(report, context={'request': request})
            self.check_object_permissions(request, report)
            return Response(serializer.data, status.HTTP_200_OK)
        else:
            return Response({"detail": "You do not have permission to perform this action."},
                            status=status.HTTP_403_FORBIDDEN)

    def list(self, request):
        if request.user.is_authenticated:
            if request.user.is_staff:
                queryset = Report.objects.all()
            else:
                queryset = Report.objects.filter(user=request.user)
            self.check_object_permissions(request, queryset)
            serializer = ReportViewSerializer(queryset, many=True, context={'request': request})
            return Response(serializer.data, status.HTTP_200_OK)
        else:
            return Response({"detail": "Authentication credentials were not provided."},
                            status=status.HTTP_401_UNAUTHORIZED)

    @staticmethod
    def update(request, pk=None):
        queryset = Report.objects.all()
        report = get_object_or_404(queryset, pk=pk)
        if report.user == request.user or request.user.is_staff:
            serializer = ReportCreateSerializer(report, data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response({"status": "ok"}, status=status.HTTP_200_OK)
            else:
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"detail": "You do not have permission to perform this action."},
                            status=status.HTTP_403_FORBIDDEN)

    @staticmethod
    def destroy(request, pk=None):
        queryset = Report.objects.all()
        report = get_object_or_404(queryset, pk=pk)
        if report.user == request.user or request.user.is_staff:
            report.delete()
            return Response({"status": "ok"}, status=status.HTTP_200_OK)
        else:
            return Response({"detail": "You do not have permission to perform this action."},
                            status=status.HTTP_403_FORBIDDEN)


@api_view(['GET'])
def api_root(request):
    return Response({
        'create report': reverse('reports-create', request=request),
        'change report': reverse('reports-root', request=request) + "change/1",
        'all reports list': reverse('reports-all', request=request),
        'retrieve, destroy report': reverse('reports-root', request=request) + "1",
    })
