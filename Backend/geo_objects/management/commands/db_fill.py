from math import floor
from django.core.management.base import BaseCommand
import json
from geo_objects.models import GeoObject


class Command(BaseCommand):
    def handle(self, *args, **options):
        GeoObject.objects.all().filter(contributor=None).delete()
        with open('MoscowObjects.json', encoding='utf-8-sig') as json_file:
            data_list = json.load(json_file)
        for index, data in enumerate(data_list, start=1):
            progress = floor((index / len(data_list)) * 100)
            print(f'Data base fill {progress}% Done')

            obj = GeoObject(
                category=data['category'],
                name_ru=data['name-ru'],
                name_en=data['name-en'],
                wiki_ru=data['wiki-ru'],
                wiki_en=data['wiki-en'],
                image_url=data['image-url'],
                address=data['address'],
                coordinates=data['coordinates'],
                approved=True,
            )
            obj.save()
        print(f'Data base filled successfully!')
