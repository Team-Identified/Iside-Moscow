from django.urls import path, include
from geo_objects import views
from rest_framework.routers import DefaultRouter

# Create a router and register our viewsets with it.
router = DefaultRouter()
router.register(r'geo_object-list', views.GeoObjectViewSet)
router.register(r'submitted_geo_object-list', views.SubmittedGeoObjectViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
