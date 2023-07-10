import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';



class Chest extends SpriteComponent with HasGameRef<KyrgyzGame>
{
  Chest({this.nedeedKilledBosses, this.neededItems, required this.myItems
  ,Sprite? sprite,
    bool? autoResize,
    Paint? paint,
    required super.position,
    Vector2? size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor = Anchor.center,
    super.children,
    super.priority});
  Set<int>? nedeedKilledBosses;
  Set<int>? neededItems;
  List<Item> myItems;
  final int _row = 9;
  final int _column = 0;

  void checkIsIOpen()
  {
    if(nedeedKilledBosses != null){
      if(!gameRef.playerData.killedBosses.containsAll(nedeedKilledBosses!)){
        print('not kill needed boss');
        return;
      }
    }
    if(neededItems != null){
      for(final myNeeded in neededItems!) {
        bool isNeed = true;
        for(final playerHas in gameRef.playerData.inventoryItems){
          if(playerHas.id == myNeeded){
            isNeed = false;
            break;
          }
        }
        if(isNeed){
          print('not has nedeed item');
          return;
        }
      }
    }
    removeAll(children);
    double dur = 0.8;
    add(RotateEffect.by(tau/4,EffectController(duration: 0.2,reverseDuration: 0.2,infinite: true)));
    add(ScaleEffect.to(Vector2.all(1.5), EffectController(duration: dur)));
    add(OpacityEffect.by(-0.95,EffectController(duration: dur),onComplete: (){
      removeFromParent();
    }));
  }

  @override
  Future<void>onLoad() async
  {
    final spriteImage = await Flame.images.load(
        'tiles/map/loot/loot.png');
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: Vector2.all(24));
    sprite = spriteSheet.getSprite(_row, _column);
    size = Vector2.all(70);
    var asd = ObjectHitbox(obstacleBehavoiur: checkIsIOpen);
    await add(asd);
  }
}