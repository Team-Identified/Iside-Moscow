from rest_framework import permissions


class AdminOrCreateOnly(permissions.BasePermission):

    def has_object_permission(self, request, view, obj):
        if request.method == "POST":
            return True

        return request.user.is_staff


class AdminOrCreator(permissions.BasePermission):

    def has_object_permission(self, request, view, obj):
        return request.user.is_staff or request.user == obj.user
