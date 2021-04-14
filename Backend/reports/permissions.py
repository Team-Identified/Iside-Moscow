from rest_framework import permissions
from rest_framework.permissions import SAFE_METHODS


class ReportsMainPermission(permissions.BasePermission):

    def has_object_permission(self, request, view, obj):

        print(request.method)

        if request.method == "GET":
            return request.user.is_authenticated
        if request.method == "POST":
            return True
        if request.method == "PATCH":
            return request.user.is_authenticated and \
                   (request.user.is_staff or obj.user == request.user)
        if request.method == "DELETE":
            return request.user.is_authenticated and  \
                   (request.user.is_staff or obj.user == request.user)

        return request in SAFE_METHODS
