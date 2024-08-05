import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/Items/chest.dart';
import 'package:game_flame/Items/loot_on_map.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/weapon/magicEffects/fireEffect.dart';
import 'package:game_flame/weapon/magicEffects/lightningEffect.dart';
import 'package:game_flame/weapon/magicEffects/poisonEffect.dart';

class ShieldLock extends SpriteComponent with HasGameRef<KyrgyzGame>
{
  ShieldLock({required super.position});

  @override
  void onLoad()async
  {
    anchor = Anchor.center;
    priority = GamePriority.maxPriority;
    final spriteSheet = SpriteSheet(image: await Flame.images.load(
        'tiles/map/loot/trans.png'),
        srcSize: Vector2.all(32));
    sprite = spriteSheet.getSprite(6, 2);
    add(OpacityEffect.by(-1,EffectController(duration: 0.5),onComplete: (){
      removeFromParent();
    }));
  }

  @override
  void update(double dt)
  {
    position.y -= 10 * dt;
  }
}

class HitBar extends PositionComponent with HasGameRef<KyrgyzGame>
{
  HitBar({required super.position,this.percentHp = 100});
  double percentHp = 100;
  late Sprite emptyBar, healthBar;
  double opacity = 1;

  @override
  void onLoad()async
  {
    size = Vector2(23,7);
    anchor = Anchor.center;
    priority = GamePriority.maxPriority;
    emptyBar = Sprite(await Flame.images.load('tiles/map/grassLand/UI/emptyBar.png'));
    healthBar = Sprite(await Flame.images.load('tiles/map/grassLand/UI/healthBar.png'));
  }

  @override
  void render(Canvas canvas)
  {
    if(opacity > 0) {
      emptyBar.render(canvas, size: size, overridePaint: Paint()
        ..color = BasicPalette.white.color.withOpacity(opacity));
      healthBar.render(canvas, size: Vector2(size.x * percentHp / 100, size.y),
          overridePaint: Paint()
            ..color = BasicPalette.white.color.withOpacity(opacity));
    }
  }

  @override
  void update(double dt)
  {
    if(opacity > 0){
      var temp = parent as PositionComponent;
      if(temp.isFlippedHorizontally && !isFlippedHorizontally){
        flipHorizontally();
      }
      if(!temp.isFlippedHorizontally && isFlippedHorizontally){
        flipHorizontally();
      }
      opacity -= dt;
      position.y -= 10 * dt;
    }
  }
}


class HitText extends TextComponent with HasGameRef<KyrgyzGame>
{
  HitText(this._text,{required super.position});
  String _text;
  final regular = TextPaint(
      style: hitStateStyle
  );

  @override
  void onLoad()async
  {
    anchor = Anchor.center;
    priority = GamePriority.maxPriority;
    text = _text;
    textRenderer = regular;
    add(TimerComponent(period: 0.5,onTick: removeFromParent));
  }

  @override
  void update(double dt)
  {
    position.y -= 10 * dt;
  }
}

class KyrgyzEnemy extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{
  bool isRefresh = true;
  int isFreeze = 0;
  double health = 0;
  double armor = 0;
  int maxLoots = 0;
  int column=0;
  int row=0;
  int id=-1;
  int variantOfHit = 0;
  SpriteAnimation? animMove, animIdle,animIdle2, animAttack,animAttack2, animHurt, animDeath;
  List<String> loots = [];
  Map<MagicDamage,int> magicDamages = {};
  Ground? groundBody;
  late BodyDef bodyDef = BodyDef(type: BodyType.dynamic,userData: BodyUserData(isQuadOptimizaion: false, onBeginMyContact: onBeginMyContact,onEndMyContact: onEndMyContact),linearDamping: 6,
      angularDamping: 6,fixedRotation: true);
  Vector2 speed = Vector2(0,0);
  double maxSpeed = 0;
  EnemyHitbox? hitBox;
  DefaultEnemyWeapon? weapon;
  bool wasHit = false;
  bool wasSeen = false;
  double chanceOfLoot = 0.01; // 0 - never
  double distPlayerLength = 0;
  int shiftAroundAnchorsForHit = 0;
  double _maxHp = 0;
  Map<BodyUserData,ObstacleWhere> myContactMap = {};
  HitBar? _hitBar;


