
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'dart:math' as math;

class Trigger extends PositionComponent with HasGameRef<KyrgyzGame>
{
  KyrgyzGame kyrGame;
  String? dialog;
  bool? autoTrigger;
  bool? removeOnTrigger;
  int? onTrigger;
  int? startTrigger;
  int? endTrigger;
  bool? isEndQuest;
  String? quest;
  Trigger({required super.size, required super.position, required this.kyrGame,this.removeOnTrigger
    , this.dialog, this.autoTrigger, this.onTrigger, this.quest
    , this.isEndQuest,this.startTrigger, this.endTrigger})
  {
    startTrigger ??= 0;
    endTrigger ??= 99999999;
  }

  @override
  Future<void> onLoad() async
  {
    anchor = Anchor.center;
    add(ObjectHitbox(getPointsForActivs(-size/2,size), collisionType: DCollisionType.active, isSolid: true, isStatic: false, obstacleBehavoiur: trig, autoTrigger: autoTrigger ?? true, isLoop: true, game: gameRef));
  }

  void trig() async
  {
    if(dialog != null){
      createText(text: dialog!, gameRef: gameRef);
    }
    if(quest != null) {
      if(kyrGame.quests[quest]!.currentState < startTrigger! || kyrGame.quests[quest]!.currentState >= endTrigger!){
        return;
      }
      gameRef.setQuestState(quest!, onTrigger!, isEndQuest ?? false);
    }
    if(removeOnTrigger ?? true){
      removeFromParent();
    }
  }
}