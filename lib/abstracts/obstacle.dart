import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_forge2d/forge2d_world.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/kyrgyz_game.dart';

abstract class MapObstacle extends BodyComponent with ContactCallbacks
{
  MapObstacle(this._vertices, {required this.collisionType, this.isSolid = false, required this.isStatic, this.isLoop = false, required this.gameKyrgyz,this.column, this.row, this.radius = 0, this.isOnlyForStatic = false, });

  List<Vector2> _vertices;
  DCollisionType collisionType;
  bool isSolid;
  bool isStatic;
  bool isLoop;
  double angle = 0;
  Vector2 scale = Vector2(1, 1);
  Vector2 _center = Vector2(0, 0);
  Set<Vector2> obstacleIntersects = {};
  KyrgyzGame gameKyrgyz;
  int? column;
  int? row;
  double width = 0;
  double height = 0;
  bool onlyForPlayer = false;
  final Vector2 _minCoords = Vector2(0, 0);
  final Vector2 _maxCoords = Vector2(0, 0);
  Vector2? transformPoint;
  double radius = 0;
  bool isOnlyForStatic;
  bool _isTrueRect = false;

  bool get isTrueRect => _isTrueRect && angle == 0;
  List<Vector2> get vertices => _vertices;
  Vector2 get rawCenter => _center;
  bool get isCircle => radius != 0;

  @override
  Body createBody() {
      if(vertices.length == 2){
        final shape = EdgeShape()..set(vertices[0], vertices[1]);
        final fixtureDef = FixtureDef(shape, friction: 0.3,);
        final bodyDef = BodyDef(
          position: Vector2.zero(),
        );
        return world.createBody(bodyDef)..createFixture(fixtureDef);
      }else if(vertices.length > 2){
        final shape = PolygonShape()..set(vertices);
        final fixtureDef = FixtureDef(shape, friction: 0.3,);
        final bodyDef = BodyDef(
          position: Vector2.zero(),
        );
        return world.createBody(bodyDef)..createFixture(fixtureDef);
      }
      return world.createBody(BodyDef());
    }

  @override
  bool onComponentTypeCheck(DCollisionEntity other)
  {
    if(other is GroundHitBox) {
      return true;
    }
    return false;
  }
}