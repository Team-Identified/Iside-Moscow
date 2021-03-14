from django.db import models

CATEGORY_CHOICES = [
    ('MN', 'Monument'),
    ('TR', 'Theatre'),
    ('MS', 'Museum'),
    ('GB', 'Government building'),
    ('ML', 'Mall'),
    ('RS', 'Red Square object'),
    ('RB', 'Religious building'),
    ('RT', 'Restaurant'),
    ('SS', 'Skyscraper'),
    ('SD', 'Stadium'),
    ('UK', 'Unknown'),
]


# Create your models here.
class GeoObject(models.Model):
    category = models.CharField(choices=CATEGORY_CHOICES, default='Unknown', max_length=100)
    name_ru = models.CharField(max_length=200, default='')
    name_en = models.CharField(max_length=200, default='')
    wiki_ru = models.CharField(max_length=500, null=True, default=None)
    wiki_en = models.CharField(max_length=500, null=True, default=None)
    image_url = models.CharField(max_length=500, null=True, default=None)
    address = models.CharField(max_length=150)
    coordinates = models.CharField(max_length=100)
    contributor = models.ForeignKey('auth.User', related_name='contributed_objects', null=True,
                                    default=None, on_delete=models.SET_NULL)
    approved = models.BooleanField(default=False)

    def __str__(self):
        return f'{self.category}: {self.name_ru}/{self.name_en}'

    class Meta:
        ordering = ['category']
