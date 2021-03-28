from geo_objects.models import QuadTree, Point, GeoPoint
from geo_objects.management.commands.build_quadtree import contains
from geo_objects.serializers import GeoObjectSerializer
import math


def get_coordinates_distance(pos1, pos2):
    lat1, lon1 = pos1
    lat2, lon2 = pos2

    r = 6371e3  # metres
    f1 = lat1 * math.pi / 180  # φ, λ in radians
    f2 = lat2 * math.pi / 180
    df = (lat2 - lat1) * math.pi / 180
    dy = (lon2 - lon1) * math.pi / 180

    a = math.sin(df / 2) * math.sin(df / 2) + math.cos(f1) * math.cos(f2) * math.sin(dy / 2) * math.sin(dy / 2)
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    d = r * c  # in metres
    d = round(d)
    return d


def get_nearby_objects(request, point):
    pos_x, pos_y = point
    position = Point(x=pos_x, y=pos_y)
    
    current_quadtree = QuadTree.objects.all().first()
    
    while current_quadtree.divided:
        if contains(current_quadtree.top_left.boundary, position):
            current_quadtree = current_quadtree.top_left
        elif contains(current_quadtree.top_right.boundary, position):
            current_quadtree = current_quadtree.top_right
        elif contains(current_quadtree.bottom_left.boundary, position):
            current_quadtree = current_quadtree.bottom_left
        elif contains(current_quadtree.bottom_right.boundary, position):
            current_quadtree = current_quadtree.bottom_right
        else:
            return []

    nearby_points = GeoPoint.objects.filter(area=current_quadtree.boundary)
    nearby_objects = []
    for nearby_point in nearby_points:
        nearby_objects.append(nearby_point.object)

    result = []
    serializer_context = {'request': request}
    for nearby_object in nearby_objects:
        dist = get_coordinates_distance(point, (nearby_object.latitude, nearby_object.longitude))
        serializer = GeoObjectSerializer(instance=nearby_object, context=serializer_context)
        serialized_object = serializer.data
        object_data = {
            # 'id': nearby_object.id,
            # 'category': nearby_object.category,
            # 'name-ru': nearby_object.name_ru,
            # 'name-en': nearby_object.name_en,
            'object': serialized_object,
            'distance': dist,
        }
        result.append(object_data)
    result.sort(key=lambda x: x['distance'])
    return result
