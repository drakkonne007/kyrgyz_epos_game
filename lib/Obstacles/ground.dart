import 'package:game_flame/abstracts/obstacle.dart';

class Ground extends MapObstacle
{
  Ground({
    super.position,
    super.size,
    super.angle,
    super.anchor,
    super.priority,
    bool isSolid = false,
  })
  {
    debugMode = true;
  }
}