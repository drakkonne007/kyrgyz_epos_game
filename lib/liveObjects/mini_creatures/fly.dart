import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'dart:math' as math;

class Fly extends SpriteAnimationComponent
{

  Fly(this._startPos, {super.priority});
  final Vector2 _startPos;

  @override onLoad() async
  {
    anchor = const Anchor(0.5,0.5);
    position = _startPos;
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(10);
    String name = '';
    switch(rand){
      case 0: name = 'Insects-butterfly1-flying-4 frames-150x106.png'; break;
      case 1: name = 'Insects-butterfly1-flying around-24 frames-150x106.png'; break;
      case 2: name = 'Insects-butterfly2-flying-4 frames-150x106.png'; break;
      case 3: name = 'Insects-butterfly2-flying around-24 frames-150x106.png'; break;
      case 4: name = 'Insects-butterfly3-flying-4 frames-150x106.png'; break;
      case 5: name = 'Insects-butterfly3-flying around-24 frames-150x106.png'; break;
      case 6: name = 'Insects-mosquito-2 frames-150x106.png'; break;
      case 7: name = 'Insects-mosquito flying around-14 frames-150x106.png'; break;
      case 8: name = 'Insects-mosquito flying around2-14 frames-150x106.png'; break;
      case 9: name = 'Insects-mosquito flying around3-14 frames-150x106.png'; break;
    }
    var spriteSheet = SpriteSheet(
        image: await Flame.images.load('tiles/map/grassLand2/Props/Animated props/$name'),
        srcSize: Vector2(150,106),
  );
  animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0);
  }
}