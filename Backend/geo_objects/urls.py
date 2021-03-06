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
    path('nearby_object_notification', views.NearbyObjectNotificationView.as_view(), name='check_nearby_notification'),
    path('my_explorations', views.MyExplorationsView.as_view(), name='my_explorations'),
    path('last_exploration', views.GetLastExploredObject.as_view(), name='last_exploration'),
    path('my_stats', views.MyStatsView.as_view(), name='my_stats'),
    path('search', views.SearchObjectsView.as_view(), name='geoobjects-search'),
]
