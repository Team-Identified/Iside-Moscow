# Generated by Django 3.1.7 on 2021-03-14 20:02

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('geo_objects', '0002_auto_20210308_2026'),
    ]

    operations = [
        migrations.AddField(
            model_name='geoobject',
            name='approved',
            field=models.BooleanField(default=False),
        ),
    ]
