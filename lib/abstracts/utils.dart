import 'package:flame/components.dart';

Vector2 f_pointOfIntersect(Vector2 a1, Vector2 a2, Vector2 b1, Vector2 b2)
{
  double s1_x, s1_y, s2_x, s2_y;
  s1_x = a2.x - a1.x;
  s1_y = a2.y - a1.y;
  s2_x = b2.x - b1.x;
  s2_y = b2.y - b1.y;

  double s, t;
  s = (-s1_y * (a1.x - b1.x) + s1_x * (a1.y - b1.y)) /
      (-s2_x * s1_y + s1_x * s2_y);
  t = (s2_x * (a1.y - b1.y) - s2_y * (a1.x - b1.x)) /
      (-s2_x * s1_y + s1_x * s2_y);

  if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
    return Vector2(a1.x + (t * s1_x), a1.y + (t * s1_y));
  }
  return Vector2.zero();
}