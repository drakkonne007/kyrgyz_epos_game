import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/liveObjects/mini_creatures/npcDialogAttention.dart';

final List<Vector2> _grPoints = [
  Vector2(-5.4813,14.0557) * PhysicVals.physicScale * 1.2
  ,Vector2(-6.58885,31.3151) * PhysicVals.physicScale * 1.2
  ,Vector2(7.25555,31.2228) * PhysicVals.physicScale * 1.2
  ,Vector2(4.94815,14.0557) * PhysicVals.physicScale * 1.2
  ,];

final List<Vector2> _objPoints = [
  Vector2(-25.6811,8.52515) * 1.2
  ,Vector2(24.5701,8.25498) * 1.2
  ,Vector2(24.8402,-18.7321) * 1.2
  ,Vector2(-27.3021,-18.4619) * 1.2
  ,];

class Citizien extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  Citizien(this._id,{this.endPos, required super.position, this.quest, this.startTrigger, this.endTrigger});
  Ground? _ground;
  late SpriteAnimation _animIdle, _animMove;
  late Vector2 _startPos;
  List<Vector2>? endPos;
  String? quest;
  int? startTrigger;
  int? endTrigger;
  final int _id;
  final double _velocity = 30;
  int _nextPosition = 1;
  bool forward = true;
  bool _moveToAim = false;

  @override
  void onRemove()
  {
    _ground?.destroy();
    gameRef.gameMap.checkRemoveItself.removeListener(_checkIsNeedSelfRemove);
  }

  @override
  void onLoad() async
  {
    anchor = Anchor.center;
    _startPos = position;
    if(endPos != null){
      endPos!.insert(0, _startPos);
    }
    bool isMale = Random().nextBool();
    if(isMale){
      int type = Random().nextInt(120) + 1;
      SpriteSheet spriteSheet = SpriteSheet(
          image: await Flame.images.load('tiles/sprites/humanNPC/Male/NoWeapon/$type.png'),
          srcSize:  Vector2(80,64));
      _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.1 + Random().nextDouble() / 40 - 0.0125,from: 0, to: 5, loop: false);
      _animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.1 + Random().nextDouble() / 40 - 0.0125,from: 0, to: 8, loop: false);
    }else{
      int type = Random().nextInt(420) + 1;
      SpriteSheet spriteSheet = SpriteSheet(
          image: await Flame.images.load('tiles/sprites/humanNPC/Female/NoWeapon/$type.png'),
          srcSize:  Vector2(80,64));
      _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.1 + Random().nextDouble() / 40 - 0.0125,from: 0, to: 5, loop: false);
      _animMove = spriteSheet.createAnimation(row: 1, stepTime: 0.1 + Random().nextDouble() / 40 - 0.0125,from: 0, to: 8, loop: false);
    }
    animation = _animIdle;
    animationTicker?.currentIndex = Random().nextInt(animation!.frames.length - 1);
    animationTicker?.onComplete = changeMoves;
    BodyDef df = BodyDef(position: _startPos * PhysicVals.physicScale, fixedRotation: true,type: BodyType.dynamic, userData: BodyUserData(isQuadOptimizaion: false, ));
    FixtureDef ft = FixtureDef(PolygonShape()..set(_grPoints));
    _ground = Ground(df,gameRef.world.physicsWorld);
    _ground?.createFixture(ft);
    add(ObjectHitbox(_objPoints,collisionType: DCollisionType.active,
        isSolid: true,isStatic: false, isLoop: true, game: gameRef, obstacleBehavoiur: getBuyMenu, autoTrigger: false));
    if(quest != null){
      add(NpcDialogAttention(gameRef.quests[quest]!.isDone, position: Vector2(width / 2,height / 2 - 40)));
    }
    add(TimerComponent(period: 0.6, repeat: true, onTick: checkPriority));
    gameRef.gameMap.checkRemoveItself.addListener(_checkIsNeedSelfRemove);
    size *= 1.2;
  }

  void checkPriority()
  {
    priority = position.y.toInt() + 31;
  }

  void getBuyMenu()async
  {
    if(quest != null) {
      var answer = gameRef.quests[quest]!;
      if(answer.currentState >= startTrigger! && answer.currentState <= endTrigger!) {
        gameRef.doDialogHud(quest!);
      }
    }else{
      createSmallMapDialog(gameRef: gameRef);
    }
  }

  void changeMoves() {
    if(_moveToAim){
      animation = _animMove;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = changeMoves;
      return;
    }
    _ground?.clearForces();
    bool move = Random().nextBool();
    if (move) {
      if (endPos != null) {
        _moveToAim = true;
        Vector2 speed = endPos![_nextPosition] - position;
        speed = speed.normalized();
        if(speed.x > 0 && !isFlippedHorizontally){
          flipHorizontally();
        }else if(speed.x < 0 && isFlippedHorizontally){
          flipHorizontally();
        }
        _ground?.applyLinearImpulse(speed * _velocity * 0.15);
        animation = _animMove;
        add(TimerComponent(period: position.distanceTo(endPos![_nextPosition]) / (_velocity * 1.5), removeOnFinish: true, onTick: (){
          if(forward){
            _nextPosition++;
            if(_nextPosition >= endPos!.length){
              _nextPosition -=2;
              forward = false;
            }
          }else{
            _nextPosition--;
            if(_nextPosition < 0){
              _nextPosition = 1;
              forward = true;
            }
          }
          _moveToAim = false;
        }));
      }else{
        Vector2 speed = Vector2(Random().nextDouble() * 2 - 1, Random().nextDouble() * 2 - 1);
        if(speed.x > 0 && !isFlippedHorizontally){
          flipHorizontally();
        }else if(speed.x < 0 && isFlippedHorizontally){
          flipHorizontally();
        }
        _ground?.applyLinearImpulse(speed * _velocity);
        animation = _animMove;
      }
    }else{
      animation = _animIdle;
    }
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onComplete = changeMoves;
  }

  void _checkIsNeedSelfRemove()
  {
    if(endPos != null) {
      int countOfMimo = 0;
      for (final pos in endPos!) {
        int column = pos.x ~/ GameConsts.lengthOfTileSquare.x;
        int row = pos.y ~/ GameConsts.lengthOfTileSquare.y;
        int diffCol = (column - gameRef.gameMap.column()).abs();
        int diffRow = (row - gameRef.gameMap.row()).abs();
        if (diffCol > 1 || diffRow > 1) {
          countOfMimo++;
        }
      }
      if (countOfMimo == endPos!.length) {
        gameRef.gameMap.loadedLivesObjs.remove(_id);
        removeFromParent();
      }
    }else{
      int column = position.x ~/ GameConsts.lengthOfTileSquare.x;
      int row = position.y ~/ GameConsts.lengthOfTileSquare.y;
      int diffCol = (column - gameRef.gameMap.column()).abs();
      int diffRow = (row - gameRef.gameMap.row()).abs();
      if (diffCol > 1 || diffRow > 1) {
        gameRef.gameMap.loadedLivesObjs.remove(_id);
        removeFromParent();
      }
    }
  }

  @override
  void update(double dt)
  {
    position = _ground!.position / PhysicVals.physicScale;
    super.update(dt);
  }

}