import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'dart:math' as math;

class SpinBlade extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  SpinBlade(this._startPos, this._endPos,this._id,{super.priority});
  int _id;
  final Vector2 _startPos;
  final Vector2? _endPos;
  final double _maxSpeed = 180;
  Vector2 _speed = Vector2(0,0);
  bool isWasEnd = false;

  @override
  void onLoad() async
  {
    anchor = Anchor.center;
    position = _startPos;
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/prisonSet/Props/'
          'trap-spinning blades-spinning style 2 with shadow.png'),
      srcSize: Vector2(128,128),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0);
    DefaultEnemyWeapon weapon = DefaultEnemyWeapon([Vector2(7.84781,-3.33532)],collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: false
        , game: gameRef, radius: 33, onStartWeaponHit: null, onEndWeaponHit: null);
    weapon.damage = 3;
    weapon.coolDown = _endPos == null ? 1 : 0.5;
    add(weapon);
    DefaultPlayerWeapon weaponPlayer = DefaultPlayerWeapon([Vector2(7.84781,-3.33532)],collisionType: DCollisionType.active,isSolid: false,isStatic: false, isLoop: false
        , game: gameRef, radius: 33, onStartWeaponHit:null, onEndWeaponHit: null);
    weaponPlayer.damage = 0;
    weaponPlayer.coolDown = _endPos == null ? 1 : 0.5;
    add(weaponPlayer);
    if(_endPos != null) {
      double posX = _endPos!.x - _startPos.x;
      double posY = _endPos!.y - _startPos.y;
      double percent = math.min(posX.abs(), posY.abs()) /
          math.max(posX.abs(), posY.abs());
      double isY = posY.isNegative ? -1 : 1;
      double isX = posX.isNegative ? -1 : 1;
      _speed = Vector2(
          posX.abs() > posY.abs() ? _maxSpeed * isX : _maxSpeed * percent * isX,
          posY.abs() > posX.abs() ?
          _maxSpeed * isY : _maxSpeed * percent * isY);
    }else{
      _speed = Vector2(0,0);
    }
    TimerComponent timer = TimerComponent(onTick: checkIsNeedSelfRemove,repeat: true,autoStart: true, period: 1);
    add(timer);
  }

  void checkIsNeedSelfRemove()
  {
    int currColumn = position.x ~/ GameConsts.lengthOfTileSquare.x;
    int currRow = position.y ~/ GameConsts.lengthOfTileSquare.y;
    int diffCurrx = (currColumn - gameRef.gameMap.column()).abs();
    int diffCurrRow = (currRow - gameRef.gameMap.row()).abs();
    if(diffCurrx < 2 && diffCurrRow < 2){
      return;
    }
    int column = _startPos.x ~/ GameConsts.lengthOfTileSquare.x;
    int row =    _startPos.y ~/ GameConsts.lengthOfTileSquare.y;
    int diffCol = (column - gameRef.gameMap.column()).abs();
    int diffRow = (row - gameRef.gameMap.row()).abs();
    if(diffCol > 1 || diffRow > 1){
      if(_endPos != null){
        int secDiff = (_endPos!.x ~/ GameConsts.lengthOfTileSquare.x - gameRef.gameMap.column()).abs();
        int secDiffRow = (_endPos!.y ~/ GameConsts.lengthOfTileSquare.y - gameRef.gameMap.row()).abs();
        if(secDiff > 1 || secDiffRow > 1){
          gameRef.gameMap.loadedLivesObjs.remove(_id);
          removeFromParent();
        }
      }else{
        gameRef.gameMap.loadedLivesObjs.remove(_id);
        removeFromParent();
      }
    }
  }

  @override
  void update(double dt)
  {
    if(_endPos != null) {
      position += _speed * dt;
      if (position.distanceToSquared(_endPos!) < 1 && !isWasEnd) {
        _speed *= -1;
        isWasEnd = true;
      }
      if (isWasEnd && position.distanceToSquared(_startPos) < 1) {
        isWasEnd = false;
        _speed *= -1;
      }
    }
    int pos = position.y.toInt();
    if(pos <= 0){
      pos = 1;
    }
    priority = pos;
    super.update(dt);
  }
}