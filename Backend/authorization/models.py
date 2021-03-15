from django.db import models
from django.contrib.auth.models import User


# Создайте свои модели здесь.

LANGUAGE_CHOICES = [
    ('RU', 'Russian'),
    ('EN', 'English'),
]


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    date_joined = models.DateTimeField(auto_now_add=True)
    language = models.CharField(choices=LANGUAGE_CHOICES, default='English', max_length=100)

    def __str__(self):
        return self.user.username
