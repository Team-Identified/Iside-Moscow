# Generated by Django 3.1.7 on 2021-03-21 18:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('geo_objects', '0003_geoobject_approved'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='geoobject',
            name='coordinates',
        ),
        migrations.AddField(
            model_name='geoobject',
            name='latitude',
            field=models.FloatField(default=0),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='geoobject',
            name='longitude',
            field=models.FloatField(default=0.0),
            preserve_default=False,
        ),
    ]
