import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class CrystalEffect extends SpriteAnimationComponent
{

  CrystalEffect({required super.position});

  @override onLoad() async
  {
    anchor = const Anchor(0.5,0.5);
    priority = position.y.toInt();
    String name = 'name';
    int rand = Random().nextInt(6);
    Vector2 sprSize = Vector2(87,81);
    switch(rand){
      case 0: name = 'crystal particle effects-shiny1.png'; break;
      case 1: name = 'crystal particle effects-shiny2.png'; break;
      case 2: name = 'crystal particle effects-shiny3.png'; break;
      case 3: name = 'crystal particle effects-star.png'; break;
      case 4: name = 'crystal particle effects-star2.png'; break;
      case 5: name = 'crystal particle effects-star3.png'; break;
    }
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/mountainLand/Props/Animated props/$name'),
      srcSize: sprSize,
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.2,from: 0);
  }
}