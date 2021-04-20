from rest_framework.decorators import api_view
from rest_framework.views import Response
from .models import UserProfile
from config import RANKS, RANKS_TO_POINTS, MAX_POINTS


def _get_rank_for_points(points: int):
    if points > MAX_POINTS:
        points = MAX_POINTS
    elif points < 0:
        points = 0

    for i in RANKS_TO_POINTS:
        if points in RANKS_TO_POINTS[i]:
            return i, RANKS_TO_POINTS[i]


def update_user_points(user, rank_points: int):
    user = UserProfile.objects.get(user=user)
    current_points = user.points

    current_rank, current_range = _get_rank_for_points(current_points)

    current_points += rank_points
    if current_points > MAX_POINTS:
        current_points = MAX_POINTS
    elif current_points < 0:
        current_points = 0

    print(current_rank, current_range)
    if current_points > current_range[-1] or current_points < current_range[0]:
        current_rank, _ = _get_rank_for_points(current_points)

    user.points = current_points
    user.rank = f"Rank {current_rank}"

    user.save()
