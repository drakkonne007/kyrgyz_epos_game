import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/kyrgyz_game.dart';


class Portal extends SpriteAnimationComponent with HasGameRef<KyrgyzGame> {

  final Vector2 targetPos;
  final String toWorld;
  final Set<String>? nedeedKilledBosses;
  final Set<String>? neededItems;
  final String? world;
  final String? antiDialog;
  final String _noNeededKilledBoss = 'Чья-то живая душа не даёт войти сюда';
  final String _noNeededItem = 'Чья-то живая душа не даёт войти сюда';

  Portal({required super.position, required this.targetPos, required this.toWorld, required this.nedeedKilledBosses, required this.neededItems, required this.antiDialog, required this.world});

  @override
  Future<void> onLoad() async
  {
    anchor = Anchor.center;
    size = Vector2(40,30);
    add(ObjectHitbox(getPointsForActivs(-size / 2, size),
        collisionType: DCollisionType.active,
        isSolid: true,
        isStatic: false,
        obstacleBehavoiur: portal,
        autoTrigger: false,
        isLoop: true,
        game: gameRef));
    final img = await Flame.images.load('images/portalAnim.png');
    final spriteSheet = SpriteSheet(image: img, srcSize: Vector2(img.width / 6, img.height / 5));
    List<Sprite> sprs = [];
    List<double> times = [];
    for(int row = 0; row < 5; row++){
      for(int column = 0; column < 6; column++){
        sprs.add(spriteSheet.getSprite(row, column));
        times.add(0.08);
      }
    }
    animation = SpriteAnimation.variableSpriteList(sprs, stepTimes: times);
  }

  void portal() async
  {
    if(nedeedKilledBosses != null){
      for(final str in nedeedKilledBosses!){
        int cur = int.parse(str);
        var answ = await gameRef.dbHandler.getItemStateFromDb(cur,world ?? gameRef.gameMap.currentGameWorldData!.nameForGame);
        if(!answ.used){
          createText(text: antiDialog ?? _noNeededKilledBoss,gameRef: gameRef);
          return;
        }
      }
    }
    if(neededItems != null){
      var setItems = gameRef.playerData.itemInventar.keys.toSet();
      if(!setItems.containsAll(neededItems!)){
        createText(text: antiDialog ?? _noNeededItem,gameRef: gameRef);
        return;
      }
      for(final myNeeded in neededItems!) {
        Item temp = itemFromName(myNeeded);
        temp.getEffectFromInventar(gameRef);
      }
    }
    gameRef.playerData.playerBigMap = getWorldFromName(toWorld);
    gameRef.playerData.startLocation = targetPos;
    await gameRef.loadNewMap();
    await gameRef.saveGame();
  }
}