import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:game_flame/components/physic_vals.dart';

class TreeHandler
{
  TreeHandler(this.aabb, {this.userData, this.parentNode = -1, this.isMoving = false});
  AABB aabb;
  FixtureProxy? userData;
  int parentNode;
  bool isMoving;
  Map<int,TreeHandler> children = {};
}


class MyBroadPhase implements BroadPhase,TreeCallback
{

  int count = 0;
  int moveCount = 0;
  GameWorldData? worldData;
  Map<int,List<TreeHandler>> _nests = {};
  Map<int,TreeHandler> _proxyHash = {};
  Map<int,TreeHandler> _movingProxyHash = {};
  int getCount() => count++;


  void initBroadPhase(GameWorldData worldData)
  {
    this.worldData = worldData;
    _proxyHash.clear();
    _movingProxyHash.clear();
    _nests.clear();
    count = 0;
    for(int i = 0; i < worldData.gameConsts.maxColumn; i++){
      for(int j = 0; j < worldData.gameConsts.maxRow; j++){
        AABB tempAABB = AABB();
        tempAABB.lowerBound.x = i * GameConsts.lengthOfTileSquare.x * PhysicVals.physicScale;
        tempAABB.lowerBound.y = j * GameConsts.lengthOfTileSquare.y * PhysicVals.physicScale;
        tempAABB.upperBound.x = tempAABB.lowerBound.x + GameConsts.lengthOfTileSquare.x * PhysicVals.physicScale;
        tempAABB.upperBound.y = tempAABB.lowerBound.y + GameConsts.lengthOfTileSquare.y * PhysicVals.physicScale;
        int currCount = getCount();
        _proxyHash[currCount] = TreeHandler(tempAABB);
        _nests[currCount] = [];
      }
    }
  }

  @override
  int createProxy(AABB aabb, Object userData)
  {
    FixtureProxy? fixtureProxy = userData as FixtureProxy;
    bool isStatic = fixtureProxy.fixture.body.bodyType == BodyType.static;
    int col = aabb.lowerBound.x ~/ (GameConsts.lengthOfTileSquare.x * PhysicVals.physicScale);
    int row = aabb.lowerBound.y ~/ (GameConsts.lengthOfTileSquare.y * PhysicVals.physicScale);
    int mapPos = col + row * worldData!.gameConsts.maxColumn;
    TreeHandler newNode = TreeHandler(aabb, userData: userData,parentNode: mapPos);
    int currentCount = getCount();
    _proxyHash[currentCount] = newNode;
    if(isStatic){
      _nests[mapPos]!.add(newNode);
    }else {
      _proxyHash[currentCount]!.isMoving = true;
      _movingProxyHash[currentCount] = newNode;
    }
    return currentCount;
  }

  @override
  void destroyProxy(int proxyId)
  {
    if(proxyId >= worldData!.gameConsts.maxColumn * worldData!.gameConsts.maxRow){
      if(_proxyHash[proxyId] == null){
        return;
      }
      _nests[_proxyHash[proxyId]!.parentNode]?.remove(_proxyHash[proxyId]!);
      _proxyHash.remove(proxyId);
      _movingProxyHash.remove(proxyId);
    }
  }

  @override
  void drawTree(DebugDraw argDraw)
  {
    print('drawTree');
  }

  @override
  AABB fatAABB(int proxyId)
  {
    return _proxyHash[proxyId]!.aabb;
  }

  @override
  int getTreeBalance()
  {
    print('getTreeBalance');
    return 0;
  }

  @override
  int getTreeHeight()
  {
    print('getTreeHeight');
    return 0;
  }

  @override
  double getTreeQuality()
  {
    print('getTreeQuality');
    return 0;
  }

  @override
  Object? getUserData(int proxyId)
  {
    return _proxyHash[proxyId]?.userData;
  }

  @override
  void moveProxy(int proxyId, AABB aabb, Vector2 displacement)
  {
    if(proxyId < worldData!.gameConsts.maxColumn! * worldData!.gameConsts.maxRow!){
      throw 'Move with no move!!!';
    }
    if(displacement != Vector2.zero() && _movingProxyHash.containsKey(proxyId)) {
      _movingProxyHash[proxyId]?.aabb.lowerBound.x += displacement.x;
      _movingProxyHash[proxyId]?.aabb.lowerBound.y += displacement.y;
      _movingProxyHash[proxyId]?.aabb.upperBound.x += displacement.x;
      _movingProxyHash[proxyId]?.aabb.upperBound.y += displacement.y;
      _proxyHash[proxyId] = _movingProxyHash[proxyId]!;
    }
  }

  @override
  int get proxyCount => 0;

  @override
  void query(TreeCallback callback, AABB aabb)
  {
    print('query');
  }

  @override
  void raycast(TreeRayCastCallback callback, RayCastInput input)
  {
    print('raycast');
  }

