from django.db import models
from django.contrib.auth.models import User


# Создайте свои модели здесь.

LANGUAGE_CHOICES = [
    ('RU', 'Russian'),
    ('EN', 'English'),
]

RANK_CHOICES = [
    ('R1', 'Rank 1'),
    ('R2', 'Rank 2'),
    ('R3', 'Rank 3'),
    ('R4', 'Rank 4'),
    ('R5', 'Rank 5'),
    ('R6', 'Rank 6'),
    ('R7', 'Rank 7'),
    ('R8', 'Rank 8'),
    ('R9', 'Rank 8'),
    ('R10', 'Rank 10'),
]


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    language = models.CharField(choices=LANGUAGE_CHOICES, default='English', max_length=100)
    points = models.IntegerField(default=0)
    rank = models.CharField(choices=RANK_CHOICES, default='Rank 1', max_length=100)

    def __str__(self):
        return self.user.username
