from .models import UserProfile
from config import RANKS, MAX_POINTS


def constrain(x: int, lower: int, upper: int) -> int:
    return max(min(upper, x), lower)


def belongs(x: int, score_range: dict) -> bool:
    return score_range['lower'] <= x <= score_range['upper']


def _get_rank_for_points(points: int):
    points = constrain(points, 0, MAX_POINTS)

    for rank in RANKS:
        if belongs(points, rank.score_range):
            return rank


def update_user_points(user, rank_points: int):
    user = UserProfile.objects.get(user=user)
    current_points = user.points

    current_points += rank_points
    current_points = constrain(current_points, 0, MAX_POINTS)
    current_rank = _get_rank_for_points(current_points)

    user.points = current_points
    user.rank = current_rank.rank_name
    user.save()
