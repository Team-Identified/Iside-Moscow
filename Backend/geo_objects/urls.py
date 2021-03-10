from django.urls import path, include
from geo_objects import views
from rest_framework.routers import DefaultRouter

# Create a router and register our viewsets with it.
router = DefaultRouter()
router.register(r'geo_object-list', views.GeoObjectViewSet)

urlpatterns = [
    path('', include(router.urls), name='geo_root'),
]
