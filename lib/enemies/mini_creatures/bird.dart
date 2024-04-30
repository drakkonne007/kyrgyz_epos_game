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
  int _flying = 0;
  int _currentPlace = 0;


  late SpriteAnimation _animIdle,_animIdle2,_animLanding,_animLiftOff,_animFlying;
  final List<SpriteAnimation> _idleList = [];

  @override onLoad() async
  {
    TimerComponent timer = TimerComponent(onTick: _checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 1);
    add(timer);
    _endPos.add(_startPos);
    _currentPlace = _endPos.length-1;
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
    _totalAirDuration = SpriteAnimationTicker(_animFlying).totalDuration() * 8;
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
      if(isGround == _currentPlace){
        if(isGround == 0){
          isGround++;
        }else if(isGround == _endPos.length-1){
          isGround--;
        }else{
          isGround++;
        }
      }
      _currentPlace = isGround;
      _angle = math.atan2(_endPos[isGround].y - position.y,_endPos[isGround].x - position.x);
      _speed = position.distanceTo(_endPos[isGround]) / _totalAirDuration;
      if(math.cos(_angle) > 0 && isFlippedHorizontally){
        flipHorizontally();
      }
      if(math.cos(_angle) < 0 && !isFlippedHorizontally){
        flipHorizontally();
      }
      animation = _animLiftOff;
      animationTicker?.onComplete = () {
        _isFlying = true;
        animation = _animFlying;
        animationTicker?.onFrame = (index) {
          if (index == 0) {
            _flying++;
          }
          if (_flying == 9) {
            animation = _animLanding;
            _isFlying = false;
            animationTicker?.onComplete = () {
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
      if(diffCol > 1 || diffRow > 1){
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
    super.update(dt);
  }
}