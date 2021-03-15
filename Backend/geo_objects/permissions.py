from rest_framework import permissions


class IsContributorOrStaffOrReadOnly(permissions.BasePermission):
    """
    Custom permission to only allow contributors of an object to edit it.
    """

    def has_object_permission(self, request, view, obj):
        # Read permissions are allowed to any request,
        # so we'll always allow GET, HEAD or OPTIONS requests.
        if request.method in permissions.SAFE_METHODS:
            return True

        # Write permissions are only allowed to the owner of the snippet.
        if (obj.contributor == request.user and not obj.approved) or request.user.is_staff:
            return True
        else:
            return False
