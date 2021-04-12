# Generated by Django 3.1.7 on 2021-04-12 19:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('geo_objects', '0004_auto_20210325_2323'),
    ]

    operations = [
        migrations.AlterField(
            model_name='geoobject',
            name='category',
            field=models.CharField(choices=[('MN', 'Monument'), ('TR', 'Theatre'), ('MS', 'Museum'), ('GB', 'Government building'), ('ML', 'Mall'), ('RS', 'Red Square object'), ('RB', 'Religious building'), ('RT', 'Restaurant'), ('SS', 'Skyscraper'), ('SD', 'Stadium'), ('UK', 'Unknown'), ('OT', 'Other')], default='Unknown', max_length=100),
        ),
        migrations.AlterField(
            model_name='submittedgeoobject',
            name='category',
            field=models.CharField(choices=[('MN', 'Monument'), ('TR', 'Theatre'), ('MS', 'Museum'), ('GB', 'Government building'), ('ML', 'Mall'), ('RS', 'Red Square object'), ('RB', 'Religious building'), ('RT', 'Restaurant'), ('SS', 'Skyscraper'), ('SD', 'Stadium'), ('UK', 'Unknown'), ('OT', 'Other')], default='Unknown', max_length=100),
        ),
        migrations.AlterField(
            model_name='submittedgeoobject',
            name='name_ru',
            field=models.CharField(default='', max_length=200),
        ),
    ]
