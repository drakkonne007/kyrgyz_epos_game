//d:\kyrgyz_epos_game\assets\tiles\map\ancientLand\Characters\NPC merchant\with animated items\NPC Merchant-interaction-entry

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
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
  Ground? ground;
  late SpriteAnimation _animIdle;
  final Vector2 _startPos;
  StrangeMerchantVariant spriteVariant;

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
    final List<Vector2> points = [
      (Vector2(38,36) - Vector2(55,55)) * 1.15,
      (Vector2(38,50) - Vector2(55,55)) * 1.15,
      (Vector2(42,66) - Vector2(55,55)) * 1.15,
      (Vector2(52,79) - Vector2(55,55)) * 1.15,
      (Vector2(70,79) - Vector2(55,55)) * 1.15,
      (Vector2(73,75) - Vector2(55,55)) * 1.15,
      (Vector2(73,34) - Vector2(55,55)) * 1.15,
    ];
    BodyDef df = BodyDef(position: _startPos, fixedRotation: true, userData: BodyUserData(isQuadOptimizaion: false));
    FixtureDef ft = FixtureDef(PolygonShape()..set(points));
    ground = Ground(df,gameRef.world.physicsWorld);
    ground?.createFixture(ft);
    add(ObjectHitbox(getPointsForActivs(Vector2(-30,-30), Vector2(60,60)),collisionType: DCollisionType.active,
        isSolid: true,isStatic: false, isLoop: true, game: gameRef, obstacleBehavoiur: getBuyMenu, autoTrigger: false));
    position = _startPos;
    super.onLoad();
    int rand = Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    position = ground?.position ?? Vector2.zero();
  }

  void getBuyMenu()
  {
    gameRef.doDialogHud();
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    // if(_myBottomPoint.getMaxVector().y > gameRef.gameMap.orthoPlayer?.hitBox?.getMaxVector().y){
    //   parent = gameRef.gameMap.enemyOnPlayer;
    // }else{
    //   parent = gameRef.gameMap.enemyComponent;
    // }
  }
}