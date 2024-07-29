// TODO(any): Rewrite the setters instead of ignoring this lint.
// ignore_for_file: avoid_positional_boolean_parameters
// ignore_for_file: use_setters_to_change_properties

import 'dart:math';
import 'package:forge2d/forge2d.dart';
import 'package:forge2d/src/common/timer.dart';
import 'package:forge2d/src/settings.dart' as settings;
import 'package:game_flame/ForgeOverrides/DPhysicWorld.dart';
import 'package:game_flame/abstracts/utils.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';

/// The world class manages all physics entities, dynamic simulation, and
/// asynchronous queries. The world also contains efficient memory management
/// facilities.
class WorldPhy implements World
{
  Map<LoadedColumnRow, List<Body>> allEls = {};
  List<Body> activeBody = [];
  LoadedColumnRow _currentQuad = LoadedColumnRow(0, 0);
  static const int newFixture = 0x0001;
  static const int locked = 0x0002;
  static const int clearForcesBit = 0x0004;

  // TODO(spydon): Don't have these fields as static
  static final Distance distance = Distance();
  static final Collision collision = Collision();
  static final TimeOfImpact toi = TimeOfImpact();

  int flags = 0;

  late ContactManager contactManager;
  final List<Body> bodies = <Body>[];
  final List<Joint> joints = <Joint>[];

  final Vector2 _gravity;

  /// The current [World]'s [gravity].
  ///
  /// {@template World.gravity}
  /// All [bodies] are affected by [gravity]; unless the [Body] has a specified
  /// [Body.gravityOverride]. If so, [Body.gravityOverride] is used instead of
  /// [gravity].
  ///
  /// See also:
  ///
  /// * [Body.gravityScale], to multipy [gravity] for a [Body].
  /// * [Body.gravityOverride], to change how the world treats the gravity for
  /// a [Body].
  /// {@endtemplate}
  Vector2 get gravity => _gravity;

  /// Changes the [World]'s gravity.
  ///
  /// {@macro World.gravity}
  set gravity(Vector2 gravity) => this.gravity.setFrom(gravity);

  bool _allowSleep = false;

  DestroyListener? destroyListener;
  ParticleDestroyListener? particleDestroyListener;
  DebugDraw? debugDraw;

  /// This is used to compute the time step ratio to support a variable time
  /// step.
  double _invDt0 = 0.0;

  // these are for debugging the solver
  bool _warmStarting = false;
  bool _continuousPhysics = false;
  bool _subStepping = false;

  bool _stepComplete = false;

  late Profile _profile;

  late ParticleSystem particleSystem;

  WorldPhy([Vector2? gravity, BroadPhase? broadPhase])
      : _gravity = Vector2.copy(gravity ?? Vector2.zero()) {
    broadPhase ??= DefaultBroadPhaseBuffer(DynamicTree());

    _warmStarting = true;
    _continuousPhysics = true;
    _subStepping = false;
    _stepComplete = true;

    _allowSleep = true;

    flags = clearForcesBit;

    _invDt0 = 0.0;

    contactManager = ContactManager(broadPhase);
    _profile = Profile();

    particleSystem = ParticleSystem(this);
  }

  void changeActiveBodies(LoadedColumnRow columnRow)
  {
    _currentQuad = columnRow;
  }

  @override
  void clearForces() {
    for(final dd in activeBody){
      dd.clearForces();
    }
  }

  @override
  void setAllowSleep(bool flag) {
    if (flag == _allowSleep) {
      return;
    }

    _allowSleep = flag;
    if (!_allowSleep) {
      for (final b in activeBody) {
        b.setAwake(true);
      }
    }
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
    for(final key in activeBody){
      destroyBody(key);
    }    // bodies.clear();
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
  }

  void setSubStepping(bool subStepping) {
    _subStepping = subStepping;
  }

  bool isSubStepping() {
    return _subStepping;
  }

  bool isAllowSleep() {
    return _allowSleep;
  }

