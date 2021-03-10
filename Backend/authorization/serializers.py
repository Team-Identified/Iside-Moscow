from django.contrib.auth.models import User, Group
from rest_framework import serializers
from geo_objects.models import GeoObject


class UserSerializer(serializers.HyperlinkedModelSerializer):
    contributed_objects = serializers.PrimaryKeyRelatedField(many=True, queryset=GeoObject.objects.all())

    class Meta:
        model = User
        fields = ['id', 'url', 'username', 'email', 'is_staff', 'groups', 'contributed_objects']


class GroupSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Group
        fields = ['url', 'name']
