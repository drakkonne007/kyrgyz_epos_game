import 'package:flame_forge2d/flame_forge2d.dart';

class MyBroadPhase implements BroadPhase,TreeCallback
{

  List<Body> bodies = [];

  MyBroadPhase()
  {
    print('Creatre my broadPhase');
  }


  @override
  int createProxy(AABB aabb, Object userData) {
    // TODO: implement createProxy
    print('createProxy');
    return 0;
  }

  @override
  void destroyProxy(int proxyId) {
    print('destroyProxy');
  }

  @override
  void drawTree(DebugDraw argDraw) {
    print('drawTree');
  }

  @override
  AABB fatAABB(int proxyId) {
    print('fatAABB');
    return AABB();
  }

  @override
  int getTreeBalance() {
    print('getTreeBalance');
    return 0;
  }

  @override
  int getTreeHeight() {
    print('getTreeHeight');
    return 0;
  }

  @override
  double getTreeQuality() {
    print('getTreeQuality');
    return 0;
  }

  @override
  Object? getUserData(int proxyId) {
    print('getUserData my broadPhase');
    return null;
  }

  @override
  void moveProxy(int proxyId, AABB aabb, Vector2 displacement) {
    print('moveProxy');
  }

  @override
  // TODO: implement proxyCount
  int get proxyCount => 0;

  @override
  void query(TreeCallback callback, AABB aabb) {
    print('query');
  }

  @override
  void raycast(TreeRayCastCallback callback, RayCastInput input) {
    print('raycast');
  }

  @override
  bool testOverlap(int proxyIdA, int proxyIdB) {
    print('testOverlap my broadPhase');
    return true;
  }

  @override
  void touchProxy(int proxyId) {
    print('touchProxy');
  }

  @override
  void updatePairs(PairCallback callback)
  {
    for(final body in bodies){
      for(final body2 in bodies){
        if(body == body2){
          continue;
        }
        if(body.bodyType == BodyType.static && body2.bodyType == BodyType.static){
          continue;
        }else{
          // FixtureProxy fp = FixtureProxy(body.fixtures.first);
          // fp.aabb.set(body.fixtures.first.getAABB(0));
          // FixtureProxy fp2 = FixtureProxy(body2.fixtures.first);
          // fp2.aabb.set(body2.fixtures.first.getAABB(0));
          callback.addPair(body.fixtures.first.userData, body2.fixtures.first.userData);
        }
      }
    }
    // _pairBuffer.clear();
    // // Perform tree queries for all moving proxies.
    // for (final proxyId in _moveBuffer) {
    //   _queryProxyId = proxyId;
    //   if (proxyId == BroadPhase.nullProxy) {
    //     continue;
    //   }
    //
    //   // We have to query the tree with the fat AABB so that
    //   // we don't fail to create a pair that may touch later.
    //   final fatAABB = _tree.fatAABB(proxyId);
    //
    //   // Query tree, create pairs and add them pair buffer.
    //   _tree.query(this, fatAABB);
    // }
    //
    // // Reset move buffer
    // _moveBuffer.clear();
    //
    // // Send the pairs back to the client.
    // for (final pair in _pairBuffer) {
    //   final userDataA = _tree.userData(pair.proxyIdA);
    //   final userDataB = _tree.userData(pair.proxyIdB);
    //   callback.addPair(userDataA, userDataB);
  }

  @override
  bool treeCallback(int proxyId) {
    print('treeCallback');
    return false;
  }
}

