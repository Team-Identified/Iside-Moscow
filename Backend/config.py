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

RankInfo = namedtuple("RankInfo", ("rank_name", "score_range"))
MAX_POINTS = 69420
RANKS = [
    RankInfo("Новичок", {"lower": 0, "upper": 10}),
    RankInfo("Любитель", {"lower": 11, "upper": 30}),
    RankInfo("Знаток", {"lower": 31, "upper": 90}),
    RankInfo("Продвинутый", {"lower": 91, "upper": 180}),
    RankInfo("Эксперт", {"lower": 181, "upper": 300}),
    RankInfo("Мастер", {"lower": 301, "upper": 450}),
    RankInfo("Просветленный", {"lower": 451, "upper": 650}),
    RankInfo("Гуру", {"lower": 651, "upper": 900}),
    RankInfo("Дока", {"lower": 901, "upper": 1200}),
    RankInfo("Богоподобный", {"lower": 1201, "upper": MAX_POINTS}),
]
