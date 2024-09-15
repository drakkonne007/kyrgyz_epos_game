import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/kyrgyz_game.dart';

class Chest extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  Chest(this._level,{this.nedeedKilledBosses, this.neededItems, required this.myItems
    ,required super.position,
    super.anchor = Anchor.center,
    this.isStatic = false,
    this.id
  });
  Set<String>? nedeedKilledBosses;
  final String _noNeededItem = 'Нет нужного предмета...';
  final String _noNeededKilledBoss = 'Сначала победите хозяина';

  Set<String>? neededItems;
  List<Item> myItems;
  final int _level;
  final Vector2 _spriteSheetSize = Vector2(64,64);
  late Image _spriteImg;
  late SpriteSheet _spriteSheet;
  ObjectHitbox? _objectHitbox;
  bool isStatic = false;
  int? id;

  @override
  Future onLoad() async
  {
    if(isStatic && id == null){
      throw 'Error in create static chest';
    }
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
    _objectHitbox = ObjectHitbox(getPointsForActivs(Vector2.all(-15), Vector2.all(30)),
        collisionType: DCollisionType.active, isSolid: true, isStatic: false, isLoop: true,
        autoTrigger: false, obstacleBehavoiur: checkIsIOpen, game: gameRef);
    // var asd = ObjectHitbox(obstacleBehavoiur: checkIsIOpen);
    add(_objectHitbox!);
    priority = position.y.toInt() + 17;
  }

  void checkIsIOpen()
  {
    if(nedeedKilledBosses != null){
      if(!gameRef.playerData.killedBosses.containsAll(nedeedKilledBosses!)){
        createText(text: _noNeededKilledBoss,gameRef: gameRef);
        return;
      }
    }
    if(neededItems != null){
      var setItems = gameRef.playerData.itemInventar.keys.toSet();
      if(!setItems.containsAll(neededItems!)){
        createText(text: _noNeededItem,gameRef: gameRef);
        return;
      }
      for(final myNeeded in neededItems!) {
        Item temp = itemFromName(myNeeded);
        temp.getEffectFromInventar(gameRef);
      }
    }
    remove(_objectHitbox!);
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.08, from: 0, loop: false);
    for (int i = 0; i<myItems.length;i++) {
      gameRef.gameMap.container.add(LootOnMap(myItems[i], position: position + Vector2(-20,20) + Vector2(i * 15,0)));
    }
    add(OpacityEffect.by(-1,EffectController(duration: animationTicker!.totalDuration() + 0.3),onComplete: (){
      if(isStatic) {
        gameRef.gameMap.loadedLivesObjs.remove(id);
      }
      removeFromParent();
    }));
    if(id != null) {
      gameRef.dbHandler.changeItemState(id: id!, worldName: gameRef.gameMap.currentGameWorldData!.nameForGame, used: true, opened: true);
    }
  }
}