  @override
  @mustCallSuper
  Future<void> onLoad() async
  {
    setChance();
    add(TimerComponent(onTick: checkIsNeedSelfRemove ,repeat: true,period: 2));
    _maxHp = health;
    animationTicker?.currentIndex = math.Random().nextInt(animation?.frames.length ?? 0);
    _hitBar = HitBar(position: Vector2(width * anchor.x, height * anchor.y));
    _hitBar?.opacity = 0;
    add(_hitBar!);
  }

  void onBeginMyContact(Object other, Contact contact)
  {
    ObstacleWhere temp;
    if(contact.manifold.localNormal.x.abs() > contact.manifold.localNormal.y.abs()){
      if(contact.manifold.localNormal.x > 0){
        temp = ObstacleWhere.left;
      }else{
        temp = ObstacleWhere.right;
      }
    }else{
      if(contact.manifold.localNormal.y > 0){
        temp = ObstacleWhere.up;
      }else{
        temp = ObstacleWhere.down;
      }
    }
    myContactMap[other as BodyUserData] = temp;
  }

  void onEndMyContact(Object other, Contact contact)
  {
    myContactMap.remove(other as BodyUserData);
  }

  void changeVertsInWeapon(int index){}

  void chooseHit()
  {
    weapon?.currentCoolDown = weapon!.coolDown;
    wasHit = true;
    animation = null;
    speed.x = 0;
    speed.y = 0;
    groundBody?.clearForces();
    if(animAttack2 == null){
      animation = animAttack;
      animationTicker?.onComplete = selectBehaviour;
      animationTicker?.onFrame = changeVertsInWeapon;
      return;
    }
    variantOfHit = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(variantOfHit == 0){
      animation = animAttack;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    }else{
      animation = animAttack2;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    }
    animationTicker?.onComplete = selectBehaviour;
    animationTicker?.onFrame = changeVertsInWeapon;
  }

  void moveIdleRandom(bool isSee)
  {
    int random = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
    if(random != 0 || wasHit){
      int shift = 0;
      if(position.x < gameRef.gameMap.orthoPlayer!.position.x){
        shift = -shiftAroundAnchorsForHit;
      }else{
        shift = shiftAroundAnchorsForHit;
      }
      double posX = isSee ? gameRef.gameMap.orthoPlayer!.position.x - position.x + shift : math.Random().nextDouble() * 500 - 250;
      double posY = isSee ? gameRef.gameMap.orthoPlayer!.position.y - position.y : math.Random().nextDouble() * 500 - 250;
      for(final temp in myContactMap.values){
        if(temp == ObstacleWhere.up && posY < 0){
          posY = 0;
        }
        if(temp == ObstacleWhere.down && posY > 0){
          posY = 0;
        }
        if(temp == ObstacleWhere.left && posX < 0){
          posX = 0;
        }
        if(temp == ObstacleWhere.right && posX > 0){
          posX = 0;
        }
      }
      if(posX == 0 && posY == 0){
        posX = posY = math.Random().nextDouble() * 500 - 250;
      }
      double angle = math.atan2(posY,posX);
      speed.x = math.cos(angle) * (isSee ? maxSpeed : maxSpeed / 2);
      speed.y = math.sin(angle) * (isSee ? maxSpeed : maxSpeed / 2);
      if(speed.x < 0 && !isFlippedHorizontally){
        flipHorizontally();
      }else if(speed.x > 0 && isFlippedHorizontally){
        flipHorizontally();
      }
      animation = animMove;
    }else{
      if(animation != animIdle && animation != animIdle2){
        speed.x = 0;
        speed.y = 0;
        if(animIdle2 != null){
          int rand = math.Random(DateTime.now().microsecondsSinceEpoch).nextInt(2);
          animation = rand.isOdd ? animIdle : animIdle2;
        }else {
          animation = animIdle;
        }
      }
    }
    animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
    animationTicker?.onComplete = selectBehaviour;
  }

