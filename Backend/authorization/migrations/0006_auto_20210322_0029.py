# Generated by Django 3.1.7 on 2021-03-21 21:29

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('authorization', '0005_auto_20210321_2243'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userprofile',
            name='date_joined',
        ),
        migrations.AddField(
            model_name='userprofile',
            name='points',
            field=models.IntegerField(default=0),
        ),
        migrations.AddField(
            model_name='userprofile',
            name='rank',
            field=models.CharField(choices=[('R1', 'Rank 1'), ('R2', 'Rank 2'), ('R3', 'Rank 3'), ('R4', 'Rank 4'), ('R5', 'Rank 5'), ('R6', 'Rank 6'), ('R7', 'Rank 7'), ('R8', 'Rank 8'), ('R9', 'Rank 8'), ('R10', 'Rank 10')], default='Rank 1', max_length=100),
        ),
    ]