  /// Register a contact filter to provide specific control over collision.
  /// Otherwise the default filter is used (_defaultFilter).
  /// The listener is owned by you and must remain in scope.
  void setContactFilter(ContactFilter filter) {
    contactManager.contactFilter = filter;
  }

  /// Register a contact event listener. The listener is owned by you and must
  /// remain in scope.
  void setContactListener(ContactListener listener) {
    contactManager.contactListener = listener;
  }

  void createJoint(Joint joint) {
    assert(!isLocked);
    joints.add(joint);

    final bodyA = joint.bodyA;
    final bodyB = joint.bodyB;
    bodyA.joints.add(joint);
    bodyB.joints.add(joint);

    // If the joint prevents collisions, then flag any contacts for filtering.
    if (!joint.collideConnected) {
      for (final contact in bodyB.contacts) {
        if (contact.getOtherBody(bodyB) == bodyA) {
          // Flag the contact for filtering at the next time step (where either
          // body is awake).
          contact.flagForFiltering();
        }
      }
    }
  }

  /// Destroys a joint. This may cause the connected bodies to begin colliding.
  ///
  /// Warning: This function is locked during callbacks.
  void destroyJoint(Joint joint) {
    assert(!isLocked);

    final collideConnected = joint.collideConnected;
    joints.remove(joint);

    // Disconnect from island graph.
    final bodyA = joint.bodyA;
    final bodyB = joint.bodyB;

    // Wake up connected bodies.
    bodyA.setAwake(true);
    bodyB.setAwake(true);

    bodyA.joints.remove(joint);
    bodyB.joints.remove(joint);

    Joint.destroy(joint);

    // If the joint prevents collisions, then flag any contacts for filtering.
    if (!collideConnected) {
      for (final contact in bodyB.contacts) {
        if (contact.getOtherBody(bodyB) == bodyA) {
          // Flag the contact for filtering at the next time step (where either
          // body is awake).
          contact.flagForFiltering();
        }
      }
    }
  }

  final TimeStep _step = TimeStep();
  final Timer _stepTimer = Timer();
  final Timer _tempTimer = Timer();

  /// Take a time step. This performs collision detection, integration, and
  /// constraint solution.
  ///
  /// [dt] should be the amount of time (in seconds) that has passed since the
  /// last step.
  void stepDt(double dt) {
    _stepTimer.reset();
    _tempTimer.reset();
    // If new fixtures were added, we need to find the new contacts.
    if ((flags & newFixture) == newFixture) {
      contactManager.findNewContacts();
      flags &= ~newFixture;
    }

    flags |= locked;

    _step.dt = dt;
    _step.velocityIterations = settings.velocityIterations;
    _step.positionIterations = settings.positionIterations;
    if (dt > 0.0) {
      _step.invDt = 1.0 / dt;
    } else {
      _step.invDt = 0.0;
    }

    _step.dtRatio = _invDt0 * dt;

    _step.warmStarting = _warmStarting;
    _profile.stepInit.record(_tempTimer.getMilliseconds());

    // Update contacts. This is where some contacts are destroyed.
    _tempTimer.reset();
    contactManager.collide();
    _profile.collide.record(_tempTimer.getMilliseconds());

    // Integrate velocities, solve velocity constraints, and integrate
    // positions.
    if (_stepComplete && _step.dt > 0.0) {
      _tempTimer.reset();
      particleSystem.solve(_step); // Particle Simulation
      _profile.solveParticleSystem.record(_tempTimer.getMilliseconds());
      _tempTimer.reset();
      solve(_step);
      _profile.solve.record(_tempTimer.getMilliseconds());
    }

    // Handle TOI events.
    if (_continuousPhysics && _step.dt > 0.0) {
      _tempTimer.reset();
      solveTOI(_step);
      _profile.solveTOI.record(_tempTimer.getMilliseconds());
    }

    if (_step.dt > 0.0) {
      _invDt0 = _step.invDt;
    }

    if ((flags & clearForcesBit) == clearForcesBit) {
      clearForces();
    }

    flags &= ~locked;

    _profile.step.record(_stepTimer.getMilliseconds());
  }

