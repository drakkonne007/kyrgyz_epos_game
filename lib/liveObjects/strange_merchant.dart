//d:\kyrgyz_epos_game\assets\tiles\map\ancientLand\Characters\NPC merchant\with animated items\NPC Merchant-interaction-entry

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Quests/chestOfGlory.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/quest.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/liveObjects/mini_creatures/npcDialogAttention.dart';

enum StrangeMerchantVariant
{
  black,
  white,
  brown,
  grey,
}

const double myScale = 1.15;

final List<Vector2> _ground = [
  Vector2(-3.22803,23.709) * PhysicVals.physicScale * myScale
  ,Vector2(-3.15018,10.3183) * PhysicVals.physicScale * myScale
  ,Vector2(16.1573,10.6297) * PhysicVals.physicScale * myScale
  ,Vector2(16.0016,23.6311) * PhysicVals.physicScale * myScale
  ,];

class StrangeMerchant extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  StrangeMerchant(this._startPos,this.spriteVariant,{super.priority, this.quest, this.startTrigger, this.endTrigger});
  Ground? ground;
  late SpriteAnimation _animIdle;
  final Vector2 _startPos;
  StrangeMerchantVariant spriteVariant;
  String? quest;
  int? startTrigger;
  int? endTrigger;

  @override
  void onRemove()
  {
    ground?.destroy();
  }

  @override
  void onLoad() async
  {
    anchor = Anchor.center;
    SpriteSheet spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/ancientLand/Characters/NPC merchant/with animated items/NPC Merchant-interaction-loop.png'),
        srcSize:  Vector2(110,110));
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.1 + Random().nextDouble() / 40 - 0.0125,from: 0);
    animation = _animIdle;
    size *= myScale;
    BodyDef df = BodyDef(position: _startPos * PhysicVals.physicScale, fixedRotation: true, userData: BodyUserData(isQuadOptimizaion: false));
    FixtureDef ft = FixtureDef(PolygonShape()..set(_ground));
    ground = Ground(df,gameRef.world.physicsWorld);
    ground?.createFixture(ft);
    add(ObjectHitbox(getPointsForActivs(Vector2(-30,-30), Vector2(60,60)),collisionType: DCollisionType.active,
        isSolid: true,isStatic: false, isLoop: true, game: gameRef, obstacleBehavoiur: getBuyMenu, autoTrigger: false));
    position = _startPos;
    int rand = Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(rand == 0){
      flipHorizontally();
    }
    position = ground!.position / PhysicVals.physicScale;
    priority = position.y.toInt() + 23;
    if(quest != null){
      final questDialog = NpcDialogAttention(gameRef.quests[quest]!.isDone, position: Vector2(width * anchor.x, height * anchor.y - 40), buy: quest == 'buy');
      if(isFlippedHorizontally){
        questDialog.flipHorizontally();
      }
      add(questDialog);
    }
    super.onLoad();
  }

  void getBuyMenu()async
  {
    if(quest != null) {
      if(quest == 'buy'){
        gameRef.doBuyMenu();
        return;
      }
      var answer = gameRef.quests[quest]!;
      if(answer.currentState >= startTrigger! && answer.currentState <= endTrigger!) {
        gameRef.doDialogHud(quest!);
      }
    }else{
      createSmallMapDialog(gameRef: gameRef);
    }
  }
}