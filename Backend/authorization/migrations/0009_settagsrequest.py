# Generated by Django 3.2 on 2021-05-01 18:17

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('authorization', '0008_userprofile_notification_tags'),
    ]

    operations = [
        migrations.CreateModel(
            name='SetTagsRequest',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('tags', models.CharField(max_length=500)),
            ],
        ),
    ]
