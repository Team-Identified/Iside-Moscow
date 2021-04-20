from django.db import models
from django.contrib.auth.models import User
from config import RANKS


# Создайте свои модели здесь.

LANGUAGE_CHOICES = [
    ('RU', 'Russian'),
    ('EN', 'English'),
]


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    language = models.CharField(choices=LANGUAGE_CHOICES, default='English', max_length=100)
    points = models.IntegerField(default=0)
    rank = models.CharField(default=RANKS[0].rank_name, max_length=100)

    def __str__(self):
        return self.user.username
