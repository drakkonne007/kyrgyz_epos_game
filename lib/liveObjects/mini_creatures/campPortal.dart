// portal-on flat surface-cemetery-all animations(standby-opening-opened-closing)-290x192

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/abstracts/obstacle.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

class CampPortalUp extends SpriteAnimationComponent
{

  CampPortalUp(this._startPos);
  final Vector2 _startPos;

  @override onLoad() async
  {
    anchor = const Anchor(0.5,1);
    position = _startPos - Vector2(0,95/1.5);
    size = Vector2(290/1.5,96/1.5);
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/ancientLand/Props/portal-on flat surface-cemetery-all animations(standby-opening-opened-closing)-290x192.png'),
      srcSize: Vector2(290,96),
    );
    List<Sprite> sprites = [];
    for(int row = 0; row < 6; row+=2){
      for(int col = 0; col < 8; col++){
        sprites.add(spriteSheet.getSprite(row,col));
      }
    }
    for(int i = 0;i<6;i++){
      sprites.add(spriteSheet.getSprite(6,i));
    }
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.14);
  }
}

class CampPortalDown extends SpriteAnimationComponent with HasGameRef<KyrgyzGame>
{

  CampPortalDown(this._startPos);
  final Vector2 _startPos;
  late Ground firstGround;
  late Ground secGround;

  @override onLoad() async
  {
    anchor = const Anchor(0.5,1);
    position = _startPos;
    size = Vector2(290/1.5,96/1.5);
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load('tiles/map/ancientLand/Props/portal-on flat surface-cemetery-all animations(standby-opening-opened-closing)-290x192.png'),
      srcSize: Vector2(290,96),
    );
    List<Sprite> sprites = [];
    for(int row = 1; row < 6; row+=2){
      for(int col = 0; col < 8; col++){
        sprites.add(spriteSheet.getSprite(row,col));
      }
    }
    for(int i = 0;i<6;i++){
      sprites.add(spriteSheet.getSprite(7,i));
    }
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.14);

    final List<Vector2> points2 = [
    ((Vector2(168,178)  - Vector2(145,192)) / 1.5) * PhysicVals.physicScale,
    ((Vector2(168,96)   - Vector2(145,192)) / 1.5) * PhysicVals.physicScale,
    ((Vector2(229,96)   - Vector2(145,192)) / 1.5) * PhysicVals.physicScale,
    ((Vector2(226,110)  - Vector2(145,192)) / 1.5) * PhysicVals.physicScale,
    ((Vector2(244,129)  - Vector2(145,192)) / 1.5) * PhysicVals.physicScale,
    ((Vector2(246,141)  - Vector2(145,192)) / 1.5) * PhysicVals.physicScale,
    ((Vector2(266,148)  - Vector2(145,192)) / 1.5) * PhysicVals.physicScale,
    ((Vector2(251,176)  - Vector2(145,192)) / 1.5) * PhysicVals.physicScale,
    ];

    final List<Vector2> points = [
      (Vector2(127,178)   - Vector2(145,192) ) / 1.5 * PhysicVals.physicScale,
      (Vector2(127,96)    - Vector2(145,192) ) / 1.5 * PhysicVals.physicScale,
      (Vector2(67,96)     - Vector2(145,192) ) / 1.5 * PhysicVals.physicScale,
      (Vector2(28,163)    - Vector2(145,192) ) / 1.5 * PhysicVals.physicScale,
    ];
    
    ObjectHitbox obj = ObjectHitbox(getPointsForActivs(Vector2(-10,-70), Vector2(20,30)),
    collisionType: DCollisionType.active,isSolid:true,isLoop:true,game:gameRef,isStatic:false, obstacleBehavoiur: openCampTeleportMenu
    ,autoTrigger: false);
    add(obj);

    BodyDef bd = BodyDef(userData: BodyUserData(isQuadOptimizaion: false), position: _startPos * PhysicVals.physicScale);
    firstGround = Ground(bd, gameRef.world.physicsWorld);
    firstGround.createFixture(FixtureDef(PolygonShape()..set(points)));
    BodyDef bd2 = BodyDef(userData: BodyUserData(isQuadOptimizaion: false), position: _startPos * PhysicVals.physicScale,);
    secGround = Ground(bd2, gameRef.world.physicsWorld);
    secGround.createFixture(FixtureDef(PolygonShape()..set(points2)));
  }

  @override
  void onRemove()
  {
    gameRef.world.destroyBody(firstGround);
    gameRef.world.destroyBody(secGround);
  }



  void openCampTeleportMenu()
  {

  }
}