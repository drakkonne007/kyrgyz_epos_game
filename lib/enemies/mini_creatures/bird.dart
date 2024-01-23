import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'dart:math' as math;

import 'package:game_flame/kyrgyz_game.dart';

class Bird extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{

  Bird(this._startPos, this._endPos);
  Vector2 _startPos;
  List<Vector2> _endPos;
  double _speed = 0;
  bool _isFlying = false;
  double _totalAirDuration = 0;
  double _angle = 0;
  bool _onStart = true;
  int _flying = 0;

  late SpriteAnimation _animIdle,_animIdle2,_animLanding,_animLiftOff,_animFlying;
  final List<SpriteAnimation> _idleList = [];

  @override onLoad() async
  {
    TimerComponent timer = TimerComponent(onTick: _checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 1);
    add(timer);
    _endPos.add(_startPos);
    anchor = const Anchor(0.5,0.5);
    position = _startPos;
    size = Vector2.all(70);
    int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(4);
    rand++;
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/grassLand2/Characters/small animals/birds/bird${rand.toString()}/small animals - bird- idle - sideview.png'),
      srcSize: Vector2(96,96),
    );
    _animIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/grassLand2/Characters/small animals/birds/bird${rand.toString()}/small animals - bird-idle 2 - sideview.png'),
      srcSize: Vector2(96,96),
    );
    _animIdle2 = spriteSheet.createAnimation(row: 0, stepTime: 0.15,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/grassLand2/Characters/small animals/birds/bird${rand.toString()}/small animals - bird-landing.png'),
      srcSize: Vector2(96,96),
    );
    _animLanding = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/grassLand2/Characters/small animals/birds/bird${rand.toString()}/small animals - bird-lifting off.png'),
      srcSize: Vector2(96,96),
    );
    _animLiftOff = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0,loop: false);
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/grassLand2/Characters/small animals/birds/bird${rand.toString()}/small animals - bird-turning.png'),
      srcSize: Vector2(96,96),
    );
    spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/grassLand2/Characters/small animals/birds/bird${rand.toString()}/small animals - bird-walk - sideview.png'),
      srcSize: Vector2(96,96),
    );
    _animFlying = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0,loop: true);
    _totalAirDuration = _animFlying.ticker().totalDuration() * 6 + _animLanding.ticker().totalDuration() + _animLiftOff.ticker().totalDuration();
    _idleList.add(_animIdle);
    _idleList.add(_animIdle2);
    changeMoves();
  }

  void changeMoves()
  {
    int isGround = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(6);
    if(isGround == 0) {
      _flying = 0;
      isGround = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(_endPos.length);
      _angle = math.atan2(_endPos[isGround].y - position.y,_endPos[isGround].x - position.x);
      _speed = position.distanceTo(_endPos[isGround]) / _totalAirDuration;
      if(math.cos(_angle) > 0 && isFlippedHorizontally){
        flipHorizontally();
      }
      if(math.cos(_angle) < 0 && !isFlippedHorizontally){
        flipHorizontally();
      }
      _isFlying = true;
      animation = _animLiftOff;
      animationTicker?.onComplete = () {
        animation = _animFlying;
        animationTicker?.onFrame = (index) {
          if (index == 0) {
            _flying++;
          }
          if (_flying == 7) {
            animation = _animLanding;
            animationTicker?.onComplete = () {
              _isFlying = false;
              _onStart = !_onStart;
              changeMoves();
            };
          };
        };
      };
    }else{
      int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(_idleList.length);
      animation = null;
      animation = _idleList[rand];
      animationTicker?.onComplete = changeMoves;
      rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(3);
      if(rand == 0){
        flipHorizontally();
      }
    }
  }

  void _checkIsNeedSelfRemove()
  {
    int countOfMimo = 0;
    for(final pos in _endPos){
      int column = pos.x ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.x;
      int row =    pos.y ~/ gameRef.playerData.playerBigMap.gameConsts.lengthOfTileSquare.y;
      int diffCol = (column - gameRef.gameMap.column()).abs();
      int diffRow = (row - gameRef.gameMap.row()).abs();
      if(diffCol > 2 || diffRow > 2){
        countOfMimo++;
      }
    }
    if(countOfMimo == _endPos.length){
      gameRef.gameMap.loadedLivesObjs.remove(_startPos);
      removeFromParent();
    }
  }

  @override
  void update(double dt)
  {
    if(_isFlying) {
      position.x += _speed * dt * math.cos(_angle);
      position.y += _speed * dt * math.sin(_angle);
    }
    // }else{
    //   if(_onStart){
    //     if(position.distanceToSquared(_startPos) > 30*30){
    //       _angle = math.atan2(_startPos.x - _endPos.x, _startPos.y - _endPos.y);
    //       position.x += 30 * dt * math.cos(_angle);
    //       position.y += 30 * dt * math.sin(_angle);
    //     }else{
    //       position.x += (math.Random(DateTime.now().microsecondsSinceEpoch).nextDouble() * 30 - 15) * dt;
    //       position.y += (math.Random(DateTime.now().microsecondsSinceEpoch).nextDouble() * 30 - 15) * dt;
    //     }
    //   }else{
    //     if(position.distanceToSquared(_endPos) > 30*30){
    //       _angle = math.atan2(_startPos.x - _endPos.x, _startPos.y - _endPos.y);
    //       position.x += 30 * dt * math.cos(_angle);
    //       position.y += 30 * dt * math.sin(_angle);
    //     }else{
    //       position.x += (math.Random(DateTime.now().microsecondsSinceEpoch).nextDouble() * 30 - 15) * dt;
    //       position.y += (math.Random(DateTime.now().microsecondsSinceEpoch).nextDouble() * 30 - 15) * dt;
    //     }
    //   }
    // }
    super.update(dt);
  }
}