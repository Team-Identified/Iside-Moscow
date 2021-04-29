# Generated by Django 3.1.7 on 2021-03-21 19:43

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('authorization', '0003_auto_20210321_2225'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userprofile',
            name='last_login',
        ),
        migrations.RemoveField(
            model_name='userprofile',
            name='password',
        ),
        migrations.AddField(
            model_name='userprofile',
            name='date_joined',
            field=models.DateTimeField(auto_now_add=True, null=True),
        ),
        migrations.AddField(
            model_name='userprofile',
            name='user',
            field=models.OneToOneField(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='profile', to=settings.AUTH_USER_MODEL),
        ),
    ]