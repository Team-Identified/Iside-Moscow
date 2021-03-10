from django.urls import path, include
from rest_framework import routers
from authorization import views

router = routers.DefaultRouter()
router.register(r'users', views.UserViewSet)
router.register(r'groups', views.GroupViewSet)

urlpatterns = [
    path('', include(router.urls), name='auth-home'),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
]
