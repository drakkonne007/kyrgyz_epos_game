import 'dart:math';

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

//return intersects line and circle (coordinates and radius)

List<Vector2> f_intersectLineWithCircle(List<Vector2> line, Vector2 circlePos, double radius)
{
  Vector2 startL = line.first - circlePos;
  Vector2 endL = line.last - circlePos;
  double a = (endL.y - startL.y);
  double b = (endL.x - startL.x);
  double norm = sqrt(a*a + b*b);
  a /= norm;
  b /= norm;
  double c = (a * startL.x + b * startL.y) * -1;
  var points = f_intersectLineFunctionWithCircle(radius, a, b, c, circlePos);
  if(points.length == 2){
    var control = f_pointOfIntersect(points.first, points.last, line.first, line.last);
    if(control != Vector2.zero()){
      return points;
    }else{
      return [];
    }
  }
  return points;
}

List<Vector2> f_intersectLineFunctionWithCircle(double r,double a,double b,double c, Vector2 circlePos)
{
  List<Vector2> points = [];
  double x0 = -a*c/(a*a+b*b),  y0 = -b*c/(a*a+b*b);
  if (c*c > r*r*(a*a+b*b)) {
    return points;
  } else if ((c*c - r*r*(a*a+b*b)).abs() < 0) {
    return points;
    // points.add(Vector2(x0, y0) + circlePos);
  } else {
    double d = r*r - c*c/(a*a+b*b);
    double mult = sqrt (d / (a*a+b*b));
    double ax,ay,bx,by;
    ax = x0 + b * mult;
    bx = x0 - b * mult;
    ay = y0 - a * mult;
    by = y0 + a * mult;
    points.add(Vector2(ax, ay) + circlePos);
    points.add(Vector2(bx, by) + circlePos);
  }
  return points;
}


class GroundSource
{
  bool isLoop = false;
  Set<Vector2> points = {};
}

