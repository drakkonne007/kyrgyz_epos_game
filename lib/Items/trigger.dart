
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'dart:math' as math;

final String _noNeededItem = 'Нет нужного предмета...';
final String _noNeededKilledBoss = 'Сначала победите босса';

class Trigger extends PositionComponent with HasGameRef<KyrgyzGame>
{
  KyrgyzGame kyrGame;
  Set<String>? needKilledBosses;
  Set<String>? needItems;
  String? world;
  String? dialog;
  String? dialogNegative;
  bool? autoTrigger;
  bool? removeOnTrigger;
  int? onTrigger;
  int? startTrigger;
  Ground? _ground;
  int? endTrigger;
  bool? isEndQuest;
  String? quest;
  bool ground;
  Trigger({required super.size, required super.position, required this.kyrGame,this.removeOnTrigger
    , this.dialog, this.autoTrigger, this.onTrigger, this.quest
    , this.isEndQuest,this.startTrigger, this.endTrigger, this.needKilledBosses, this.needItems
    ,this.world, this.ground = false, this.dialogNegative})
  {
    startTrigger ??= 0;
    endTrigger ??= 99999999;
  }

  @override
  Future<void> onLoad() async
  {
    anchor = Anchor.center;
    add(ObjectHitbox(getPointsForActivs(-size/2 - Vector2.all(20),size + Vector2.all(20)), collisionType: DCollisionType.active, isSolid: true, isStatic: false, obstacleBehavoiur: trig, autoTrigger: autoTrigger ?? true, isLoop: true, game: gameRef));
    if(ground){
      FixtureDef fix = FixtureDef(PolygonShape()..set(getPointsForActivs(-size/2,size, scale: PhysicVals.physicScale)));
      _ground = Ground(
          BodyDef(type: BodyType.static, position: position * PhysicVals.physicScale, fixedRotation: true,
              userData: BodyUserData(isQuadOptimizaion: false)),
          gameRef.world.physicsWorld
      );
      _ground?.createFixture(fix);
    }
  }

  @override
  void onRemove()
  {
    _ground?.destroy();
  }

  void trig() async
  {
    if(needKilledBosses != null){
      for(final str in needKilledBosses!){
        int cur = int.parse(str);
        var answ = await gameRef.dbHandler.getItemStateFromDb(cur,world ?? gameRef.gameMap.currentGameWorldData!.nameForGame);
        if(!answ.used){
          createText(text: dialogNegative ?? _noNeededKilledBoss,gameRef: gameRef);
          return;
        }
      }
    }
    if(needItems != null){
      var setItems = gameRef.playerData.itemInventar.keys.toSet();
      if(!setItems.containsAll(needItems!)){
        createText(text: _noNeededItem,gameRef: gameRef);
        return;
      }
    }
    if(dialog != null){
      createText(text: dialog!, gameRef: gameRef);
    }
    if(quest != null) {
      if(kyrGame.quests[quest]!.currentState < startTrigger! || kyrGame.quests[quest]!.currentState >= endTrigger!){
        return;
      }
      if(onTrigger != null && isEndQuest != null) {
        gameRef.setQuestState(quest!, onTrigger ?? kyrGame.quests[quest]!.currentState, isEndQuest ?? false, null, kyrGame.quests[quest]!.needInventar);
      }
    }
    if(removeOnTrigger ?? true){
      removeFromParent();
    }
  }
}