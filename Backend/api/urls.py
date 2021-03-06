from django.urls import path
from .views import *


urlpatterns = [
    path('status', status_endpoint),
]
