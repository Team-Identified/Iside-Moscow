from django.core.management.base import BaseCommand
import json
from geo_objects.models import GeoObject


class Command(BaseCommand):
    def handle(self, *args, **options):
        GeoObject.objects.all().delete()
        with open('Theatres.json', encoding='utf-8') as json_file:
            data_list = json.load(json_file)
        for data in data_list:
            obj = GeoObject(
                category=data['category'],
                name_ru=data['name-ru'],
                name_en=data['name-en'],
                wiki_ru=data['wiki-ru'],
                wiki_en=data['wiki-en'],
                image_url=data['image-url'],
                address=data['address'],
                coordinates=data['coordinates'],
            )
            obj.save()