  void selectBehaviour() {
    if (gameRef.gameMap.orthoPlayer == null) {
      return;
    }
    if (wasSeen) {
      if (isNearPlayer(distPlayerLength)) {
        weapon?.currentCoolDown = weapon?.coolDown ?? 0;
        var pl = gameRef.gameMap.orthoPlayer!;
        if (pl.position.x > position.x) {
          if (isFlippedHorizontally) {
            flipHorizontally();
          }
        }
        if (pl.position.x < position.x) {
          if (!isFlippedHorizontally) {
            flipHorizontally();
          }
        }
        chooseHit();
        return;
      }
      moveIdleRandom(true);
    } else {
      moveIdleRandom(isSee());
    }
  }

  bool isSee()
  {
    var tempW = gameRef.world as UpWorld;
    if((gameRef.gameMap.orthoPlayer!.position.x > position.x && !isFlippedHorizontally)
        || (gameRef.gameMap.orthoPlayer!.position.x < position.x && isFlippedHorizontally)
    ){
      wasSeen = !tempW.myRayCast(position * PhysicVals.physicScale, gameRef.gameMap.orthoPlayer!.position * PhysicVals.physicScale, true);
    }else{
      wasSeen = false;
    }
    return wasSeen;
  }

  void setChance()
  {
    math.Random rand = math.Random(DateTime.now().microsecondsSinceEpoch);
    for(int i=0;i<maxLoots;i++){
      double chance = rand.nextDouble();
      if(chance <= chanceOfLoot){
        var item = 'gold';
        loots.add(item);
      }
    }
  }

  @override
  void onRemove()
  {
    groundBody?.destroy();
    gameRef.gameMap.loadedLivesObjs.remove(id);
  }

  void _createSpecEffect()
  {
    final temp = ColorEffect(
      const Color(0xFFFFFFFF),
      EffectController(duration: 0.07, reverseDuration: 0.07),
      opacityFrom: 0.0,
      opacityTo: 0.4,
    );
    add(temp);
    // HitBar hBar =
    _hitBar?.opacity = 1;
    _hitBar?.percentHp = health / _maxHp * 100;
    _hitBar?.position = Vector2(width * anchor.x, height * anchor.y - 30);
    // gameRef.gameMap.container.add(ddText);
  }

  bool internalPhysHurt(double hurt,bool inArmor)
  {
    if(inArmor){
      double dd = math.max(hurt - armor, 0);
      if(dd == 0){
        ShieldLock shieldLock = ShieldLock(position: position);
        gameRef.gameMap.container.add(shieldLock);
        gameRef.gameMap.orthoPlayer!.endHit();
        return false;
      }
      health -= dd;
      if(health > 1) {
        _createSpecEffect();
      }
    }else{
      health -= hurt;
      if(health > 1) {
        _createSpecEffect();
      }
    }
    return true;
  }

  void doHurt({required double hurt, bool inArmor=true, bool isPlayer = false})
  {
    if(isPlayer){
      wasSeen = true;
    }
    if(animation == animDeath){
      return;
    }
    if(!internalPhysHurt(hurt,inArmor)){
      return;
    }
    if(health < 1){
      weapon?.collisionType = DCollisionType.inactive;
      death(animDeath);
    }else{
      if((animation == animAttack || animation == animAttack2) && animationTicker!.currentIndex > 0){
        return;
      }
      weapon?.collisionType = DCollisionType.inactive;
      animation = animHurt;
      animationTicker?.isLastFrame ?? false ? animationTicker?.reset() : null;
      animationTicker?.onComplete = selectBehaviour;
    }
  }

