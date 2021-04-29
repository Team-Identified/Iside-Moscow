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
                name_ru=data['name_ru'],
                name_en=data['name_en'],
                wiki_ru=data['wiki_ru'],
                wiki_en=data['wiki_en'],
                image_url=data['image_url'],
                address=data['address'],
                latitude=data['latitude'],
                longitude=data['longitude'],
            )
            obj.save()
            obj.tags.set(data['category'], clear=True)
            obj.save()
        print(f'Data base filled successfully!')