  final Color3i color = Color3i.zero();
  final Transform xf = Transform.zero();
  final Vector2 cA = Vector2.zero();
  final Vector2 cB = Vector2.zero();

  /// Call this to draw shapes and other debug draw data.
  void drawDebugData() {}

  final WorldQueryWrapper _worldQueryWrapper = WorldQueryWrapper();

  /// Query the world for all fixtures that potentially overlap the provided
  /// AABB.
  void queryAABB(QueryCallback callback, AABB aabb) {
    _worldQueryWrapper.broadPhase = contactManager.broadPhase;
    _worldQueryWrapper.callback = callback;
    contactManager.broadPhase.query(_worldQueryWrapper, aabb);
  }

  /// Query the world for all fixtures and particles that potentially overlap
  /// the provided AABB.
  void queryAABBTwoCallbacks(
      QueryCallback callback,
      ParticleQueryCallback particleCallback,
      AABB aabb,
      ) {
    _worldQueryWrapper.broadPhase = contactManager.broadPhase;
    _worldQueryWrapper.callback = callback;
    contactManager.broadPhase.query(_worldQueryWrapper, aabb);
    particleSystem.queryAABB(particleCallback, aabb);
  }

  /// Query the world for all particles that potentially overlap the provided
  /// AABB.
  void queryAABBParticle(ParticleQueryCallback particleCallback, AABB aabb) {
    particleSystem.queryAABB(particleCallback, aabb);
  }

  final WorldRayCastWrapper _raycastWrapper = WorldRayCastWrapper();
  final RayCastInput _input = RayCastInput();

  /// Ray-cast the world for all fixtures in the path of the ray. Your callback
  /// controls whether you get the closest point, any point, or n-points.
  /// The ray-cast ignores shapes that contain the starting point.
  ///
  /// [point1] is the ray's starting point
  /// [point2] is the ray's ending point
  void raycast(RayCastCallback callback, Vector2 point1, Vector2 point2) {
    _raycastWrapper.broadPhase = contactManager.broadPhase;
    _raycastWrapper.callback = callback;
    _input.maxFraction = 1.0;
    _input.p1.setFrom(point1);
    _input.p2.setFrom(point2);
    contactManager.broadPhase.raycast(_raycastWrapper, _input);
  }



  bool myRayCust(Vector2 p1, Vector2 p2, bool? isOnlyStatic)
  {
    int minColumn = min(p1.x ~/ (GameConsts.lengthOfTileSquare.x * PhysicVals.physicScale),
        p2.x ~/ (GameConsts.lengthOfTileSquare.x  * PhysicVals.physicScale));
    int maxColumn = max(p1.x ~/ (GameConsts.lengthOfTileSquare.x * PhysicVals.physicScale),
        p2.x ~/ (GameConsts.lengthOfTileSquare.x  * PhysicVals.physicScale));

    int minRow = min(p1.y ~/ (GameConsts.lengthOfTileSquare.y  * PhysicVals.physicScale),
        p2.y ~/ (GameConsts.lengthOfTileSquare.y  * PhysicVals.physicScale));
    int maxRow = max(p1.y ~/ (GameConsts.lengthOfTileSquare.y  * PhysicVals.physicScale),
        p2.y ~/ (GameConsts.lengthOfTileSquare.y  * PhysicVals.physicScale));

    Vector2 minVector, maxVector;
    minVector = Vector2(min(p1.x, p2.x), min(p1.y, p2.y));
    maxVector = Vector2(max(p1.x, p2.x), max(p1.y, p2.y));

    for(int i = minColumn; i <= maxColumn; i++) {
      for (int j = minRow; j <= maxRow; j++) {
        LoadedColumnRow mapPos = LoadedColumnRow(i, j);
        if (allEls.containsKey(mapPos)) {
          for (final bod in allEls[mapPos]!) {
            for (final fixture in bod.fixtures) {
              if (minVector.x - 20 * PhysicVals.physicScale >
                  fixture.proxies[0].aabb.upperBound.x ||
                  maxVector.x + 20 * PhysicVals.physicScale <
                      fixture.proxies[0].aabb.lowerBound.x) {
                continue;
              }
              if (minVector.y - 20 * PhysicVals.physicScale >
                  fixture.proxies[0].aabb.upperBound.y ||
                  maxVector.y + 20 * PhysicVals.physicScale <
                      fixture.proxies[0].aabb.lowerBound.y) {
                continue;
              }
              List<Vector2> vertices;
              bool isLoop = false;
              switch(fixture.shape.shapeType) {
                case ShapeType.circle: vertices = [Vector2.zero()]; break;
                case ShapeType.edge: var temp = fixture.shape as EdgeShape ; vertices = [temp.vertex1, temp.vertex2]; break;
                case ShapeType.polygon: var temp = fixture.shape as PolygonShape ; vertices = temp.vertices; isLoop = true; break;
                case ShapeType.chain: var temp = fixture.shape as ChainShape ; vertices = temp.vertices; break;
              }
              for(int k = 0; k < vertices.length - 1; k++) {
                if(f_pointOfIntersect(p1,p2,vertices[k],vertices[k+1]) != Vector2.zero()){
                    return true;
                }
              }
              if(isLoop){
                if(f_pointOfIntersect(p1,p2,vertices[0],vertices[vertices.length - 1]) != Vector2.zero()){
                  return true;
                }
              }
            }
          }
        }
      }
    }
    return false;
  }

