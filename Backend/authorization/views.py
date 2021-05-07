from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.generics import (RetrieveUpdateDestroyAPIView, ListAPIView)
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from rest_framework.response import Response
from rest_framework.reverse import reverse
from rest_framework.views import APIView
from .models import UserProfile
from .permissions import IsOwnerProfileOrReadOnly
from .serializers import UserProfileSerializer, SetTagsRequestSerializer


class UserProfileListCreateView(ListAPIView):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [IsAdminUser]


class UserProfileDetailView(RetrieveUpdateDestroyAPIView):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [IsOwnerProfileOrReadOnly, IsAuthenticated]


class SetTagsView(APIView):
    permission_classes = [IsAuthenticated]
    serializer_class = SetTagsRequestSerializer

    @staticmethod
    def post(request):
        request_serializer = SetTagsRequestSerializer(data=request.data)
        if request_serializer.is_valid():
            tags = request_serializer.data.get('tags').split(', ')
            current_user = UserProfile.objects.get(user=request.user)
            for tag in tags:
                current_user.notification_tags.add(tag)
            current_user.save()
            return Response(data={"status": "ok", "tags added": tags}, status=status.HTTP_200_OK)
        else:
            return Response(request_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class RemoveTagsView(APIView):
    permission_classes = [IsAuthenticated]
    serializer_class = SetTagsRequestSerializer

    @staticmethod
    def post(request):
        request_serializer = SetTagsRequestSerializer(data=request.data)
        if request_serializer.is_valid():
            tags = request_serializer.data.get('tags').split(', ')
            current_user = UserProfile.objects.get(user=request.user)
            for tag in tags:
                current_user.notification_tags.remove(tag)
            current_user.save()
            return Response(data={"status": "ok", "tags removed": tags}, status=status.HTTP_200_OK)
        else:
            return Response(request_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def api_root(request):
    return Response({
        'all profiles': reverse('all-profiles', request=request),
    })
