





import 'package:flame/components.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/circleMagicBall.dart';
import 'package:game_flame/weapon/forwardMagicBall.dart';
import 'dart:math' as math;



void createPlayerMagicSpells(KyrgyzGame gameRef) {
  String source;
  switch (gameRef.playerData.ringDress.value.magicDamage) {
    case null:
      return;
    case MagicDamage.none:
      throw 'Error in magic damage';
    case MagicDamage.fire:
      source = 'tiles/map/mountainLand/Props/Animated props/power balls-2.png';
      break;
    case MagicDamage.ice:
      source = 'tiles/map/mountainLand/Props/Animated props/power balls-1.png';
      break;
    case MagicDamage.poison:
      source = 'tiles/map/mountainLand/Props/Animated props/power balls-4.png';
      break;
    case MagicDamage.lightning:
      source = 'tiles/map/mountainLand/Props/Animated props/power balls-3.png';
      break;
    case MagicDamage.copyOfPlayer:
      source = 'tiles/map/mountainLand/Props/Animated props/power balls-3.png';
      break;
  }

  //0,628319 - это 36 градусов в радианах (чтобы 10 было шаров вокруг игрока)

  double damage = gameRef.playerData.ringDress.value.permanentDamage;
  double secs = gameRef.playerData.ringDress.value.secsOfPermDamage;
  if (gameRef.playerData.ringDress.value.magicSpellVariant ==
      MagicSpellVariant.circle) {
    for (int i = 0; i <
        gameRef.playerData.playerMagicLevel.value.toInt(); i++) {
      gameRef.gameMap.container.add(CircleMagicBall(source: source,
          damage: damage,
          secs: secs,
          magicDamage: gameRef.playerData.ringDress.value.magicDamage!,
          angle: 0.628319 * i));
    }
  } else {
    Vector2 pos = gameRef.playerPosition() +
        (gameRef.isPlayerFlipped() ? Vector2(-22, 2) : Vector2(22, 2));
    Vector2 norm = gameRef.gameMap.orthoPlayer?.groundRigidBody?.linearVelocity ?? gameRef.gameMap.frontPlayer?.groundRigidBody?.linearVelocity ?? Vector2(0, 0);
    double vecAngle = norm.angleToSigned(Vector2(1,0));
    gameRef.gameMap.container.add(ForwardMagicBall(
        magicDamage: gameRef.playerData.ringDress.value.magicDamage!,
        position: pos,
        source: source,
        target: Vector2(math.cos(vecAngle), -math.sin(vecAngle)),
        damage: damage,
        secs: secs));

    for (int i = 1; i <
        gameRef.playerData.playerMagicLevel.value.toInt(); i++) {
      if (i % 2 == 0) {
        gameRef.gameMap.container.add(ForwardMagicBall(
            magicDamage: gameRef.playerData.ringDress.value.magicDamage!,
            position: pos,
            source: source,
            target: Vector2(math.cos(vecAngle + math.pi / 5), -math.sin(vecAngle + math.pi / 5)),
            damage: damage,
            secs: secs));
      } else {
        gameRef.gameMap.container.add(ForwardMagicBall(
            magicDamage: gameRef.playerData.ringDress.value.magicDamage!,
            position: pos,
            source: source,
            target: Vector2(math.cos(vecAngle - math.pi / 5), -math.sin(vecAngle - math.pi / 5)),
            damage: damage,
            secs: secs));
      }
    }
    // switch(gameRef.playerData.ringDress.value.magicSpellVariant){
    //   case MagicSpellVariant.none:
    //     coolDown = 20;
    //   case MagicSpellVariant.circle:
    //     coolDown = 1.5;
    //   case MagicSpellVariant.forward:
    //     coolDown = 20;
    // }
    // gameRef.gameMap.container.add()
    //
    //
    // switch(gameRef.playerData.playerMagicSpell){
    //   case PlayerMagicSpell.none: return;
    //   case PlayerMagicSpell.darkBall:
    //     Vector2 norm = groundRigidBody?.linearVelocity ?? Vector2.zero();
    //     double vecAngle = norm.angleToSigned(Vector2(1,0));
    //     gameRef.gameMap.container.add(DarkBall(Vector2(math.cos(vecAngle + math.pi / 6), -math.sin(vecAngle + math.pi / 6)), position: position - Vector2(22,2)));
    //     gameRef.gameMap.container.add(DarkBall(Vector2(math.cos(vecAngle), -math.sin(vecAngle)), position: position - Vector2(22,2)));
    //     gameRef.gameMap.container.add(DarkBall(Vector2(math.cos(vecAngle - math.pi / 6), -math.sin(vecAngle - math.pi / 6)), position: position - Vector2(22,2)));
    //   case PlayerMagicSpell.electroBall:
    //     gameRef.gameMap.container.add(ElectroBall(5 * math.pi / 6));
    //     gameRef.gameMap.container.add(ElectroBall(math.pi / 6));
    //     gameRef.gameMap.container.add(ElectroBall(3 * math.pi / 2));
    //   case PlayerMagicSpell.fireBallBlue:
    //     Vector2 norm = groundRigidBody?.linearVelocity ?? Vector2.zero();
    //     double vecAngle = norm.angleToSigned(Vector2(1,0));
    //     if(isFlippedHorizontally){
    //       gameRef.gameMap.container.add(FireBall(FireBallType.blue,Vector2(math.cos(vecAngle + math.pi / 6), -math.sin(vecAngle + math.pi / 6)), position: position - Vector2(22,2)));
    //       gameRef.gameMap.container.add(FireBall(FireBallType.blue,Vector2(math.cos(vecAngle), -math.sin(vecAngle)), position: position - Vector2(22,2)));
    //       gameRef.gameMap.container.add(FireBall(FireBallType.blue,Vector2(math.cos(vecAngle - math.pi / 6), -math.sin(vecAngle - math.pi / 6)), position: position - Vector2(22,2)));
    //     }else{
    //       gameRef.gameMap.container.add(FireBall(FireBallType.blue,Vector2(math.cos(vecAngle + math.pi / 6), -math.sin(vecAngle + math.pi / 6)), position: position + Vector2(22,2)));
    //       gameRef.gameMap.container.add(FireBall(FireBallType.blue,Vector2(math.cos(vecAngle), -math.sin(vecAngle)), position: position + Vector2(22,2)));
    //       gameRef.gameMap.container.add(FireBall(FireBallType.blue,Vector2(math.cos(vecAngle - math.pi / 6), -math.sin(vecAngle - math.pi / 6)), position: position + Vector2(22,2)));
    //     }
    //     break;
    //   case PlayerMagicSpell.fireBallRed:
    //     Vector2 norm = groundRigidBody?.linearVelocity ?? Vector2.zero();
    //     double vecAngle = norm.angleToSigned(Vector2(1,0));
    //     if(isFlippedHorizontally){
    //       gameRef.gameMap.container.add(FireBall(FireBallType.red,Vector2(math.cos(vecAngle + math.pi / 6), -math.sin(vecAngle + math.pi / 6)), position: position - Vector2(22,2)));
    //       gameRef.gameMap.container.add(FireBall(FireBallType.red,Vector2(math.cos(vecAngle), -math.sin(vecAngle)), position: position - Vector2(22,2)));
    //       gameRef.gameMap.container.add(FireBall(FireBallType.red,Vector2(math.cos(vecAngle - math.pi / 6), -math.sin(vecAngle - math.pi / 6)), position: position - Vector2(22,2)));
    //     }else{
    //       gameRef.gameMap.container.add(FireBall(FireBallType.red,Vector2(math.cos(vecAngle + math.pi / 6), -math.sin(vecAngle + math.pi / 6)), position: position + Vector2(22,2)));
    //       gameRef.gameMap.container.add(FireBall(FireBallType.red,Vector2(math.cos(vecAngle), -math.sin(vecAngle)), position: position + Vector2(22,2)));
    //       gameRef.gameMap.container.add(FireBall(FireBallType.red,Vector2(math.cos(vecAngle - math.pi / 6), -math.sin(vecAngle - math.pi / 6)), position: position + Vector2(22,2)));
    //     }
    //     break;
    //   case PlayerMagicSpell.poisonBall:
    //     Vector2 norm = groundRigidBody?.linearVelocity ?? Vector2.zero();
    //     double vecAngle = norm.angleToSigned(Vector2(1,0));
    //     gameRef.gameMap.container.add(PoisonBall(Vector2(math.cos(vecAngle + math.pi / 6), -math.sin(vecAngle + math.pi / 6)), position: position - Vector2(22,2)));
    //     gameRef.gameMap.container.add(PoisonBall(Vector2(math.cos(vecAngle), -math.sin(vecAngle)), position: position - Vector2(22,2)));
    //     gameRef.gameMap.container.add(PoisonBall(Vector2(math.cos(vecAngle - math.pi / 6), -math.sin(vecAngle - math.pi / 6)), position: position - Vector2(22,2)));
    // }
  }
}