  void doMagicHurt({required double hurt,required MagicDamage magicDamage})
  {
    if(animation == animDeath){
      return;
    }
    internalPhysHurt(hurt,false);
    Component magicAnim;
    switch(magicDamage){
      case MagicDamage.fire:
        magicAnim = FireEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.ice:
        isFreeze++;
        magicAnim = ColorEffect(opacityTo: 0.5, BasicPalette.blue.color, EffectController(duration: 0.51,reverseDuration: 0.51), onComplete: (){isFreeze--;});
        break;
      case MagicDamage.lightning:
        magicAnim = LightningEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.none:
        magicAnim = LightningEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.poison:
        magicAnim = PoisonEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
    }
    add(magicAnim);
    if(health < 1){
      weapon?.collisionType = DCollisionType.inactive;
      death(animDeath);
    }
  }

  void death(SpriteAnimation? anim)
  {
    speed.x = 0;
    speed.y = 0;
    groundBody?.clearForces();
    groundBody?.setActive(false);
    groundBody?.destroy();
    if(loots.isNotEmpty) {
      if(loots.length > 1){
        var temp = Chest(0, myItems: loots, position: positionOfAnchor(anchor));
        gameRef.gameMap.container.add(temp);
      }else{
        var temp = LootOnMap(itemFromName(loots.first), position: positionOfAnchor(anchor));
        gameRef.gameMap.container.add(temp);
      }
    }
    animation = anim;
    hitBox?.collisionType = DCollisionType.inactive;
    animationTicker?.onComplete = () {
      add(OpacityEffect.by(-1,EffectController(duration: animationTicker?.totalDuration()),onComplete: (){

        removeFromParent();
      }));
    };
    if(id > -1) {
      gameRef.dbHandler.changeItemState(id: id,
          worldName: gameRef.gameMap.currentGameWorldData!.nameForGame,
          usedAsString: '1');
    }
  }

  bool isNearPlayer(double squaredDistance, {bool isDistanceWeapon = false})
  {
    var pl = gameRef.gameMap.orthoPlayer!;
    if(pl.hitBox == null){
      return false;
    }
    if(position.distanceToSquared(pl.position) > squaredDistance){
      return false;
    }
    if(hitBox == null){
      return false;
    }
    if((pl.hitBox!.getMinVector().y > hitBox!.getMaxVector().y || pl.hitBox!.getMaxVector().y < hitBox!.getMinVector().y) && !isDistanceWeapon){
      return false;
    }
    return true;
  }

  bool checkIsNeedSelfRemove()
  {

    int diffCol = (position.x ~/
        GameConsts.lengthOfTileSquare.x - gameRef.gameMap.column()).abs();
    int diffRow = (position.y ~/
        GameConsts.lengthOfTileSquare.y - gameRef.gameMap.row()).abs();
    if(diffCol > 2 || diffRow > 2){
      removeFromParent();
    }
    if(diffCol > 1 || diffRow > 1){
      isRefresh = false;
      return false;
    }else{
      isRefresh = true;
      return true;
    }
  }

// @override
// void render(Canvas canvas)
// {
//   super.render(canvas);
//   if(magicDamages.isNotEmpty){
//     var shader = gameRef.fireShader;
//     shader.setFloat(0,gameRef.gameMap.shaderTime);
//     shader.setFloat(1, 4); //scalse
//     shader.setFloat(2, 0); //offsetX
//     shader.setFloat(3, 0);
//     shader.setFloat(4,math.max(size.x,30)); //size
//     shader.setFloat(5,math.max(size.y,30));
//     final paint = Paint()..shader = shader;
//     canvas.drawRect(
//       Rect.fromLTWH(
//         0,
//         0,
//         math.max(size.x,30),
//         math.max(size.y,30),
//       ),
//       paint,
//     );
//   }
// }

}