//d:\kyrgyz_epos_game\assets\tiles\map\ancientLand\Characters\NPC merchant\with animated items\NPC Merchant-interaction-entry

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/dVector2.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

enum StrangeMerchantVariant
{
  black,
  white,
  brown,
  grey,
}

class StrangeMerchant extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  StrangeMerchant(this._startPos,this.spriteVariant,{super.priority});
  late SpriteAnimation _animIdle;
  final Vector2 _startPos;
  StrangeMerchantVariant spriteVariant;
  late Ground _myBottomPoint;
  late GroundHitBox _playerGround;

  @override
  void onLoad() async
  {
    anchor = Anchor.center;
    SpriteSheet spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/ancientLand/Characters/NPC merchant/with animated items/NPC Merchant-interaction-loop.png'),
        srcSize:  Vector2(110,110));
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0);
    animation = _animIdle;
    size *= 1.15;
    final List<dVector2> points = [
      (dVector2(38,36) - dVector2(55,55)) * 1.15,
      (dVector2(38,50) - dVector2(55,55)) * 1.15,
      (dVector2(42,66) - dVector2(55,55)) * 1.15,
      (dVector2(52,79) - dVector2(55,55)) * 1.15,
      (dVector2(70,79) - dVector2(55,55)) * 1.15,
      (dVector2(73,75) - dVector2(55,55)) * 1.15,
      (dVector2(73,34) - dVector2(55,55)) * 1.15,
    ];
    _myBottomPoint = Ground(points,collisionType: DCollisionType.passive,isSolid: false,
        isStatic: false, isLoop: true, game: gameRef);
    add(_myBottomPoint);
    add(ObjectHitbox(getPointsForActivs(dVector2(-30,-30), dVector2(60,60)),collisionType: DCollisionType.active,
        isSolid: true,isStatic: false, isLoop: true, game: gameRef, obstacleBehavoiur: getBuyMenu, autoTrigger: false));
    position = _startPos;
    super.onLoad();
    _playerGround = gameRef.gameMap.orthoPlayer?.groundBox ?? gameRef.gameMap.frontPlayer!.groundBox!;
    int rand = Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
  }

  void getBuyMenu()
  {
    gameRef.doDialogHud();
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    if(_myBottomPoint.getMaxVector().y > _playerGround.getMaxVector().y){
      parent = gameRef.gameMap.enemyOnPlayer;
    }else{
      parent = gameRef.gameMap.enemyComponent;
    }
  }
}