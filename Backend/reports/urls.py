from django.urls import path
from reports import views

urlpatterns = [
    path("", views.api_root),
    path("all/", views.ReportCreateListView.as_view(), name="reports-all"),
    path("change/", views.ReportRetrieveUpdateDestroyView.as_view(), name="reports-change"),
    path("get_for_user/", views.GetReportsForUserView.as_view(), name="reports-get_for_user"),
]
