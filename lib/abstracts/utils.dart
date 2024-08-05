import 'dart:math';

import 'package:flame/components.dart';

Vector2 f_pointOfIntersect(Vector2 a1, Vector2 a2, Vector2 b1, Vector2 b2)
{
  double s1X, s1Y, s2X, s2Y;
  s1X = a2.x - a1.x;
  s1Y = a2.y - a1.y;
  s2X = b2.x - b1.x;
  s2Y = b2.y - b1.y;

  double s, t;
  s = (-s1Y * (a1.x - b1.x) + s1X * (a1.y - b1.y)) /
      (-s2X * s1Y + s1X * s2Y);
  t = (s2X * (a1.y - b1.y) - s2Y * (a1.x - b1.x)) /
      (-s2X * s1Y + s1X * s2Y);

  if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
    return Vector2(a1.x + (t * s1X), a1.y + (t * s1Y));
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
    var distOfLine = line.first.distanceToSquared(line.last);
    if(line.first.distanceToSquared(points.first) > distOfLine
        || line.first.distanceToSquared(points.last) > distOfLine
        || line.last.distanceToSquared(points.first) > distOfLine
        || line.last.distanceToSquared(points.last) > distOfLine){
      return [];
    }else{
      return points;
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
  bool isPlayer = false;
  bool isEnemy = false;
  List<Vector2> points = [];

  @override
  bool operator ==(Object other) {
    if(other is GroundSource){
      if(points.length != other.points.length) return false;
      if(isLoop != other.isLoop) return false;
      for(int i = 0; i < points.length; i++){
        if(points.elementAt(i) != other.points.elementAt(i)) return false;
      }
      return true;
    }
    return false;
  }

  int countHash()
  {
    int ret = 0;
    for(int i = 0; i < points.length; i++){
      ret += points.elementAt(i).hashCode;
    }
    ret += isLoop.hashCode;
    return ret;
  }

  @override
  int get hashCode => countHash();

}

class AxesDiff
{
  AxesDiff(this.leftDiff, this.rightDiff, this.upDiff, this.downDiff);
  double leftDiff = 0;
  double rightDiff = 0;
  double upDiff = 0;
  double downDiff = 0;
}

enum ObstacleWhere
{
  none,
  up,
  down,
  left,
  right,
}
