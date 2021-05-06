import pytest
from django.contrib.auth.models import User
from rest_framework.test import APIRequestFactory, force_authenticate

from .views import UserProfileDetailView


@pytest.mark.django_db
def test_get():
    user = User(username="admin", is_superuser=True, is_staff=True)
    user.save()
    request = APIRequestFactory().get(f"/auth/users/", {})
    force_authenticate(request, user=User.objects.get(username="admin"))
    data = UserProfileDetailView.as_view()(request, pk=1).data

    data["user"] = dict(data["user"])
    print(data)

    assert data == {'id': 1,
                    'url': 'http://testserver/accounts/profile/1',
                    'user': {
                                'id': 1,
                                'is_staff': True,
                                'is_superuser': True,
                                'is_active': True,
                                'date_joined': user.date_joined.strftime("%Y-%m-%dT%H:%M:%S.%fZ"),
                                'email': '',
                                'username': 'admin'
                    },
                    'language': 'English',
                    'points': 0,
                    'rank': 'Новичок'}
