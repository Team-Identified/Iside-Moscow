from django.core.management.base import BaseCommand
from geo_objects.models import *
import geo_objects.models as models
from math import floor
from config import QUADTREE_CAPACITY
from geo_objects.management.commands.visualize_quadtree import visualize
import json


def clear_space():
    models.Point.objects.all().delete()
    models.Rectangle.objects.all().delete()
    models.GeoPoint.objects.all().delete()
    models.QuadTree.objects.all().delete()


def get_bounds(geo_objects):
    min_x = min_y = 1e9
    max_x = max_y = -1e9
    for geo_object in geo_objects:
        min_x = min(min_x, geo_object.latitude)
        max_x = max(max_x, geo_object.latitude)
        min_y = min(min_y, geo_object.longitude)
        max_y = max(max_y, geo_object.longitude)
    min_x -= 0.1
    min_y -= 0.1
    max_x += 0.1
    max_y += 0.1
    x = min_x
    y = min_y
    width = max_x - min_x
    height = max_y - min_y
    width = max(width, height)
    return x, y, width, width


def contains(rectangle, point):
    left = rectangle.x
    right = rectangle.x + rectangle.width
    top = rectangle.y
    bottom = rectangle.y + rectangle.height
    pos_x = point.x
    pos_y = point.y

    if left < pos_x <= right and top < pos_y <= bottom:
        return True
    else:
        return False


def insert(geo_object, quad_tree):
    if models.GeoPoint.objects.filter(area=quad_tree.boundary).count() < quad_tree.capacity and not quad_tree.divided:
        position = models.Point(x=geo_object.latitude, y=geo_object.longitude)
        position.save()
        
        new_geo_point = models.GeoPoint(object=geo_object, position=position, area=quad_tree.boundary)
        new_geo_point.save()
    else:
        if not quad_tree.divided:
            x = quad_tree.boundary.x
            y = quad_tree.boundary.y
            width = quad_tree.boundary.width / 2
            height = quad_tree.boundary.height / 2

            top_left_boundary = models.Rectangle(x=x, y=y, width=width, height=height)
            top_right_boundary = models.Rectangle(x=(x + width), y=y, width=width, height=height)
            bottom_left_boundary = models.Rectangle(x=x, y=(y + height), width=width, height=height)
            bottom_right_boundary = models.Rectangle(x=(x + width), y=(y + height), width=width, height=height)
            top_left_boundary.save()
            top_right_boundary.save()
            bottom_left_boundary.save()
            bottom_right_boundary.save()

            top_left_qt = models.QuadTree(boundary=top_left_boundary, capacity=QUADTREE_CAPACITY)
            top_right_qt = models.QuadTree(boundary=top_right_boundary, capacity=QUADTREE_CAPACITY)
            bottom_left_qt = models.QuadTree(boundary=bottom_left_boundary, capacity=QUADTREE_CAPACITY)
            bottom_right_qt = models.QuadTree(boundary=bottom_right_boundary, capacity=QUADTREE_CAPACITY)
            top_left_qt.save()
            top_right_qt.save()
            bottom_left_qt.save()
            bottom_right_qt.save()

            quad_tree.top_left = top_left_qt
            quad_tree.top_right = top_right_qt
            quad_tree.bottom_left = bottom_left_qt
            quad_tree.bottom_right = bottom_right_qt
            quad_tree.divided = True
            quad_tree.save()

        new_objects = []
        old_points = models.GeoPoint.objects.filter(area=quad_tree.boundary)
        for old_point in old_points:
            old_geo_object = old_point.object
            new_objects.append(old_geo_object)
            old_point.position.delete()
            old_point.delete()
        new_objects.append(geo_object)
        
        for new_object in new_objects:
            position = models.Point(x=new_object.latitude, y=new_object.longitude)
            if contains(quad_tree.top_left.boundary, position):
                insert(new_object, quad_tree.top_left)
            elif contains(quad_tree.top_right.boundary, position):
                insert(new_object, quad_tree.top_right)
            elif contains(quad_tree.bottom_left.boundary, position):
                insert(new_object, quad_tree.bottom_left)
            elif contains(quad_tree.bottom_right.boundary, position):
                insert(new_object, quad_tree.bottom_right)
            else:
                print(new_object)
                print(position)
                print(quad_tree.boundary)
                raise ValueError


class Command(BaseCommand):
    def handle(self, *args, **options):
        clear_space()
        geo_objects = models.GeoObject.objects.all()
        boundary_x, boundary_y, boundary_width, boundary_height = get_bounds(geo_objects)
        qt_boundary = models.Rectangle(x=boundary_x, y=boundary_y, width=boundary_width, height=boundary_height)
        qt_boundary.save()
        quad_tree = models.QuadTree(boundary=qt_boundary, capacity=QUADTREE_CAPACITY, is_root=True)
        quad_tree.save()
        for index, geo_object in enumerate(geo_objects, start=1):
            progress = floor((index / len(geo_objects)) * 100)
            print(f'QuadTree building progress: {progress}% Done')

            insert(geo_object, quad_tree)

        # new_quad_tree = models.QuadTree.objects.get(is_root=True)
        # data = new_quad_tree.get_json()
        # tree = json.loads(data)
        # visualize(tree, geo_objects, save=True, size=1000)
