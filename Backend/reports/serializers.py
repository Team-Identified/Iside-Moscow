from rest_framework import serializers
from rest_framework.generics import get_object_or_404
from geo_objects.models import GeoObject
from .models import Report
from geo_objects.serializers import GeoObjectSerializer
import datetime


class ReportViewSerializer(serializers.ModelSerializer):
    user = serializers.ReadOnlyField(source="user.username")
    obj = GeoObjectSerializer(read_only=True)

    class Meta:
        model = Report
        fields = [
            "id",
            "category_problem",
            "ru_name_problem",
            "en_name_problem",
            "ru_wiki_problem",
            "en_wiki_problem",
            "image_problem",
            "address_problem",
            "map_location_problem",
            "duplicate_problem",
            "other_problem",
            "description",
            "creation_datetime",
            "obj",
            "user",
        ]


class ReportCreateSerializer(serializers.ModelSerializer):
    user = serializers.ReadOnlyField(source="user.username")
    obj_id = serializers.IntegerField()

    class Meta:
        model = Report
        fields = [
            "id",
            "category_problem",
            "ru_name_problem",
            "en_name_problem",
            "ru_wiki_problem",
            "en_wiki_problem",
            "image_problem",
            "address_problem",
            "map_location_problem",
            "duplicate_problem",
            "other_problem",
            "description",
            "obj_id",
            "user",
        ]

    def create(self, validated_data):
        obj_id = validated_data.pop('obj_id')
        queryset = GeoObject.objects.all()
        geo_object = get_object_or_404(queryset, pk=obj_id)
        created = datetime.datetime.now()
        new_report = Report.objects.create(**validated_data, obj=geo_object, creation_datetime=created)
        return new_report
