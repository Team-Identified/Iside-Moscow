from django.urls import path
from reports.views import ReportViewSet, api_root


create_view = ReportViewSet.as_view(
    {
        "post": "create"
    }
)

list_view = ReportViewSet.as_view(
    {
        "get": "list"
    }
)

retrieve_update_delete_view = ReportViewSet.as_view(
    {
        "get": "retrieve",
        "patch": "partial_update",
        "delete": "destroy"
    }
)


urlpatterns = [
    path("", api_root, name="reports-root"),
    path("new/", create_view, name="reports-create"),
    path("all/", list_view, name="reports-all"),
    path("<int:pk>/", retrieve_update_delete_view,
         name="reports-retrieve_update_destroy"),
]
