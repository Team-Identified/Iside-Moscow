"""Project configuration and API keys"""

from collections import namedtuple

NEWS_API_KEY = "8c173fd5b56842b9a85fd82c9c3faa6c"
# NEWS_API_KEY = '02369d7fd09a423f844efcf623727c7a'
# NEWS_API_KEY = 'fe8b1d6a7f0b4c16b8e37cf9780dd93a'

QUADTREE_CAPACITY = 50  # objects per quadrant

NEARBY_OBJECTS_RADIUS = 2000  # meters
NEARBY_OBJECTS_NOTIFY_RADIUS = 100  # meters
NEARBY_OBJECTS_EXPLORATION_RADIUS = 150  # meters

NEWS_UPDATE_FREQ = 1  # days
NEWS_MAX_AGE = 30  # days
NEWS_COUNTER = 100
NEWS_PAGINATION = 10  # articles per page

GEO_OBJECTS_SEARCH_SIMILARITY = 80
GEO_OBJECTS_SEARCH_MAX_RESULTS = 30


class RankInfo:
    def __init__(self, name: str, lower: int, upper: int):
        self.rank_name = name
        self.score_range = {
            "lower": lower,
            "upper": upper,
        }


MAX_POINTS = 691337
RANKS = [
    RankInfo("Новичок", 0, 14),
    RankInfo("Любитель", 15, 74),
    RankInfo("Знаток", 75, 249),
    RankInfo("Продвинутый", 250, 499),
    RankInfo("Эксперт", 500, 1499),
    RankInfo("Мастер", 1500, 4999),
    RankInfo("Просветленный", 5000, 14999),
    RankInfo("Гуру", 15000, 49999),
    RankInfo("Дока", 50000, 99999),
    RankInfo("Богоподобный", 100000, MAX_POINTS),
]
