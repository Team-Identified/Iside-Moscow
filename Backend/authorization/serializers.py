from django.contrib.auth.models import User
from rest_framework import serializers
from .models import UserProfile, SetTagsRequest
from taggit_serializer.serializers import (TagListSerializerField,
                                           TaggitSerializer)


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ['id', 'is_staff', 'is_superuser', 'is_active', 'date_joined', 'email', 'username']


class UserProfileSerializer(TaggitSerializer, serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    points = serializers.ReadOnlyField()
    rank = serializers.ReadOnlyField()
    notification_tags = TagListSerializerField(read_only=True)

    class Meta:
        model = UserProfile
        fields = ['id', 'url', 'user', 'language', 'points', 'rank', 'notification_tags']


class ShortUserProfileSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserProfile
        fields = ['id', 'url']


class SetTagsRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = SetTagsRequest
        fields = ['tags']
