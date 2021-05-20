import pytest
from django.contrib.auth.models import User
from rest_framework.test import APIRequestFactory, force_authenticate
from .views import GeoObjectViewSet, SubmittedGeoObjectViewSet
from .models import QuadTree, Rectangle


# Create your tests here.


@pytest.mark.django_db
def test_list():

    request = APIRequestFactory().get("/geo_objects/geo_object-list/", {})
    user = User(username="admin", is_superuser=True, is_staff=True)
    user.save()
    force_authenticate(request, user=User.objects.get(username="admin"))
    rect = Rectangle(
        x=999999999.9,
        y=999999999.9,
        width=-1999999999.8,
        height=-1999999999.8
    )
    rect.save()
    q_tree = QuadTree(
        capacity=50,
        divided=False,
        is_root=True,
        boundary_id=1
    )
    q_tree.save()
    data = GeoObjectViewSet.as_view({
        "get": "list"
    })(request).data
    assert data == {
        "count": 0,
        "next": None,
        "previous": None,
        "results": []
    }


@pytest.mark.django_db
def test_post():

    request = APIRequestFactory().post("/geo_objects/submitted_geo_objects/", {
        "category": "MN",
        "name_ru": "test",
        "name_en": "test",
        "wiki_ru": "https://ru.wikipedia.org",
        "wiki_en": "https://en.wikipedia.org",
        "image_url": "https://memepedia.ru/wp-content/uploads/2019/07/chilipizdrik-1.png",
        "address": "test",
        "latitude": 0.0,
        "longtitude": 0.0,
        "tags": '["test1", "test2"]'
    })
    user = User(username="admin", is_superuser=True, is_staff=True)
    user.save()
    force_authenticate(request, user=User.objects.get(username="admin"))
    rect = Rectangle(
        x=999999999.9,
        y=999999999.9,
        width=-1999999999.8,
        height=-1999999999.8
    )
    rect.save()
    q_tree = QuadTree(
        capacity=50,
        divided=False,
        is_root=True,
        boundary_id=1
    )
    q_tree.save()
    data = GeoObjectViewSet.as_view({
        "post": "create"
    })(request).data
    data["tags"] = set(data["tags"])
    assert data == {
        'id': 1,
        'url': 'http://testserver/geo_objects/geo_object-list/1/',
        'category': 'MN',
        'name_ru': 'test',
        'name_en': 'test',
        'wiki_ru': 'https://ru.wikipedia.org',
        'wiki_en': 'https://en.wikipedia.org',
        'image_url': 'https://memepedia.ru/wp-content/uploads/2019/07/chilipizdrik-1.png',
        'address': 'test',
        'latitude': 0.0,
        'longitude': 0.0,
        "tags": {"test1", "test2"}}