  /// Ray-cast the world for all fixtures and particles in the path of the ray.
  /// Your callback controls whether you get the closest point, any point, or
  /// n-points. The ray-cast ignores shapes that contain the starting point.
  ///
  /// [point1] is the ray's starting point
  /// [point2] is the ray's ending point
  void raycastTwoCallBacks(
      RayCastCallback callback,
      ParticleRaycastCallback particleCallback,
      Vector2 point1,
      Vector2 point2,
      ) {
    _raycastWrapper.broadPhase = contactManager.broadPhase;
    _raycastWrapper.callback = callback;
    _input.maxFraction = 1.0;
    _input.p1.setFrom(point1);
    _input.p2.setFrom(point2);
    contactManager.broadPhase.raycast(_raycastWrapper, _input);
    particleSystem.raycast(particleCallback, point1, point2);
  }

  /// Ray-cast the world for all particles in the path of the ray. Your callback
  /// controls whether you get the closest point, any point, or n-points.
  ///
  /// [point1] is the ray's starting point
  /// [point2] is the ray's ending point
  void raycastParticle(
      ParticleRaycastCallback particleCallback,
      Vector2 point1,
      Vector2 point2,
      ) {
    particleSystem.raycast(particleCallback, point1, point2);
  }

  /// Get the number of broad-phase proxies.
  int get proxyCount => contactManager.broadPhase.proxyCount;

  /// Gets the height of the dynamic tree
  int getTreeHeight() => contactManager.broadPhase.getTreeHeight();

  /// Gets the balance of the dynamic tree
  int getTreeBalance() => contactManager.broadPhase.getTreeBalance();

  /// Gets the quality of the dynamic tree
  double getTreeQuality() => contactManager.broadPhase.getTreeQuality();

  /// Is the world locked (in the middle of a time step).
  bool get isLocked => (flags & locked) == locked;

  /// Set flag to control automatic clearing of forces after each time step.
  void setAutoClearForces(bool shouldAutoClear) {
    if (shouldAutoClear) {
      flags |= clearForcesBit;
    } else {
      flags &= ~clearForcesBit;
    }
  }

  /// Get the flag that controls automatic clearing of forces after each time
  /// step.
  bool get autoClearForces => (flags & clearForcesBit) == clearForcesBit;

  final Island island = Island();
  final List<Body> stack = [];
  final Timer broadphaseTimer = Timer();

