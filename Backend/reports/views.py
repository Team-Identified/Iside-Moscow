from rest_framework.decorators import api_view
from rest_framework.reverse import reverse
from rest_framework.views import APIView
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .models import Report
from .serializers import ReportSerializer
from .permissions import AdminOrCreator, AdminOrCreateOnly


class ReportCreateListView(ListCreateAPIView):
    queryset = Report.objects.all()
    serializer_class = ReportSerializer
    permission_classes = [AdminOrCreateOnly]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class ReportRetrieveUpdateDestroyView(RetrieveUpdateDestroyAPIView):
    queryset = Report.objects.all()
    serializer_class = ReportSerializer
    permission_classes = [AdminOrCreator]


class GetReportsForUserView(APIView):
    permission_classes = [IsAuthenticated]

    @staticmethod
    def get(request):
        queryset = Report.objects.filter(user=request.user)
        serializer = ReportSerializer(data=queryset, many=True)

        return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(['GET'])
def api_root(request):
    return Response({
        'all reports': reverse('reports-all', request=request),
        'change report': reverse('reports-change', request=request),
        'reports for user': reverse('reports-get_for_user', request=request),
    })
