from rest_framework import permissions
from rest_framework.permissions import SAFE_METHODS


class ReportsMainPermission(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method == "GET":
            return request.user.is_authenticated
        elif request.method == "POST":
            return True
        elif request.method == "PUT":
            return request.user.is_authenticated and (request.user.is_staff or obj.user == request.user)
        elif request.method == "DELETE":
            print(f'DELETE: {request.user}, {obj.user}')
            return request.user.is_authenticated and (request.user.is_staff or obj.user == request.user)
        else:
            return request in SAFE_METHODS