  void solve(TimeStep step)
  {
    _profile.solveInit.startAccum();
    _profile.solveVelocity.startAccum();
    _profile.solvePosition.startAccum();
    List<Body> bodiesCurr = [];
    int col = _currentQuad.column - 1;
    int row = _currentQuad.row - 1;
    for (final c in contactManager.contacts) {
      c.flags &= ~Contact.islandFlag;
    }
    for (final j in joints) {
      j.islandFlag = false;
    }
    island.listener = contactManager.contactListener;
    for (col; col < _currentQuad.column + 2; col++) {
      for (row; row < _currentQuad.row + 2; row++) {
        bodiesCurr = allEls[LoadedColumnRow(col, row)] ?? [];
        if(bodiesCurr.isEmpty) continue;
        // update previous transforms
        for (final b in bodiesCurr) {
          b.previousTransform.setFrom(b.transform);
        }
        for (final b in bodiesCurr) {
          b.flags &= ~Body.islandFlag;
        }
        for (final seed in bodiesCurr) {
          if ((seed.flags & Body.islandFlag) == Body.islandFlag) {
            continue;
          }
          if (seed.isAwake == false || seed.isActive == false) {
            continue;
          }



          // The seed can be dynamic or kinematic.
          if (seed.bodyType == BodyType.static) {
            continue;
          }

          island.clear();
          stack.clear();
          stack.add(seed);
          seed.flags |= Body.islandFlag;

          // Perform a depth first search (DFS) on the constraint graph.
          while (stack.isNotEmpty) {
            // Grab the next body off the stack and add it to the island.
            final body = stack.removeLast();
            assert(body.isActive);
            island.addBody(body);

            // Make sure the body is awake.
            body.setAwake(true);

            // To keep islands as small as possible, we don't
            // propagate islands across static bodiesCurr.
            if (body.bodyType == BodyType.static) {
              continue;
            }

            // Search all contacts connected to this body.
            for (final contact in body.contacts) {
              // Has this contact already been added to an island?
              if ((contact.flags & Contact.islandFlag) == Contact.islandFlag) {
                continue;
              }

              // Is this contact solid and touching?
              if (contact.isEnabled == false || contact.isTouching() == false) {
                continue;
              }

              // Skip sensors.
              final sensorA = contact.fixtureA.isSensor;
              final sensorB = contact.fixtureB.isSensor;
              if (sensorA || sensorB) {
                continue;
              }

              island.addContact(contact);
              contact.flags |= Contact.islandFlag;

              final other = contact.getOtherBody(body);

              // Was the other body already added to this island?
              if ((other.flags & Body.islandFlag) == Body.islandFlag) {
                continue;
              }

              stack.add(other);
              other.flags |= Body.islandFlag;
            }

            // Search all joints connect to this body.
            for (final joint in body.joints) {
              if (joint.islandFlag) {
                continue;
              }

              final other = joint.otherBody(body);

              // Don't simulate joints connected to inactive bodiesCurr.
              if (!other.isActive) {
                continue;
              }

              island.addJoint(joint);
              joint.islandFlag = true;

              if ((other.flags & Body.islandFlag) == Body.islandFlag) {
                continue;
              }

              stack.add(other);
              other.flags |= Body.islandFlag;
            }
          }
          island.solve(_profile, step, _gravity, allowSleep: _allowSleep);

          // Post solve cleanup.
          for (final bodyMeta in island.bodies) {
            // Allow static bodies to participate in other islands.
            final b = bodyMeta.body;
            if (b.bodyType == BodyType.static) {
              b.flags &= ~Body.islandFlag;
            }
          }
        }
      }
    }

    activeBodySolver(step);

    _profile.solveInit.endAccum();
    _profile.solveVelocity.endAccum();
    _profile.solvePosition.endAccum();

    broadphaseTimer.reset();

    for (final b in activeBody) {
      if ((b.flags & Body.islandFlag) == 0) {
        continue;
      }
      if (b.bodyType == BodyType.static) {
        continue;
      }
      b.synchronizeFixtures();
    }

    col = _currentQuad.column - 1;
    row = _currentQuad.row - 1;
    for(;col<_currentQuad.column + 2;col++){
      for(;row<_currentQuad.row + 2;row++){
        for (final b in allEls[LoadedColumnRow(col,row)] ?? []) {
          if ((b.flags & Body.islandFlag) == 0) {
            continue;
          }
          if (b.bodyType == BodyType.static) {
            continue;
          }
          b.synchronizeFixtures();
        }
      }
    }

    contactManager.findNewContacts();
    _profile.broadphase.record(broadphaseTimer.getMilliseconds());
  }

