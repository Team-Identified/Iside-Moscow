# Generated by Django 3.2 on 2021-05-04 19:45

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('geo_objects', '0010_quadtree_is_root'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='geoobject',
            options={'ordering': ['category', 'name_ru']},
        ),
    ]
