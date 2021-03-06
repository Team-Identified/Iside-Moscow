from django.urls import path
from .views import UserProfileListCreateView, UserProfileDetailView, api_root, SetTagsView, RemoveTagsView

urlpatterns = [
    path('', api_root),
    # gets all user profiles and create a new profile
    path("all-profiles", UserProfileListCreateView.as_view(), name="all-profiles"),
    # retrieves profile details of the currently logged in user
    path("profile/<int:pk>", UserProfileDetailView.as_view(), name="userprofile-detail"),
    path("profile/set_tags", SetTagsView.as_view(), name="set-tags"),
    path("profile/remove_tags", RemoveTagsView.as_view(), name="remove-tags"),
]
