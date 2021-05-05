import pytest
from django.contrib.auth.models import User
from rest_framework.test import APIRequestFactory, force_authenticate

from .views import GetNews


@pytest.mark.django_db
def test_get():
    user = User(username="admin", is_superuser=True, is_staff=True)
    user.save()
    request = APIRequestFactory().get(f"/news/get_news", {})
    force_authenticate(request, user=User.objects.get(username="admin"))
    data = GetNews.as_view()(request, page=1).data

    assert data["status"] == "ok" and\
           data["page"] == 1 and\
           len(data["articles"]) != 0
