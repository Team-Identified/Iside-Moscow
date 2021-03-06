from django.db import models
from django.utils import timezone
from taggit.managers import TaggableManager


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
    ('OT', 'Other'),
]


def get_russian_category(object_category):
    if object_category == "monument":
        return "памятник"
    elif object_category == "theatre":
        return "театр"
    elif object_category == "museum":
        return "музей"
    elif object_category == "government building":
        return "здание правительства"
    elif object_category == "mall":
        return "торговый центр"
    elif object_category == "Red square object":
        return "объект Красной Площади"
    elif object_category == "religious building":
        return "религиозная постройка"
    elif object_category == "restaurant":
        return "ресторан"
    elif object_category == "skyscraper":
        return "небоскрёб"
    elif object_category == "stadium":
        return "стадион"
    elif object_category == "unknown":
        return "неизвестно"
    elif object_category == "other":
        return "другое"
    else:
        return "неизвестная категория"


class GeoObject(models.Model):
    category = models.CharField(choices=CATEGORY_CHOICES, default='Unknown', max_length=100)
    name_ru = models.CharField(max_length=200, default='')
    name_en = models.CharField(max_length=200, default='')
    wiki_ru = models.URLField(max_length=500, null=True, default=None)
    wiki_en = models.URLField(max_length=500, null=True, default=None)
    image_url = models.URLField(max_length=500, null=True, default=None)
    address = models.CharField(max_length=150)
    latitude = models.FloatField(default=0)
    longitude = models.FloatField(default=0)
    contributor = models.ForeignKey('auth.User', related_name='contributed_objects', null=True,
                                    default=None, on_delete=models.SET_NULL)
    tags = TaggableManager(help_text="A comma-separated list of tags.", blank=False)

    def __str__(self):
        return f'{self.category}: {self.name_ru}/{self.name_en}'

    class Meta:
        ordering = ['category', 'name_ru']


class SubmittedGeoObject(models.Model):
    category = models.CharField(choices=CATEGORY_CHOICES, default='Unknown', max_length=100)
    name_ru = models.CharField(max_length=200)
    name_en = models.CharField(max_length=200, null=True, default=None, blank=True)
    wiki_ru = models.URLField(max_length=500, null=True, default=None, blank=True)
    wiki_en = models.URLField(max_length=500, null=True, default=None, blank=True)
    image_url = models.URLField(max_length=500, null=True, default=None, blank=True)
    address = models.CharField(max_length=150, null=True, default=None, blank=True)
    latitude = models.FloatField(null=True, default=None, blank=True)
    longitude = models.FloatField(null=True, default=None, blank=True)
    contributor = models.ForeignKey('auth.User', related_name='submitted_objects', null=True,
                                    default=None, on_delete=models.SET_NULL)

    def __str__(self):
        return f'SUBMITTED: {self.category}: {self.name_ru}/{self.name_en}'

    class Meta:
        ordering = ['category']


class UserObjectExploration(models.Model):
    user = models.ForeignKey('auth.User', related_name='explored_objects', null=True,
                             default=None, on_delete=models.CASCADE)
    geo_object = models.ForeignKey(GeoObject, on_delete=models.CASCADE)
    created = models.DateTimeField()

    def save(self, *args, **kwargs):
        if not self.id:
            self.created = timezone.now()
        return super(UserObjectExploration, self).save(*args, **kwargs)


class Point(models.Model):
    x = models.FloatField()
    y = models.FloatField()

    def __str__(self):
        return f'X: {self.x}, Y: {self.y}'


class Rectangle(models.Model):
    x = models.FloatField()
    y = models.FloatField()
    width = models.FloatField()
    height = models.FloatField()

    def __str__(self):
        return f'"X": {self.x}, "Y": {self.y}, "Width": {self.width}, "Height": {self.height}'


class GeoPoint(models.Model):
    object = models.ForeignKey(GeoObject, on_delete=models.CASCADE)
    position = models.ForeignKey(Point, on_delete=models.CASCADE)
    area = models.ForeignKey(Rectangle, on_delete=models.CASCADE)


class QuadTree(models.Model):
    boundary = models.ForeignKey(Rectangle, on_delete=models.CASCADE)
    capacity = models.IntegerField(default=20)
    divided = models.BooleanField(default=False)
    is_root = models.BooleanField(default=False)
    top_left = models.ForeignKey('self', on_delete=models.SET_DEFAULT,
                                 null=True, default=None, related_name='TopLeft')
    top_right = models.ForeignKey('self', on_delete=models.SET_DEFAULT,
                                  null=True, default=None, related_name='TopRight')
    bottom_left = models.ForeignKey('self', on_delete=models.SET_DEFAULT,
                                    null=True, default=None, related_name='BottomLeft')
    bottom_right = models.ForeignKey('self', on_delete=models.SET_DEFAULT,
                                     null=True, default=None, related_name='BottomRight')

    def get_json(self):
        if not self.divided:
            return f'{{"Boundary": {{{self.boundary.__str__()}}}}}'
        else:
            return f'{{"Boundary": {{{self.boundary}}}, ' \
                   f'"TL": {self.top_left.get_json()}, ' \
                   f'"TR": {self.top_right.get_json()}, ' \
                   f'"BL": {self.bottom_left.get_json()}, ' \
                   f'"BR": {self.bottom_right.get_json()}}}'

    def __str__(self):
        return f'QuadTree: Boundary ({self.boundary.__str__()}), Divided: {self.divided}'


class SearchRequest(models.Model):
    search_query = models.CharField(max_length=300)


class LocationRequest(models.Model):
    latitude = models.FloatField()
    longitude = models.FloatField()
