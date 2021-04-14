from django.urls import path
from reports.views import ReportViewSet, api_root


create_view = ReportViewSet.as_view({"post": "create"})
list_view = ReportViewSet.as_view({"get": "list"})
retrieve_destroy_view = ReportViewSet.as_view(
    {
        "get": "retrieve",
        "delete": "destroy"
    }
)
update_view = ReportViewSet.as_view({"put": "update"})


urlpatterns = [
    path("", api_root, name="reports-root"),
    path("new/", create_view, name="reports-create"),
    path("all/", list_view, name="reports-all"),
    path("<int:pk>/", retrieve_destroy_view, name="reports-retrieve_update_destroy"),
    path("change/<int:pk>/", update_view, name="reports-change"),
]
