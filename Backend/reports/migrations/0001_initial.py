# Generated by Django 3.1.7 on 2021-04-12 18:00

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('geo_objects', '0004_auto_20210325_2323'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Report',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('category_problem', models.BooleanField(default=False)),
                ('ru_name_problem', models.BooleanField(default=False)),
                ('en_name_problem', models.BooleanField(default=False)),
                ('ru_wiki_problem', models.BooleanField(default=False)),
                ('en_wiki_problem', models.BooleanField(default=False)),
                ('image_problem', models.BooleanField(default=False)),
                ('address_problem', models.BooleanField(default=False)),
                ('map_location_problem', models.BooleanField(default=False)),
                ('duplicate_problem', models.BooleanField(default=False)),
                ('other_problem', models.BooleanField(default=False)),
                ('description', models.CharField(default='', max_length=500)),
                ('creation_datetime', models.DateTimeField()),
                ('obj', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='reports', to='geo_objects.geoobject')),
                ('user', models.ForeignKey(default=None, on_delete=django.db.models.deletion.SET_DEFAULT, related_name='reports', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['creation_datetime'],
            },
        ),
    ]
