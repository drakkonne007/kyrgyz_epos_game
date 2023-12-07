//d:\kyrgyz_epos_game\assets\tiles\map\ancientLand\Characters\NPC merchant\with animated items\NPC Merchant-interaction-entry

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
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
  late SpriteAnimation _animMove, _animIdle, _animAttack, _animHurt, _animDeath;
  Vector2 _startPos;
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
    add(Ground(getPointsForActivs(Vector2(-15,-40), Vector2(30,80)),collisionType: DCollisionType.passive,isSolid: true,
        isStatic: false, isLoop: true, game: gameRef));
    add(ObjectHitbox(getPointsForActivs(Vector2(-25,-55), Vector2(50,110)),collisionType: DCollisionType.active,
        isSolid: true,isStatic: false, isLoop: true, game: gameRef, obstacleBehavoiur: getBuyMenu, autoTrigger: false));
    position = _startPos;
    super.onLoad();
  }

  void getBuyMenu()
  {
    gameRef.doDialogHud();
  }
}