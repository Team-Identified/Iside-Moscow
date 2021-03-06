from django.http import JsonResponse


def status_endpoint(_):
    return JsonResponse({'status': 'active'})