  void activeBodySolver(TimeStep step)
  {
    if(activeBody.isEmpty) return;
    for (final b in activeBody) {
      b.previousTransform.setFrom(b.transform);
    }
    for (final b in activeBody) {
      b.flags &= ~Body.islandFlag;
    }
    for (final seed in activeBody) {
      if ((seed.flags & Body.islandFlag) == Body.islandFlag) {
        continue;
      }
      if (seed.isAwake == false || seed.isActive == false) {
        continue;
      }
      if (seed.bodyType == BodyType.static) {
        continue;
      }
      island.clear();
      stack.clear();
      stack.add(seed);
      seed.flags |= Body.islandFlag;

      while (stack.isNotEmpty) {
        final body = stack.removeLast();
        assert(body.isActive);
        island.addBody(body);

        // Make sure the body is awake.
        body.setAwake(true);
        if (body.bodyType == BodyType.static) {
          continue;
        }
        for (final contact in body.contacts) {
          // Has this contact already been added to an island?
          if ((contact.flags & Contact.islandFlag) == Contact.islandFlag) {
            continue;
          }

          // Is this contact solid and touching?
          if (contact.isEnabled == false || contact.isTouching() == false) {
            continue;
          }

          // Skip sensors.
          final sensorA = contact.fixtureA.isSensor;
          final sensorB = contact.fixtureB.isSensor;
          if (sensorA || sensorB) {
            continue;
          }

          island.addContact(contact);
          contact.flags |= Contact.islandFlag;

          final other = contact.getOtherBody(body);

          // Was the other body already added to this island?
          if ((other.flags & Body.islandFlag) == Body.islandFlag) {
            continue;
          }

          stack.add(other);
          other.flags |= Body.islandFlag;
        }

        // Search all joints connect to this body.
        for (final joint in body.joints) {
          if (joint.islandFlag) {
            continue;
          }

          final other = joint.otherBody(body);

          // Don't simulate joints connected to inactive bodiesCurr.
          if (!other.isActive) {
            continue;
          }

          island.addJoint(joint);
          joint.islandFlag = true;

          if ((other.flags & Body.islandFlag) == Body.islandFlag) {
            continue;
          }

          stack.add(other);
          other.flags |= Body.islandFlag;
        }
      }
      island.solve(_profile, step, _gravity, allowSleep: _allowSleep);

      // Post solve cleanup.
      for (final bodyMeta in island.bodies) {
        // Allow static bodies to participate in other islands.
        final b = bodyMeta.body;
        if (b.bodyType == BodyType.static) {
          b.flags &= ~Body.islandFlag;
        }
      }
    }
  }

  final Island _toiIsland = Island();
  final TOIInput _toiInput = TOIInput();
  final TOIOutput _toiOutput = TOIOutput();
  final TimeStep _subStep = TimeStep();
  final Sweep _backup1 = Sweep();
  final Sweep _backup2 = Sweep();

