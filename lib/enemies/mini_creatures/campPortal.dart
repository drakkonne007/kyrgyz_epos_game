// portal-on flat surface-cemetery-all animations(standby-opening-opened-closing)-290x192

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/Obstacles/ground.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
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
      (Vector2(168,178)  - Vector2(145,192)) / 1.5,
      (Vector2(168,96)   - Vector2(145,192)) / 1.5,
      (Vector2(229,96)   - Vector2(145,192)) / 1.5,
      (Vector2(226,110)  - Vector2(145,192)) / 1.5,
      (Vector2(244,129)  - Vector2(145,192)) / 1.5,
      (Vector2(246,141)  - Vector2(145,192)) / 1.5,
      (Vector2(266,148)  - Vector2(145,192)) / 1.5,
      (Vector2(251,176)  - Vector2(145,192)) / 1.5,
    ];

    final List<Vector2> points = [
      (Vector2(127,178)   - Vector2(145,192) ) / 1.5,
      (Vector2(127,96)    - Vector2(145,192) ) / 1.5,
      (Vector2(67,96)     - Vector2(145,192) ) / 1.5,
      (Vector2(28,163)    - Vector2(145,192) ) / 1.5,
    ];
    
    ObjectHitbox obj = ObjectHitbox(getPointsForActivs(Vector2(-10,-70), Vector2(20,30)),
    collisionType: DCollisionType.active,isSolid:true,isLoop:true,game:gameRef,isStatic:false, obstacleBehavoiur: openCampTeleportMenu
    ,autoTrigger: false);
    add(obj);
    
    Ground ground = Ground(points, collisionType: DCollisionType.active,isSolid:false,isLoop:true,game:gameRef,isStatic:false);
    add(ground);
    ground = Ground(points2, collisionType: DCollisionType.active,isSolid:false,isLoop:true,game:gameRef,isStatic:false);
    add(ground);
  }

  void openCampTeleportMenu()
  {

  }
}