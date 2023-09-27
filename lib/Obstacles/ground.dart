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
  });

  @override
  bool operator ==(Object other)
  {
    if(other is Ground){
      return position == other.position && size == other.size;
    }else{
      return false;
    }
  }

  @override
  int get hashCode => position.hashCode ^ size.hashCode;
}