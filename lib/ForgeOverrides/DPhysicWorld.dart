


import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/forge2d.dart' as forge2d;
import 'package:game_flame/ForgeOverrides/broadphase.dart';
import 'package:game_flame/components/tile_map_component.dart';

class BodyUserData
{
  BodyUserData({this.loadedColumnRow, this.isQuadOptimizaion = true});
  LoadedColumnRow? loadedColumnRow;
  bool isQuadOptimizaion;
}

class UpWorld extends Forge2DWorld
{
  UpWorld({
    Vector2? gravity,
    BroadPhase? broadPhase,
    forge2d.ContactListener? contactListener,
    super.children,
  }) : physicsWorld = DWorld(gravity ?? defaultGravity,MyBroadPhase())
    ..setContactListener(contactListener ?? WorldContactListener());

  static final Vector2 defaultGravity = Vector2(0, 0);

  @override
  final forge2d.World physicsWorld;

  @override
  void update(double dt) {
    physicsWorld.stepDt(dt);
  }

  @override
  Body createBody(BodyDef def) {
    return physicsWorld.createBody(def);
  }

  @override
  void destroyBody(Body body) {
    physicsWorld.destroyBody(body);
  }

  @override
  void createJoint(forge2d.Joint joint) {
    physicsWorld.createJoint(joint);
  }

  @override
  void destroyJoint(forge2d.Joint joint) {
    physicsWorld.destroyJoint(joint);
  }

  @override
  void raycast(RayCastCallback callback, Vector2 point1, Vector2 point2) {
    physicsWorld.raycast(callback, point1, point2);
  }

  @override
  void clearForces() {
    physicsWorld.clearForces();
  }

  @override
  void queryAABB(forge2d.QueryCallback callback, AABB aabb) {
    physicsWorld.queryAABB(callback, aabb);
  }

  @override
  void raycastParticle(
      forge2d.ParticleRaycastCallback callback,
      Vector2 point1,
      Vector2 point2,
      ) {
    physicsWorld.particleSystem.raycast(callback, point1, point2);
  }

  /// Don't change the gravity object directly, use the setter instead.
  @override
  Vector2 get gravity => physicsWorld.gravity;

  /// Sets the gravity of the world and wakes up all bodies.
  @override
  set gravity(Vector2? gravity) {
    physicsWorld.gravity = gravity ?? defaultGravity;
    for (final body in physicsWorld.bodies) {
      body.setAwake(true);
    }
  }
}

class DWorld extends World
{
  DWorld(super.gravity, super.broadPhase);
  Map<LoadedColumnRow, List<Body>> allEls = {};
  List<Body> activeBody = [];
  LoadedColumnRow _currentQuad = LoadedColumnRow(0, 0);

  void changeActiveBodies(LoadedColumnRow columnRow)
  {
    assert(!isLocked);
    bodies.clear();
    bodies.addAll(activeBody);
    int xCoord = columnRow.column - 3;
    int yCoord = columnRow.row - 3;
    int xEnd = xCoord + 3;
    int yEnd = yCoord + 3;
    for(xCoord;xCoord < xEnd;xCoord++){
      for(yCoord;yCoord < yEnd;yCoord++){
        allEls[LoadedColumnRow(xCoord, yCoord)]?.forEach((body){
          bodies.add(body);
        });
      }
    }
    _currentQuad = columnRow;
    var tempBroad =  contactManager.broadPhase as MyBroadPhase;
    tempBroad.bodies = List.unmodifiable(bodies);
  }

  void resetWorld()
  {
    print('All bodies was delete');
    assert(!isLocked);
    flags |= World.locked;
    for(final key in allEls.keys){
       for (var el in allEls[key]!) {
         destroyBody(el);
       }
    }
    bodies.clear();
    allEls.clear();
    activeBody.clear();
    flags &= ~World.locked;
  }

  @override
  Body createBody(BodyDef def)
  {
    assert(!isLocked);
    final body = Body(def, this);
    if(def.userData != null && def.userData is BodyUserData){
      var data = def.userData as BodyUserData;
      if(data.isQuadOptimizaion){
        assert(data.loadedColumnRow != null);
        allEls.putIfAbsent(data.loadedColumnRow!, () => []);
        allEls[data.loadedColumnRow]!.add(body);
      }else{
        activeBody.add(body);
      }
    }else{
      activeBody.add(body);
    }
    return body;
  }

  void addCustomBody(Body body)
  {
    if(body.userData != null && body.userData is BodyUserData){
      var data = body.userData as BodyUserData;
      if(data.isQuadOptimizaion){
        assert(data.loadedColumnRow != null);
        allEls.putIfAbsent(data.loadedColumnRow!, () => []);
        allEls[data.loadedColumnRow]!.add(body);
      }else{
        activeBody.add(body);
      }
    }else{
      activeBody.add(body);
    }
  }

  @override
  void destroyBody(Body body)
  {
    if(bodies.isEmpty){
      return;
    }
    // assert(bodies.isNotEmpty);
    assert(!isLocked);

    // Delete the attached joints.
    while (body.joints.isNotEmpty) {
      final joint = body.joints.first;
      destroyListener?.onDestroyJoint(joint);
      destroyJoint(joint);
    }

    // Delete the attached contacts.
    while (body.contacts.isNotEmpty) {
      contactManager.destroy(body.contacts.first);
    }
    body.contacts.clear();

    for (final f in body.fixtures) {
      destroyListener?.onDestroyFixture(f);
      f.destroyProxies(contactManager.broadPhase);
    }
    if(body.userData != null && body.userData is BodyUserData){
      var data = body.userData as BodyUserData;
      if(data.isQuadOptimizaion){
        assert(data.loadedColumnRow != null);
        allEls.putIfAbsent(data.loadedColumnRow!, () => []);
        allEls[data.loadedColumnRow]?.remove(body);
      }else{
        activeBody.remove(body);
      }
    }
    bodies.remove(body);
  }
}
