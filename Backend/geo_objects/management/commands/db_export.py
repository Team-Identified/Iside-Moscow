from math import floor
from django.core.management.base import BaseCommand
import json
from geo_objects.models import GeoObject


class Command(BaseCommand):
    def handle(self, *args, **options):
        db_data = list(GeoObject.objects.all().values())
        export_data = []
        for index, element in enumerate(db_data, start=1):
            progress = floor((index / len(db_data)) * 100)
            print(f'Data base fill {progress}% Done')

            export_element = {
                'category': element['category'],
                'name_ru': element['name_ru'],
                'name_en': element['name_en'],
                'wiki_ru': element['wiki_ru'],
                'wiki_en': element['wiki_en'],
                'image_url': element['image_url'],
                'address': element['address'],
                'latitude': element['latitude'],
                'longitude': element['longitude'],
            }
            export_data.append(export_element)
        print('Saving...')
        with open("DBExport.json", 'w', encoding='utf-8') as export_file:
            json.dump(export_data, export_file, indent=2, ensure_ascii=False, sort_keys=True)
        print('Data base exported successfully!')
