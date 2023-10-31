import 'package:flame/components.dart';
import 'package:game_flame/abstracts/hitboxes.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/components/tile_map_component.dart';

class DCollisionProcessor
{
  final List<DCollisionEntity> _activeCollEntity = [];
  final Map<LoadedColumnRow,List<DCollisionEntity>> _staticCollEntity = {};

  void addCollEntity(DCollisionEntity entity)
  {
    _activeCollEntity.add(entity);
  }

  void removeCollEntity(DCollisionEntity entity)
  {
    _activeCollEntity.remove(entity);
  }

  void addStaticCollEntity(LoadedColumnRow colRow, DCollisionEntity entity)
  {
    _staticCollEntity.putIfAbsent(colRow, () => []);
    _staticCollEntity[colRow]!.add(entity);
  }

  void removeStaticCollEntity(LoadedColumnRow colRow)
  {
    _staticCollEntity.remove(colRow);
  }

  void updateCollisions()
  {
    PositionComponent component;
    Map<LoadedColumnRow, List<DCollisionEntity>> potentialActiveEntity = {};
    for(DCollisionEntity entity in _activeCollEntity)
    {
      if(entity.collisionType == DCollisionType.inactive) {
        continue;
      }
      component = entity.parent as PositionComponent;
      Set<LoadedColumnRow> contactNests = {};
      var first =  LoadedColumnRow(component.x ~/ GameConsts.lengthOfTileSquare.x, component.y ~/ GameConsts.lengthOfTileSquare.y);
      var sec =  LoadedColumnRow((component.x + component.size.x) ~/ GameConsts.lengthOfTileSquare.x, component.y ~/ GameConsts.lengthOfTileSquare.y);
      var third =  LoadedColumnRow((component.x + component.size.x) ~/ GameConsts.lengthOfTileSquare.x, (component.y + component.size.y) ~/ GameConsts.lengthOfTileSquare.y);
      var fourth =  LoadedColumnRow(component.x ~/ GameConsts.lengthOfTileSquare.x, (component.y + component.size.y) ~/ GameConsts.lengthOfTileSquare.y);
      contactNests.add(first);
      contactNests.add(sec);
      contactNests.add(third);
      contactNests.add(fourth);
      for(final lcr in contactNests){
        potentialActiveEntity.putIfAbsent(lcr, () => []);
        potentialActiveEntity[lcr]!.add(entity);
      }
      for(final lcr in contactNests){
        if(_staticCollEntity.containsKey(lcr)) {
          for(final other in _staticCollEntity[lcr]!){
            if(!entity.onComponentTypeCheck(other) && !other.onComponentTypeCheck(entity)) {
              continue;
            }
            if(other.collisionType == DCollisionType.inactive){
              continue;
            }
            Set<Vector2> intersectionPoints = {};
            for(int i=-1;i<entity.getVerticesCount() - 1;i++) {
              if(!entity.isLoop && i == -1){
                continue;
              }
              Vector2 first,second;
              if(i == -1){
                first = entity.getPoint(entity.getVerticesCount() - 1) + component.position;
                second = entity.getPoint(0) + component.position;
              }else{
                first = entity.getPoint(i) + component.position;
                second = entity.getPoint(i+1) + component.position;
              }
              for(int j=0;j<other.getVerticesCount() - 1;j++) {
                Vector2 point = pointOfIntersect(first, second, other.getPoint(j), other.getPoint(j+1));
                if(point != Vector2.zero()) {
                  intersectionPoints.add(point);
                }
              }
              if(other.isLoop){
                Vector2 point = pointOfIntersect(first, second, other.getPoint(other.getVerticesCount()-1), other.getPoint(0));
                if(point != Vector2.zero()) {
                  intersectionPoints.add(point);
                }
              }
            }
            if(intersectionPoints.isNotEmpty) {
              entity.onCollision(intersectionPoints, other);
            }
          }
        }
      }
    }
    Set<int> removeList = {};
    for(final key in potentialActiveEntity.keys) {
      for(int i = 0; i < potentialActiveEntity[key]!.length; i++){
        for(int j = 0; j < potentialActiveEntity[key]!.length; j++){
          Set<Vector2> intersectionPoints = {};
          if(i == j || removeList.contains(j)){
            continue;
          }
          if(!potentialActiveEntity[key]![i].onComponentTypeCheck(potentialActiveEntity[key]![j])
              && !potentialActiveEntity[key]![j].onComponentTypeCheck(potentialActiveEntity[key]![i])) {
            continue;
          }
          PositionComponent comp1 = potentialActiveEntity[key]![i].parent as PositionComponent;
          PositionComponent comp2 = potentialActiveEntity[key]![j].parent as PositionComponent;
          var entity = potentialActiveEntity[key]![i];
          var other = potentialActiveEntity[key]![j];
          for(int i=-1;i<entity.getVerticesCount() - 1;i++) {
            if(!entity.isLoop && i == -1){
              continue;
            }
            Vector2 first,second;
            if(i == -1){
              first = entity.getPoint(entity.getVerticesCount() - 1) + comp1.position;
              second = entity.getPoint(0) + comp1.position;
            }else{
              first = entity.getPoint(i) + comp1.position;
              second = entity.getPoint(i+1) + comp1.position;
            }
            for(int j=-1;j<other.getVerticesCount() - 1;j++) {
              Vector2 otherFirst,otherSecond;
              if(!other.isLoop && j == -1){
                continue;
              }
              if(j == -1){
                otherFirst = other.getPoint(other.getVerticesCount() - 1) + comp2.position;
                otherSecond = other.getPoint(0) + comp2.position;
              }else{
                otherFirst = other.getPoint(j) + comp2.position;
                otherSecond = other.getPoint(j+1) + comp2.position;
              }
              Vector2 point = pointOfIntersect(first, second, otherFirst, otherSecond);
              if(point != Vector2.zero()) {
                intersectionPoints.add(point);
              }
            }
          }
        }
        removeList.add(i);
      }
    }

  }



}

//return point of intersects of two lines from 4 points
Vector2 pointOfIntersect(Vector2 a1, Vector2 a2, Vector2 b1, Vector2 b2)
{
  double s1_x, s1_y, s2_x, s2_y;
  s1_x = a2.x - a1.x;
  s1_y = a2.y - a1.y;
  s2_x = b2.x - b1.x;
  s2_y = b2.y - b1.y;

  double s, t;
  s = (-s1_y * (a1.x - b1.x) + s1_x * (a1.y - b1.y)) /
      (-s2_x * s1_y + s1_x * s2_y);
  t = (s2_x * (a1.y - b1.y) - s2_y * (a1.x - b1.x)) /
      (-s2_x * s1_y + s1_x * s2_y);

  if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
    return Vector2(a1.x + (t * s1_x), a1.y + (t * s1_y));
  }
  return Vector2.zero();
}