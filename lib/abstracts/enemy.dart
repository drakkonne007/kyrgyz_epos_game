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
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/RenderText.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/liveObjects/mini_creatures/npcDialogAttention.dart';
import 'package:game_flame/overlays/game_styles.dart';
import 'package:game_flame/weapon/enemy_weapons_list.dart';
import 'package:game_flame/weapon/magicEffects/fireEffect.dart';
import 'package:game_flame/weapon/magicEffects/lightningEffect.dart';
import 'package:game_flame/weapon/magicEffects/poisonEffect.dart';


final List<String> _humanLanguage =
    [
      'Ай, больно',
      'Ауч!',
      'Перестань',
      'Будешь так делать - я тебя побью',
      'Хватит',
      'У тебя плохое настроение?',
      'Ну хвааааатит',
      'Уфффф, тяжёлый день',
      'Хорош уже',
      'Не бей меня',
      'Заканчивай',
      'Я же сильнее',
      'Мне больно',
    ];

final List<String> _beastLanguage =
[
  'Ааррррр',
  'Вучл',
  'Уууууууу',
  'Аргх аргх кну',
  'Хныыыыы',
  'Ммммрррраааау',
  'Хввввссссс',
  'Уррррррва',
  'Зиииииииибо',
  'Ввввврррврврв',
  'Хыыыыыыыы',
  'Арзрзрзвы',
  'Брбрбрбрбрбрб',
];



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
    int version = math.Random().nextInt(3);
    sprite = spriteSheet.getSprite(6, version);
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
    if(!isMounted){
      return;
    }
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
  KyrgyzEnemy({required this.id, required this.level, this.isHigh = false, this.loots
    ,this.beast = false
    ,required this.citizen
    ,required this.quest
    ,required this.startTrigger
    ,required this.endTrigger});
  bool isRefresh = true;
  String? quest;
  int? startTrigger;
  int? endTrigger;
  int level;
  bool citizen;
  int isFreeze = 0;
  double health = 0;
  double armor = 0;
  int maxLoots = 0;
  int column=0;
  int row=0;
  int id;
  int _countOfDamages = 0;
  int dopPriority = 0;
  double highQuest = 0;
  int variantOfHit = 0;
  SpriteAnimation? animMove, animIdle,animIdle2, animAttack,animAttack2, animHurt, animDeath;
  List<Item>? loots;
  Set<MagicDamage> magicDamages = {};
  Ground? groundBody;
  late BodyDef bodyDef = BodyDef(type: BodyType.dynamic,userData: BodyUserData(isQuadOptimizaion: false, onBeginMyContact: onBeginMyContact,onEndMyContact: onEndMyContact),linearDamping: 6,
      angularDamping: 6,fixedRotation: true);
  Vector2 speed = Vector2(0,0);
  double maxSpeed = 0;
  EnemyHitbox? hitBox;
  DefaultEnemyWeapon? weapon;
  bool wasHit = false;
  bool wasSeen = false;
  double chanceOfLoot = 0.1; // 0 - never
  double distPlayerLength = 0;
  int shiftAroundAnchorsForHit = 0;
  double _maxHp = 0;
  Map<BodyUserData,ObstacleWhere> myContactMap = {};
  HitBar? _hitBar;
  double magicScaleFire = 1;
  double magicScalePoison = 1;
  double magicScaleElectro = 1;
  double magicScaleFreeze = 1;
  bool isHigh = false;
  bool isReverseBody = false;
  int _attacksCount = 0;
  bool _isKilled = false;
  bool beast = false;
  ObjectHitbox? _dialog = null;


  @override
  @mustCallSuper
  Future<void> onLoad() async
  {
    maxSpeed += (math.Random().nextInt(10) - 5);
    // health += (math.Random().nextInt(6) - 3);
    setChance();
    gameRef.gameMap.checkRemoveItself.addListener(checkIsNeedSelfRemove);
    _maxHp = health;
    animationTicker?.currentIndex = math.Random().nextInt(animation?.frames.length ?? 0);
    _hitBar = HitBar(position: Vector2(width * anchor.x, height * anchor.y));
    _hitBar?.opacity = 0;
    add(_hitBar!);
    if(!isHigh) {
      add(TimerComponent(period: 0.6, repeat: true, onTick: checkPriority));
    }
    if(quest != null){
      citizen = true;
    }
    if(citizen){
      _dialog = ObjectHitbox(getPointsForActivs(Vector2(-30,dopPriority.toDouble() - 30), Vector2.all(60)), collisionType: DCollisionType.active,
          isSolid: true,isStatic: false, isLoop: true, game: gameRef, obstacleBehavoiur: getBuyMenu, autoTrigger: false);
      add(_dialog!);
      if(quest != null){
        final questDialog = NpcDialogAttention(gameRef.quests[quest]!.isDone, position: Vector2(width * anchor.x, height * anchor.y + highQuest - 25), buy: quest == 'buy');
        if(isFlippedHorizontally){
          questDialog.flipHorizontally();
        }
        add(questDialog);
      }
    }
  }

  void createArghText()
  {
      if(beast){
        int rand = math.Random().nextInt(_beastLanguage.length);
        createText(text: _beastLanguage[rand], gameRef: gameRef, position: position);
      }else{
        int rand = math.Random().nextInt(_humanLanguage.length);
        createText(text: _humanLanguage[rand], gameRef: gameRef, position: position);
      }
  }

  void getBuyMenu()async
  {
    if(quest != null) {
      if(quest == 'buy'){
        gameRef.doBuyMenu();
        return;
      }
      var answer = gameRef.quests[quest]!;
      if(answer.currentState >= startTrigger! && answer.currentState <= endTrigger!) {
        gameRef.doDialogHud(quest!);
      }
    }else{
      createSmallMapDialog(gameRef: gameRef);
    }
  }

  void checkPriority()
  {
    priority = position.y.toInt() + dopPriority;
  }

  @override
  void flipHorizontally()
  {
    super.flipHorizontally();
    _hitBar?.flipHorizontally();
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
      if(isReverseBody){
        if (speed.x < 0 && isFlippedHorizontally) {
          flipHorizontally();
        } else if (speed.x > 0 && !isFlippedHorizontally) {
          flipHorizontally();
        }
      }else{
        if (speed.x < 0 && !isFlippedHorizontally) {
          flipHorizontally();
        } else if (speed.x > 0 && isFlippedHorizontally) {
          flipHorizontally();
        }
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
    weapon?.collisionType = DCollisionType.inactive;
    if(citizen){
      moveIdleRandom(false);
      return;
    }
    if (gameRef.gameMap.orthoPlayer == null) {
      return;
    }
    bool isReallyWantHit = true;
    if(_attacksCount > 2){
      isReallyWantHit = math.Random().nextBool();
    }
    if (wasSeen && isReallyWantHit) {
      if (isNearPlayer(distPlayerLength)) {
        weapon?.currentCoolDown = weapon?.coolDown ?? 0;
        var pl = gameRef.gameMap.orthoPlayer!;
        if(isReverseBody){
          if (pl.position.x > position.x && !isFlippedHorizontally) {
            flipHorizontally();
          }
          if (pl.position.x < position.x && isFlippedHorizontally) {
            flipHorizontally();
          }
        }else{
          if (pl.position.x > position.x && isFlippedHorizontally) {
            flipHorizontally();
          }
          if (pl.position.x < position.x && !isFlippedHorizontally) {
            flipHorizontally();
          }
        }
        _attacksCount++;
        chooseHit();
        return;
      }
      _attacksCount = 0;
      moveIdleRandom(true);
    } else {
      _attacksCount = 0;
      moveIdleRandom(isSee());
    }
  }

  bool isSee()
  {
    if(citizen){
      return false;
    }
    var tempW = gameRef.world as UpWorld;
    if(isReverseBody){
      if((gameRef.gameMap.orthoPlayer!.position.x > position.x && isFlippedHorizontally)
          || (gameRef.gameMap.orthoPlayer!.position.x < position.x && !isFlippedHorizontally)
      ){
        wasSeen = !tempW.myRayCast(position * PhysicVals.physicScale, gameRef.gameMap.orthoPlayer!.position * PhysicVals.physicScale, true);
      }else{
        wasSeen = false;
      }
    }else{
      if((gameRef.gameMap.orthoPlayer!.position.x > position.x && !isFlippedHorizontally)
          || (gameRef.gameMap.orthoPlayer!.position.x < position.x && isFlippedHorizontally)
      ){
        wasSeen = !tempW.myRayCast(position * PhysicVals.physicScale, gameRef.gameMap.orthoPlayer!.position * PhysicVals.physicScale, true);
      }else{
        wasSeen = false;
      }
    }
    return wasSeen;
  }

  void setChance()
  {
    if(loots != null){
      return;
    }
    loots = [];
    math.Random rand = math.Random(DateTime.now().microsecondsSinceEpoch);
    for(int i=0;i<maxLoots;i++){
      double chance = rand.nextDouble();
      if(chance <= chanceOfLoot){
        loots!.add(itemFromLevel(level));
      }
    }
  }

  @override
  void onRemove()
  {
    groundBody?.destroy();
    if(_isKilled){
      gameRef.gameMap.add(TimerComponent(period: 2, repeat: true, onTick: (){
        int diffCol = (position.x ~/
            GameConsts.lengthOfTileSquare.x - gameRef.gameMap.column()).abs();
        int diffRow = (position.y ~/
            GameConsts.lengthOfTileSquare.y - gameRef.gameMap.row()).abs();
        if(diffCol > 2 || diffRow > 2){
          gameRef.gameMap.loadedLivesObjs.remove(id);
        }
      }));
    }else {
      gameRef.gameMap.loadedLivesObjs.remove(id);
    }
    gameRef.gameMap.checkRemoveItself.removeListener(checkIsNeedSelfRemove);
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
    if(citizen){
      _countOfDamages++;
      if(_countOfDamages > 5 && quest == null){
        citizen = false;
        _dialog?.collisionType = DCollisionType.inactive;
      }
      createArghText();
    }
    if(inArmor){
      double dd = math.max(hurt * armor, 0);
      if(dd == 0){
        ShieldLock shieldLock = ShieldLock(position: position);
        gameRef.gameMap.container.add(shieldLock);
        gameRef.gameMap.orthoPlayer!.endHit();
        return false;
      }
      if(!citizen) {
        health -= dd;
      }
      if(health > 1) {
        _createSpecEffect();
      }
    }else{
      if(!citizen) {
        health -= hurt;
      }
      if(health > 1) {
        _createSpecEffect();
      }
    }
    return true;
  }

  void doHurt({required double hurt, bool inArmor=true})
  {
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
      if((animation == animAttack || animation == animAttack2) && animationTicker!.currentIndex > 2){
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
        isFreeze = 0;
        magicAnim = FireEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.ice:
        if(isFreeze < 0){
          isFreeze = 0;
        }
        weapon?.collisionType = DCollisionType.inactive;
        isFreeze++;
        magicAnim = ColorEffect(opacityTo: 0.5, BasicPalette.blue.color, EffectController(duration: 0.51 * magicScaleFreeze,reverseDuration: 0.51 * magicScaleFreeze), onComplete: (){isFreeze--;});
        break;
      case MagicDamage.lightning:
        magicAnim = LightningEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.none:
        throw 'NON MAGIC HAS MAGIC DAMAGE!!!';
        magicAnim = LightningEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.poison:
        magicAnim = PoisonEffect(position: Vector2(width * anchor.x, height * anchor.y));
        break;
      case MagicDamage.copyOfPlayer:
        magicAnim = LightningEffect(position: Vector2(width * anchor.x, height * anchor.y));
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
    _isKilled = true;
    gameRef.playerData.addLevel(_maxHp);
    speed.x = 0;
    speed.y = 0;
    groundBody?.clearForces();
    groundBody?.setActive(false);
    groundBody?.destroy();
    for(int i=0;i<loots!.length;i++){
      var temp = LootOnMap(loots![i], position: positionOfAnchor(anchor) + Vector2(i * 15, 0));
      gameRef.gameMap.container.add(temp);
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
          used: true);
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