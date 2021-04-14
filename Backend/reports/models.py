from django.db import models
from geo_objects.models import GeoObject


class Report(models.Model):
    category_problem = models.BooleanField(default=False)
    ru_name_problem = models.BooleanField(default=False)
    en_name_problem = models.BooleanField(default=False)
    ru_wiki_problem = models.BooleanField(default=False)
    en_wiki_problem = models.BooleanField(default=False)
    image_problem = models.BooleanField(default=False)
    address_problem = models.BooleanField(default=False)
    map_location_problem = models.BooleanField(default=False)
    duplicate_problem = models.BooleanField(default=False)
    other_problem = models.BooleanField(default=False)
    description = models.CharField(max_length=500, default="")
    creation_datetime = models.DateTimeField()
    obj = models.ForeignKey(GeoObject, related_name="reports", on_delete=models.CASCADE)
    user = models.ForeignKey("auth.User", related_name="reports", blank=True, null=True,
                             default=None, on_delete=models.SET_DEFAULT)

    class Meta:
        ordering = ['creation_datetime']

    def __str__(self):
        problems = list()
        if self.map_location_problem:
            problems.append("map location")
        if self.address_problem:
            problems.append("address")
        if self.category_problem:
            problems.append("category")
        if self.ru_name_problem:
            problems.append("russian name")
        if self.en_name_problem:
            problems.append("english name")
        if self.ru_wiki_problem:
            problems.append("russian wiki")
        if self.en_wiki_problem:
            problems.append("english wiki")
        if self.image_problem:
            problems.append("image")
        if self.duplicate_problem:
            problems.append("duplicate")
        if self.other_problem:
            problems.append("other problem")

        problems = ", ".join(problems)

        return f"Creator: {self.user}\n"\
            f"Problems list: {problems} \n" + \
            f"Description: {self.description if self.description != '' else 'none'}\n" + \
            f"Creation datetime: {self.creation_datetime}"

