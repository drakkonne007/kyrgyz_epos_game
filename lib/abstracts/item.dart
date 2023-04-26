
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/loot.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

Item itemFromId(int id)
{
  switch(id){
    case 0:   return PureHat(1);
    case 1:   return StrongHat(2);
    default: return PureHat(1);
  }
}

abstract class Item
{
  int id = 0;
  double hp = 0;
  double energy = 0;
  double armor = 0;
  int gold = 0;
  bool enabled = false;
  bool isDress = false;
  bool isAnimated = false;
  String source = '';
  int cost = 0;
  int column = 0;
  int row = 0;
  Vector2 srcSize = Vector2.all(0);
  int countOfUses = 0;
}

class LootOnMap extends SpriteComponent with HasGameRef<KyrgyzGame>
{
  LootOnMap(this._item,
      {bool? autoResize,
        Paint? paint,
        required super.position,
        Vector2? size,
        super.scale,
        super.angle,
        super.nativeAngle,
        super.anchor,
        super.children,
        super.priority,});
  Item _item;
  late ObjectHitbox _objectHitbox;

  @override
  Future<void> onLoad() async
  {
    priority = GamePriority.loot;
    final spriteImage = await Flame.images.load(
        _item.source);
    final spriteSheet = SpriteSheet(image: spriteImage,
        srcSize: _item.srcSize);
    sprite = spriteSheet.getSprite(_item.row, _item.column);
    size = Vector2.all(30);
    _objectHitbox = ObjectHitbox(autoTrigger: true, obstacleBehavoiur: getItemToPlayer);
    await add(_objectHitbox);
  }

  void getItemToPlayer()
  {
    print('getItemToPlayer');
    remove(_objectHitbox);
    double dur = 0.5;
    priority = GamePriority.maxPriority;
    add(ScaleEffect.to(Vector2.all(2.3), EffectController(duration: dur)));
    add(OpacityEffect.by(-0.95,EffectController(duration: dur),onComplete: (){
      removeFromParent();
    }));
  }

}