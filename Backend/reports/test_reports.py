import pytest
from django.contrib.auth.models import User
from rest_framework.test import APIRequestFactory, force_authenticate
from .views import ReportViewSet
from geo_objects.models import GeoObject

from geo_objects.models import QuadTree, Rectangle


@pytest.mark.django_db
def test_post():

    request = APIRequestFactory().post("/reports/new/", {
        "category_problem": True,
        "ru_name_problem": False,
        "en_name_problem": False,
        "ru_wiki_problem": False,
        "en_wiki_problem": False,
        "image_problem": False,
        "address_problem": False,
        "map_location_problem": False,
        "duplicate_problem": False,
        "other_problem": False,
        "description": "test",
        "obj_id": 1
    })
    user = User(username="admin")
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
    obj = GeoObject(
        category="Monument",
        name_ru="test",
        name_en="test",
        wiki_ru="https://ru.wikipedia.org",
        wiki_en="https://en.wikipedia.org",
        image_url="https://memepedia.ru/wp-content/uploads/2019/07/chilipizdrik-1.png",
        address="test"
    )
    obj.save()
    data = ReportViewSet.as_view({
        "post": "create"
    })(request).data
    assert data == {
        "status": "ok"
        }


@pytest.mark.django_db
def test_get():

    user = User(username="admin", is_superuser=True, is_staff=True)
    user.save()
    request = APIRequestFactory().get(f"/reports/all", {})
    force_authenticate(request, user=User.objects.get(username="admin"))
    q_tree = QuadTree(
        capacity=50,
        divided=False,
        is_root=True,
        boundary_id=1
    )
    q_tree.save()
    rect = Rectangle(
        x=999999999.9,
        y=999999999.9,
        width=-1999999999.8,
        height=-1999999999.8
    )
    rect.save()
    data = ReportViewSet.as_view({
        "get": "list"
    })(request).data
    assert data == []

