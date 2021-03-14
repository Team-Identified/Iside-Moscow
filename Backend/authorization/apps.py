from django.apps import AppConfig


class AuthorizationConfig(AppConfig):
    name = 'authorization'

    def ready(self):
        import authorization.signals
