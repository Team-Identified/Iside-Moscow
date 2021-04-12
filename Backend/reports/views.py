from rest_framework.views import APIView
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated

from django.contrib.auth.models import User

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
        data = [ReportSerializer(record).data for record in Report.objects.get(user=request.user)]

        return Response(
            data,
            status.HTTP_200_OK
        )
