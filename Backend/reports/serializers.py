from rest_framework import serializers
from .models import Report
from geo_objects.serializers import GeoObjectSerializer


class ReportSerializer(serializers.ModelSerializer):
    user = serializers.ReadOnlyField(source="user.username")
    obj = GeoObjectSerializer(source="obj")

    class Meta:
        model = Report
        fields = [
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
            "creation_datetime"
            "obj",
            "user",
        ]
