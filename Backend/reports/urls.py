from django.urls import path
from .views import ReportCreateListView,\
    ReportRetrieveUpdateDestroyView,\
    GetReportsForUserView

urlpatterns = [
    path("all/", ReportCreateListView.as_view(), name="all"),
    path("change/", ReportRetrieveUpdateDestroyView.as_view(), name="change"),
    path("get_for_user/", GetReportsForUserView.as_view(), name="get_for_user"),
]
