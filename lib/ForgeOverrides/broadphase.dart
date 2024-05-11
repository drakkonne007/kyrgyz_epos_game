import 'package:flame_forge2d/flame_forge2d.dart';

class TreeHandler
{
  TreeHandler(this.aabb, this.userData);
  AABB aabb;
  Object userData;
}


class MyBroadPhase implements BroadPhase,TreeCallback
{

  List<Body> bodies = [];
  int count = 0;

  Map<int,TreeHandler> _tree = {};

  MyBroadPhase()
  {
    print('Creatre my broadPhase');
  }


  @override
  int createProxy(AABB aabb, Object userData) {
    int currentCount = count;
    _tree[currentCount] = TreeHandler(aabb, userData);
    count++;
    return currentCount;
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
    return _tree[proxyId]?.aabb ?? AABB();
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
    return _tree[proxyId]?.userData;
  }

  @override
  void moveProxy(int proxyId, AABB aabb, Vector2 displacement) {
    _tree[proxyId]!.aabb.lowerBound.x += displacement.x;
    _tree[proxyId]!.aabb.lowerBound.y += displacement.y;
    _tree[proxyId]!.aabb.upperBound.x += displacement.x;
    _tree[proxyId]!.aabb.upperBound.y += displacement.y;
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
    return true;
    if(!_tree.containsKey(proxyIdA) || !_tree.containsKey(proxyIdB)){
      return false;
    }
    final a = _tree[proxyIdA]!.aabb;
    final b = _tree[proxyIdB]!.aabb;
    if(a.lowerBound.x > b.upperBound.x || b.lowerBound.x > a.upperBound.x){
      return false;
    }
    if(a.lowerBound.y > b.upperBound.y || b.lowerBound.y > a.upperBound.y){
      return false;
    }
    return false;
  }

  @override
  void touchProxy(int proxyId) {
    print('touchProxy');
  }

  @override
  void updatePairs(PairCallback callback)
  {
    Set<int> removeList = {};
    for(int i = 0; i < bodies.length; i++) {
      for (int j = 0; j < bodies.length; j++) {
        if(i == j || removeList.contains(j)){
          continue;
        }
        removeList.add(i);
        Body body = bodies[i];
        Body body2 = bodies[j];
        if(body.bodyType == BodyType.static && body2.bodyType == BodyType.static){
          continue;
        }
        FixtureProxy fp = FixtureProxy(body.fixtures.first);
        fp.aabb.set(body.fixtures.first.getAABB(0));
        FixtureProxy fp2 = FixtureProxy(body2.fixtures.first);
        fp2.aabb.set(body2.fixtures.first.getAABB(0));
        // if(fp.aabb.lowerBound.x > fp2.aabb.upperBound.x || fp2.aabb.lowerBound.x > fp.aabb.upperBound.x) {
        //   // print(fp.aabb.lowerBound.x);
        //   // print(fp2.aabb.upperBound.x);
        //   // print(fp.aabb.upperBound.x);
        //   // print(fp2.aabb.lowerBound.x);
        //   continue;
        // }
        // if(fp.aabb.lowerBound.y > fp2.aabb.upperBound.y || fp2.aabb.lowerBound.y > fp.aabb.upperBound.y) {
        //   // print(fp.aabb.lowerBound.x);
        //   // print(fp2.aabb.upperBound.x);
        //   // print(fp.aabb.upperBound.x);
        //   // print(fp2.aabb.lowerBound.x);
        //   continue;
        // }
        callback.addPair(fp, fp2);
      }
    }
      // for(final body2 in bodies){
      //   if(body == body2){
      //     continue;
      //   }
      //   if(body.bodyType == BodyType.static && body2.bodyType == BodyType.static){
      //     continue;
      //   }else{
      //     FixtureProxy fp = FixtureProxy(body.fixtures.first);
      //     fp.aabb.set(body.fixtures.first.getAABB(0));
      //     FixtureProxy fp2 = FixtureProxy(body2.fixtures.first);
      //     fp2.aabb.set(body2.fixtures.first.getAABB(0));
      //     callback.addPair(fp, fp2);
      //   }
      // }
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

