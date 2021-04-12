from django.urls import path, include
from geo_objects import views
from rest_framework.routers import DefaultRouter

# Create a router and register our viewsets with it.
router = DefaultRouter()
router.register(r'geo_object-list', views.GeoObjectViewSet)
router.register(r'geo_object_retrieve', views.GeoObjectRetrieveViewSet, basename='geo_object')
router.register(r'submitted_geo_objects', views.SubmittedGeoObjectViewSet, basename='submitted')

urlpatterns = [
    path('', views.APIRootView.as_view()),
    path('', include(router.urls)),
    path('get_nearby_objects', views.GetNearbyObjectsForUserView.as_view(), name='get_nearby'),
]
