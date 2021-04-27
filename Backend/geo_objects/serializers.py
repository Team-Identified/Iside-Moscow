from rest_framework import serializers
from geo_objects.models import GeoObject, SubmittedGeoObject, SearchRequest, LocationRequest, UserObjectExploration


class GeoObjectSerializer(serializers.ModelSerializer):
    contributor = serializers.ReadOnlyField(source='contributor.username')

    class Meta:
        model = GeoObject
        fields = [
            'id',
            'url',
            'category',
            'name_ru',
            'name_en',
            'wiki_ru',
            'wiki_en',
            'image_url',
            'address',
            'latitude',
            'longitude',
            'contributor',
        ]


class SubmittedGeoObjectSerializer(serializers.ModelSerializer):
    contributor = serializers.ReadOnlyField(source='contributor.username')
    url = serializers.HyperlinkedIdentityField(view_name="submitted-detail")

    class Meta:
        model = SubmittedGeoObject
        fields = [
            'id',
            'url',
            'category',
            'name_ru',
            'name_en',
            'wiki_ru',
            'wiki_en',
            'image_url',
            'address',
            'latitude',
            'longitude',
            'contributor',
        ]


class SearchRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = SearchRequest
        fields = ['search_query']


class LocationRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = LocationRequest
        fields = ['latitude', 'longitude']


class UserObjectExplorationSerializer(serializers.ModelSerializer):
    user = serializers.ReadOnlyField(source='user.username')
    geo_object = serializers.ReadOnlyField(source='geo_object.name_ru')

    class Meta:
        model = UserObjectExploration
        fields = [
            'id',
            'user',
            'geo_object',
            'created',
        ]