  void solveTOI(TimeStep step) {
    final island = _toiIsland..listener = contactManager.contactListener;
    if (_stepComplete) {
      int col = _currentQuad.column - 1;
      int row = _currentQuad.row - 1;

      for(;col<_currentQuad.column + 2;col++){
        for(;row<_currentQuad.row + 2;row++){
          final bod = allEls[LoadedColumnRow(col, row)] ?? [];
          for (final b in bod) {
            b.flags &= ~Body.islandFlag;
            b.sweep.alpha0 = 0.0;
          }
        }
      }

      for (final b in activeBody) {
        b.flags &= ~Body.islandFlag;
        b.sweep.alpha0 = 0.0;
      }

      for (final c in contactManager.contacts) {
        // Invalidate TOI
        c.flags &= ~(Contact.toiFlag | Contact.islandFlag);
        c.toiCount = 0;
        c.toi = 1.0;
      }
    }

    // Find TOI events and solve them.
    for (;;) {
      // Find the first TOI.
      Contact? minContact;
      var minAlpha = 1.0;

      for (final contact in contactManager.contacts) {
        // Is this contact disabled?
        if (contact.isEnabled == false) {
          continue;
        }

        // Prevent excessive sub-stepping.
        if (contact.toiCount > settings.maxSubSteps) {
          continue;
        }

        var alpha = 1.0;
        if ((contact.flags & Contact.toiFlag) != 0) {
          // This contact has a valid cached TOI.
          alpha = contact.toi;
        } else {
          final fixtureA = contact.fixtureA;
          final fixtureB = contact.fixtureB;

          // Is there a sensor?
          if (fixtureA.isSensor || fixtureB.isSensor) {
            continue;
          }

          final bodyA = fixtureA.body;
          final bodyB = fixtureB.body;

          final typeA = bodyA.bodyType;
          final typeB = bodyB.bodyType;
          assert(typeA == BodyType.dynamic || typeB == BodyType.dynamic);

          final activeA = bodyA.isAwake && typeA != BodyType.static;
          final activeB = bodyB.isAwake && typeB != BodyType.static;

          // Is at least one body active (awake and dynamic or kinematic)?
          if (activeA == false && activeB == false) {
            continue;
          }

          final collideA = bodyA.isBullet || typeA != BodyType.dynamic;
          final collideB = bodyB.isBullet || typeB != BodyType.dynamic;

          // Are these two non-bullet dynamic bodies?
          if (collideA == false && collideB == false) {
            continue;
          }

          // Compute the TOI for this contact.
          // Put the sweeps onto the same time interval.
          var alpha0 = bodyA.sweep.alpha0;

          if (bodyA.sweep.alpha0 < bodyB.sweep.alpha0) {
            alpha0 = bodyB.sweep.alpha0;
            bodyA.sweep.advance(alpha0);
            // NOTE: The following line is ignored due to a false positive
            // analyzer warning.
            // https://github.com/dart-lang/linter/issues/811
            // ignore: invariant_booleans
          } else if (bodyB.sweep.alpha0 < bodyA.sweep.alpha0) {
            alpha0 = bodyA.sweep.alpha0;
            bodyB.sweep.advance(alpha0);
          }

          assert(alpha0 < 1.0);

          final indexA = contact.indexA;
          final indexB = contact.indexB;

          // Compute the time of impact in interval [0, minTOI]
          final input = _toiInput;
          input.proxyA.set(fixtureA.shape, indexA);
          input.proxyB.set(fixtureB.shape, indexB);
          input.sweepA.setFrom(bodyA.sweep);
          input.sweepB.setFrom(bodyB.sweep);
          input.tMax = 1.0;

          toi.timeOfImpact(_toiOutput, input);

          // Beta is the fraction of the remaining portion of the .
          final beta = _toiOutput.t;
          if (_toiOutput.state == TOIOutputState.touching) {
            alpha = min(alpha0 + (1.0 - alpha0) * beta, 1.0);
          } else {
            alpha = 1.0;
          }

          contact.toi = alpha;
          contact.flags |= Contact.toiFlag;
        }

        if (alpha < minAlpha) {
          // This is the minimum TOI found so far.
          minContact = contact;
          minAlpha = alpha;
        }
      }

      if (minContact == null || 1.0 - 10.0 * settings.epsilon < minAlpha) {
        // No more TOI events. Done!
        _stepComplete = true;
        break;
      }

      final bodyA = minContact.fixtureA.body;
      final bodyB = minContact.fixtureB.body;

      _backup1.setFrom(bodyA.sweep);
      _backup2.setFrom(bodyB.sweep);

      // Advance the bodies to the TOI.
      bodyA.advance(minAlpha);
      bodyB.advance(minAlpha);

      // The TOI contact likely has some new contact points.
      minContact.update(contactManager.contactListener);
      minContact.flags &= ~Contact.toiFlag;
      ++minContact.toiCount;

      // Is the contact solid?
      if (minContact.isEnabled == false || minContact.isTouching() == false) {
        // Restore the sweeps.
        minContact.isEnabled = false;
        bodyA.sweep.setFrom(_backup1);
        bodyB.sweep.setFrom(_backup2);
        bodyA.synchronizeTransform();
        bodyB.synchronizeTransform();
        continue;
      }

      bodyA.setAwake(true);
      bodyB.setAwake(true);

      // Build the island
      island.clear();
      island.addBody(bodyA);
      island.addBody(bodyB);
      island.addContact(minContact);

      bodyA.flags |= Body.islandFlag;
      bodyB.flags |= Body.islandFlag;
      minContact.flags |= Contact.islandFlag;

      // Get contacts on bodyA and bodyB.
      for (final body in [bodyA, bodyB]) {
        if (body.bodyType == BodyType.dynamic) {
          for (final contact in body.contacts) {
            // Has this contact already been added to the island?
            if ((contact.flags & Contact.islandFlag) != 0) {
              continue;
            }

            // Only add static, kinematic, or bullet bodies.
            final other = contact.getOtherBody(body);
            if (other.bodyType == BodyType.dynamic &&
                !body.isBullet &&
                !other.isBullet) {
              continue;
            }

            // Skip sensors.
            final sensorA = contact.fixtureA.isSensor;
            final sensorB = contact.fixtureB.isSensor;
            if (sensorA || sensorB) {
              continue;
            }

            // Tentatively advance the body to the TOI.
            _backup1.setFrom(other.sweep);
            if ((other.flags & Body.islandFlag) == 0) {
              other.advance(minAlpha);
            }

            // Update the contact points
            contact.update(contactManager.contactListener);

            // Was the contact disabled by the user?
            if (contact.isEnabled == false) {
              other.sweep.setFrom(_backup1);
              other.synchronizeTransform();
              continue;
            }

            // Are there contact points?
            if (contact.isTouching() == false) {
              other.sweep.setFrom(_backup1);
              other.synchronizeTransform();
              continue;
            }

            // Add the contact to the island
            contact.flags |= Contact.islandFlag;
            island.addContact(contact);

            // Has the other body already been added to the island?
            if ((other.flags & Body.islandFlag) != 0) {
              continue;
            }

            // Add the other body to the island.
            other.flags |= Body.islandFlag;

            if (other.bodyType != BodyType.static) {
              other.setAwake(true);
            }

            island.addBody(other);
          }
        }
      }

      _subStep.dt = (1.0 - minAlpha) * step.dt;
      _subStep.invDt = 1.0 / _subStep.dt;
      _subStep.dtRatio = 1.0;
      _subStep.positionIterations = 20;
      _subStep.velocityIterations = step.velocityIterations;
      _subStep.warmStarting = false;
      island.solveTOI(_subStep, bodyA.islandIndex, bodyB.islandIndex);

      // Reset island flags and synchronize broad-phase proxies.
      for (final bodyMeta in island.bodies) {
        final body = bodyMeta.body;
        body.flags &= ~Body.islandFlag;

        if (body.bodyType != BodyType.dynamic) {
          continue;
        }

        body.synchronizeFixtures();

        // Invalidate all contact TOIs on this displaced body.
        for (final contact in body.contacts) {
          contact.flags &= ~(Contact.toiFlag | Contact.islandFlag);
        }
      }

      // Commit fixture proxy movements to the broad-phase so that new contacts
      // are created. Also, some contacts can be destroyed.
      contactManager.findNewContacts();

      if (_subStepping) {
        _stepComplete = false;
        break;
      }
    }
  }
}