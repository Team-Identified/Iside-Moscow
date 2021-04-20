"""Project configuration and API keys"""

from collections import namedtuple

NEWS_API_KEY = "8c173fd5b56842b9a85fd82c9c3faa6c"
# NEWS_API_KEY = '02369d7fd09a423f844efcf623727c7a'
# NEWS_API_KEY = 'fe8b1d6a7f0b4c16b8e37cf9780dd93a'

QUADTREE_CAPACITY = 50  # objects per quadrant

NEWS_UPDATE_FREQ = 1  # days
NEWS_MAX_AGE = 30  # days
NEWS_COUNTER = 100
NEWS_PAGINATION = 10  # articles per page

GEO_OBJECTS_SEARCH_SIMILARITY = 80
GEO_OBJECTS_SEARCH_MAX_RESULTS = 30

RankInfo = namedtuple("RankInfo", ("en_name", "ru_name", "score_range"))

# TODO: update rank points
RANKS_TO_POINTS = {
    1: list(range(0, 6)),
    2: list(range(5, 11)),
    3: list(range(10, 16)),
    4: list(range(15, 21)),
    5: list(range(20, 26)),
    6: list(range(25, 31)),
    7: list(range(30, 36)),
    8: list(range(35, 41)),
    9: list(range(40, 46)),
    10: list(range(45, 51)),
}

MAX_POINTS = 50

RANKS = {
    1: RankInfo("Newbie", "Новичок", RANKS_TO_POINTS[1]),
    2: RankInfo("Amateur", "Любитель", RANKS_TO_POINTS[2]),
    3: RankInfo("Intermediate", "", RANKS_TO_POINTS[3]),  # TODO: pick normal translation or change en name
    4: RankInfo("Advanced", "Продвинутый", RANKS_TO_POINTS[4]),
    5: RankInfo("Expert", "Эксперт", RANKS_TO_POINTS[5]),
    6: RankInfo("Master", "Мастер", RANKS_TO_POINTS[6]),
    7: RankInfo("Enlightened", "Просветленный", RANKS_TO_POINTS[7]),
    8: RankInfo("Guru", "Гуру", RANKS_TO_POINTS[8]),
    9: RankInfo("Doka", "Дока", RANKS_TO_POINTS[9]),
    10: RankInfo("Godlike", "Богоподобный", RANKS_TO_POINTS[10]),
}
