import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/abstracts/EnemyInfo.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/weapon/player_weapons_list.dart';

final List<Vector2> _weaponPoints160 = [
  Vector2(-8.69632,-55.9686)
  ,Vector2(-6.89958,73.1721)
  ,Vector2(10.8432,73.3967)
  ,Vector2(9.04649,-56.1932)
  ,];

final List<Vector2> _weaponPoints46 = [
Vector2(-4.1881,-17.6679)
,Vector2(-4.27697,18.2347)
,Vector2(12.2525,17.9681)
,Vector2(12.6968,-18.29)
,];

final List<Vector2> _weaponPoints96 = [
Vector2(-3.14863,-29.0244)
,Vector2(-6.72195,41.826)
,Vector2(11.6375,42.0724)
,Vector2(14.5948,-29.5173)
,];

class LightningTrap extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  late DefaultEnemyWeapon _weapon;
  late DefaultPlayerWeapon _playerWeapon;
  final double srcHeight;
  LightningTrap({required super.position, required this.srcHeight,});
  late SpriteAnimation _runAnim, _fadeAnim;

  @override onLoad() async
  {
    anchor = Anchor.center;
    priority = GamePriority.foregroundTile - 1;
    String source = 'tiles/map/mountainLand/Props/Animated props/lightning-4Tiles.png';
    String source2 = 'tiles/map/mountainLand/Props/Animated props/lightning-4Tiles-fading out.png';
    switch(srcHeight){
      case 46:
        source = 'tiles/map/mountainLand/Props/Animated props/lightning-1Tile.png';
        source2 = 'tiles/map/mountainLand/Props/Animated props/lightning-1Tile-fading out.png';
        break;
      case 96:
        source = 'tiles/map/mountainLand/Props/Animated props/lightning-2Tiles.png';
        source2 = 'tiles/map/mountainLand/Props/Animated props/lightning-2Tiles-fading out.png';
        break;
    }
    final imgRun = await Flame.images.load(source);
    final imgFade = await Flame.images.load(source2);
    var spriteSheet = SpriteSheet(
      image: imgRun,
      srcSize: Vector2(imgRun.width / 20,imgRun.height * 1.0),
    );
    _runAnim = spriteSheet.createAnimation(row: 0, stepTime: 0.1,from: 0, loop: false);

    spriteSheet = SpriteSheet(
      image: imgFade,
      srcSize: Vector2(imgRun.width / 10,imgRun.height * 1.0),
    );
    _fadeAnim = spriteSheet.createAnimation(row: 1, stepTime: 0.1,from: 0, loop: false);
    animation = _runAnim;
    animationTicker?.onComplete = changeToFade;
    _weapon = DefaultEnemyWeapon(srcHeight == 96 ? _weaponPoints96 : srcHeight == 160 ? _weaponPoints160 : _weaponPoints46 , collisionType: DCollisionType.active, isStatic: false, game: gameRef);
    _weapon.damage = ElectroTrapInfo.damage(gameRef.playerData.playerLevel.value);
    _weapon.coolDown = 0.75;
    _playerWeapon = DefaultPlayerWeapon(srcHeight == 96 ? _weaponPoints96 : srcHeight == 160 ? _weaponPoints160 : _weaponPoints46 , collisionType: DCollisionType.active, isStatic: false, game: gameRef);
    _playerWeapon.damage = ElectroTrapInfo.damage(gameRef.playerData.playerLevel.value) / 10;
    _playerWeapon.coolDown = 0.75;
    add(_weapon);
    add(_playerWeapon);
  }

  void changeToFade()
  {
    animation = _fadeAnim;
    animationTicker?.onComplete = (){
      _weapon.collisionType = DCollisionType.inactive;
      _playerWeapon.collisionType = DCollisionType.inactive;
      add(TimerComponent(period: 2.5,onTick: (){
        animation = _runAnim;
        _weapon.collisionType = DCollisionType.active;
        _playerWeapon.collisionType = DCollisionType.active;
        animationTicker?.onComplete = (){
          changeToFade();
        };
      }));
    };
  }
}