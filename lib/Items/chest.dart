import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

const double _heightOfChest = 52.5 - 35;

class Chest extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  Chest(this._level,{this.nedeedKilledBosses, this.neededItems, required this.myItems
    ,Sprite? sprite,
    bool? autoResize,
    required super.position,
    Vector2? size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor = Anchor.center,
    super.priority}){
    _startPosition = position;
  }
  Set<int>? nedeedKilledBosses;
  Vector2? _startPosition;
  Set<String>? neededItems;
  List<Item> myItems;
  final int _level;
  final Vector2 _spriteSheetSize = Vector2(64,64);
  late Image _spriteImg;
  late SpriteSheet _spriteSheet;
  ObjectHitbox? _objectHitbox;
  bool isStatic = false;

  @override
  Future onLoad() async
  {
    switch(_level){
      case 0: _spriteImg = await Flame.images.load(
          'tiles/map/grassLand/Props/treasure chest lvl 1-opening animation-standard style.png'); break;
      case 1: _spriteImg = await Flame.images.load(
          'tiles/map/grassLand/Props/treasure chest lvl 2-opening animation-standard style.png'); break;
      case 2: _spriteImg = await Flame.images.load(
          'tiles/map/grassLand/Props/treasure chest lvl 3-opening animation-standard style.png'); break;
    }
    _spriteSheet = SpriteSheet(image: _spriteImg,
        srcSize: _spriteSheetSize);
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, to: 1, loop: false);
    size = Vector2.all(70);
    anchor = Anchor.center;
    _objectHitbox = ObjectHitbox(getPointsForActivs(Vector2.all(-35), size),
        collisionType: DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
        autoTrigger: false, obstacleBehavoiur: checkIsIOpen, game: gameRef);
    // var asd = ObjectHitbox(obstacleBehavoiur: checkIsIOpen);
    add(_objectHitbox!);
  }

  void checkIsIOpen()
  {
    if(nedeedKilledBosses != null){
      if(!gameRef.playerData.killedBosses.containsAll(nedeedKilledBosses!)){
        print('not kill needed boss');
        return;
      }
    }
    if(neededItems != null){
      for(final myNeeded in neededItems!) {
        bool isNeed = true;
        for(final playerHas in gameRef.playerData.itemInventar.keys){
          if(playerHas == myNeeded){
            isNeed = false;
            break;
          }
        }
        if(isNeed){
          print('not has nedeed item');
          return;
        }
      }
    }
    remove(_objectHitbox!);
    game.gameMap.currentObject.value = null;
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    double dur = SpriteAnimationTicker(animation!).totalDuration();
    for(final myItem in myItems){
      myItem.getEffect(gameRef);
    }
    add(OpacityEffect.by(-1,EffectController(duration: dur + 0.3),onComplete: (){
      if(isStatic) {
        gameRef.gameMap.loadedLivesObjs.remove(_startPosition);
      }
      removeFromParent();
    }));
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    if(position.y + _heightOfChest > gameRef.gameMap.orthoPlayer!.hitBox!.getMaxVector().y){
      parent = gameRef.gameMap.enemyOnPlayer;
    }else{
      parent = gameRef.gameMap.enemyComponent;
    }
  }


}