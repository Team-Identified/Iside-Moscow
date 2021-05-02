import math
from django.core.management.base import BaseCommand
import geo_objects.models as models
import json
from PIL import Image, ImageDraw
from math import floor


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


def get_pixel(x, y, start_x, start_y, ctp_k):
    result_x = round((x - start_x) * ctp_k)
    result_y = round((y - start_y) * ctp_k)
    return result_x, result_y


def draw_sectors(img, tree, start_x, start_y, ctp_k):
    cx1 = tree['Boundary']['X']
    cy1 = tree['Boundary']['Y']
    cx2 = cx1 + tree['Boundary']['Width']
    cy2 = cy1 + tree['Boundary']['Height']

    x1, y1 = get_pixel(cx1, cy1, start_x, start_y, ctp_k)
    x2, y2 = get_pixel(cx2, cy2, start_x, start_y, ctp_k)
    shape = [(x1, y1), (x2, y2)]

    drawer = ImageDraw.Draw(img)
    drawer.rectangle(shape, outline="green")
    # print(shape)

    if 'TL' in tree:
        img = draw_sectors(img, tree['TL'], start_x, start_y, ctp_k)
    if 'TR' in tree:
        img = draw_sectors(img, tree['TR'], start_x, start_y, ctp_k)
    if 'BL' in tree:
        img = draw_sectors(img, tree['BL'], start_x, start_y, ctp_k)
    if 'BR' in tree:
        img = draw_sectors(img, tree['BR'], start_x, start_y, ctp_k)

    return img


def draw_points(img, points, start_x, start_y, ctp_k):
    drawer = ImageDraw.Draw(img)

    for point in points:
        cx = point.latitude
        cy = point.longitude
        x, y = get_pixel(cx, cy, start_x, start_y, ctp_k)
        drawer.point((x, y), fill='yellow')
        # drawer.text((x, y - 20), f'{cx},{cy}')

    return img


def count_depth(tree) -> int:
    depth = 1
    if 'TL' in tree:
        depth = max(depth, count_depth(tree['TL']) + 1)
    if 'TR' in tree:
        depth = max(depth, count_depth(tree['TR']) + 1)
    if 'BL' in tree:
        depth = max(depth, count_depth(tree['BL']) + 1)
    if 'BR' in tree:
        depth = max(depth, count_depth(tree['BR']) + 1)

    return depth


def count_sectors(tree):
    counter = 1
    if 'TL' in tree:
        counter += count_sectors(tree['TL'])
    if 'TR' in tree:
        counter += count_sectors(tree['TR'])
    if 'BL' in tree:
        counter += count_sectors(tree['BL'])
    if 'BR' in tree:
        counter += count_sectors(tree['BR'])

    if counter > 1:
        counter -= 1

    return counter


def visualize(tree, geo_objects, size=1000, save=False, show=True):
    start_x = tree['Boundary']['X']
    start_y = tree['Boundary']['Y']
    width = tree['Boundary']['Width']
    height = tree['Boundary']['Height']

    ctp_k = size / width
    print(f'CtP K: {ctp_k}')

    img_w = floor(width * ctp_k)
    img_h = floor(height * ctp_k)

    base = Image.new(mode="RGB", size=(img_w, img_h))
    drawer = ImageDraw.Draw(base)
    drawer.rectangle([(0, 0), (img_w - 1, img_h - 1)], outline="green")

    quad_tree_img = draw_points(base, geo_objects, start_x, start_y, ctp_k)
    quad_tree_img = draw_sectors(quad_tree_img, tree, start_x, start_y, ctp_k)

    kilometer_width = get_coordinates_distance((start_x, start_y), (start_x + width, start_y)) // 1000
    kilometer_height = get_coordinates_distance((start_x, start_y), (start_x, start_y + height)) // 1000

    # font = ImageFont.truetype("arial.ttf", 14)
    drawer.text((20, 5),
                f"""
Top left: 
latitude: {round(start_x, 6)}°
longitude: {round(start_y, 6)}°
Bottom right:
latitude: {round(start_x + width, 6)}°
longitude: {round(start_y + height, 6)}°
Width: {kilometer_width}km
Height: {kilometer_height}km
Area: {kilometer_width * kilometer_height}km²
""")

    if show:
        quad_tree_img.show()
    if save:
        quad_tree_img.save('QuadTree.png')

    return quad_tree_img


class Command(BaseCommand):
    def handle(self, *args, **options):
        quad_tree = models.QuadTree.objects.get(is_root=True)
        geo_objects = models.GeoObject.objects.all()
        data = quad_tree.get_json()
        tree = json.loads(data)
        print(f'Depth: {count_depth(tree)}, Sectors: {count_sectors(tree)}')
        visualize(tree, geo_objects, size=1000, save=True)