  @override
  bool testOverlap(int proxyIdA, int proxyIdB)
  {
    if(_proxyHash[proxyIdA]!.isMoving && _proxyHash[proxyIdB]!.isMoving){
      return true;
    }
    if(!_proxyHash[proxyIdA]!.isMoving && !_proxyHash[proxyIdB]!.isMoving){
      return false;
    }
    var moveEntity = _proxyHash[proxyIdA]!.isMoving ? _proxyHash[proxyIdA] : _proxyHash[proxyIdB];
    var staticEntity = _proxyHash[proxyIdA]!.isMoving ? _proxyHash[proxyIdB] : _proxyHash[proxyIdA];

    int minColumn,maxColumn,minRow,maxRow;
    minColumn = (moveEntity!.aabb.lowerBound.x - 20 * PhysicVals.physicScale) ~/ (GameConsts.lengthOfTileSquare.x  * PhysicVals.physicScale);
    maxColumn = (moveEntity.aabb.upperBound.x + 20 * PhysicVals.physicScale) ~/ (GameConsts.lengthOfTileSquare.x * PhysicVals.physicScale);
    minRow = (moveEntity.aabb.lowerBound.y - 20 * PhysicVals.physicScale) ~/ (GameConsts.lengthOfTileSquare.y * PhysicVals.physicScale);
    maxRow = (moveEntity.aabb.upperBound.y + 20 * PhysicVals.physicScale) ~/ (GameConsts.lengthOfTileSquare.y * PhysicVals.physicScale);

    int staticColumn = staticEntity!.aabb.center.x ~/ (GameConsts.lengthOfTileSquare.x * PhysicVals.physicScale);
    int staticRow = staticEntity.aabb.center.y ~/ (GameConsts.lengthOfTileSquare.y * PhysicVals.physicScale);
    if((staticColumn == minColumn || staticColumn == maxColumn) && (staticRow == minRow || staticRow == maxRow)){
      return true;
    }
    return false;
  }

  @override
  void touchProxy(int proxyId)
  {
    print('touchProxy: $proxyId');
  }

  @override
  void updatePairs(PairCallback callback)
  {
    var moveProxies = _movingProxyHash.values.toList(growable: false);
    for(final body in moveProxies){
      if(body.userData == null){
        continue;
      }
      int minColumn = (body.aabb.lowerBound.x) ~/ (GameConsts.lengthOfTileSquare.x * PhysicVals.physicScale) - 1;
      int maxColumn = (body.aabb.upperBound.x) ~/ (GameConsts.lengthOfTileSquare.x * PhysicVals.physicScale) + 1;
      int minRow = (body.aabb.lowerBound.y) ~/ (GameConsts.lengthOfTileSquare.y * PhysicVals.physicScale) - 1;
      int maxRow = (body.aabb.upperBound.y) ~/ (GameConsts.lengthOfTileSquare.y * PhysicVals.physicScale) + 1;
      for(int i = minColumn; i <= maxColumn; i++){
        for(int j = minRow; j <= maxRow; j++){
          int mapPos = i + j * worldData!.gameConsts.maxColumn!;
          if(!_nests.containsKey(mapPos)){
            continue;
          }
          for(final static in _nests[mapPos]!){
            if(static.userData == null){
              continue;
            }
            if(body.aabb.lowerBound.x - 20 * PhysicVals.physicScale > static.aabb.upperBound.x || body.aabb.upperBound.x + 20 * PhysicVals.physicScale < static.aabb.lowerBound.x){
              continue;
            }
            if(body.aabb.lowerBound.y - 20 * PhysicVals.physicScale > static.aabb.upperBound.y || body.aabb.upperBound.y + 20 * PhysicVals.physicScale < static.aabb.lowerBound.y){
              continue;
            }
            callback.addPair(body.userData, static.userData);
          }
        }
      }
    }
    Set<int> removeFilter = {};
    for(int i=0; i<moveProxies.length; i++){
      for(int j=0; j<moveProxies.length; j++){
        if(i == j || removeFilter.contains(j)){
          continue;
        }
        removeFilter.add(i);
        if(moveProxies[i].userData == null || moveProxies[j].userData == null){
          continue;
        }
        if(moveProxies[i].aabb.lowerBound.x - 20 * PhysicVals.physicScale > moveProxies[j].aabb.upperBound.x || moveProxies[i].aabb.upperBound.x + 20 * PhysicVals.physicScale < moveProxies[j].aabb.lowerBound.x){
          continue;
        }
        if(moveProxies[i].aabb.lowerBound.y - 20 * PhysicVals.physicScale > moveProxies[j].aabb.upperBound.y || moveProxies[i].aabb.upperBound.y + 20 * PhysicVals.physicScale < moveProxies[j].aabb.lowerBound.y){
          continue;
        }
        callback.addPair(moveProxies[i].userData, moveProxies[j].userData);
      }
    }
  }

  @override
  bool treeCallback(int proxyId)
  {
    print('treeCallback');
    return true;
  }
}