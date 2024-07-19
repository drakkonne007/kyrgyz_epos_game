import 'package:game_flame/Items/armorDress.dart';
import 'package:game_flame/Items/flasks.dart';
import 'package:game_flame/Items/helmetDress.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/swordDress.dart';
import 'package:game_flame/Quests/chestOfGlory.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

enum DressType
{
  none,
  helmet,
  armor,
  gloves,
  sword,
  ring,
  boots,
}

enum MagicDamage
{
  none,
  fire,
  ice,
  poison,
  lightning,
}

enum InventarType
{
  weapon,
  armor,
  flask,
  item,
}

Item itemFromName(String id)
{
  switch(id){
    case 'keyForChestOfGlory': return KeyForChestOfGlory();
    case 'armorStart':   return ArmorStart();
    case 'startHelmet':  return StartHelmet();
    case 'swordStart':   return SwordStart();
    case 'sword1': return Sword1();
    case 'sword2': return Sword2();
    case 'sword3': return Sword3();
    case 'sword4': return Sword4();
    case 'sword5': return Sword5();
    case 'sword6': return Sword6();
    case 'sword7': return Sword7();
    case 'sword8': return Sword8();
    case 'sword9': return Sword9();
    case 'sword10': return Sword10();
    case 'sword11': return Sword11();
    case 'sword12': return Sword12();
    case 'sword13': return Sword13();
    case 'sword14': return Sword14();
    case 'sword15': return Sword15();
    case 'sword16': return Sword16();
    case 'sword17': return Sword17();
    case 'sword18': return Sword18();
    case 'sword19': return Sword19();
    case 'sword20': return Sword20();
    case 'sword21': return Sword21();
    case 'sword22': return Sword22();
    case 'sword23': return Sword23();
    case 'sword24': return Sword24();
    case 'sword25': return Sword25();
    case 'sword26': return Sword26();
    case 'sword27': return Sword27();
    case 'sword28': return Sword28();
    case 'sword29': return Sword29();
    case 'sword30': return Sword30();
    case 'sword31': return Sword31();
    case 'sword32': return Sword32();
    case 'sword33': return Sword33();
    case 'sword34': return Sword34();
    case 'sword35': return Sword35();
    case 'sword36': return Sword36();
    case 'sword37': return Sword37();
    case 'sword38': return Sword38();
    case 'sword39': return Sword39();
    case 'sword40': return Sword40();
    case 'sword41': return Sword41();
    case 'sword42': return Sword42();
    case 'sword43': return Sword43();
    case 'sword44': return Sword44();
    case 'sword45': return Sword45();
    case 'sword46': return Sword46();
    case 'sword47': return Sword47();
    case 'sword48': return Sword48();
    case 'sword49': return Sword49();
    case 'sword50': return Sword50();
    case 'sword51': return Sword51();
    case 'sword52': return Sword52();
    case 'sword53': return Sword53();
    case 'sword54': return Sword54();
    case 'sword55': return Sword55();
    case 'sword56': return Sword56();
    case 'sword57': return Sword57();
    case 'sword58': return Sword58();
    case 'sword59': return Sword59();
    case 'sword60': return Sword60();
    case 'sword61': return Sword61();
    case 'sword62': return Sword62();
    case 'sword63': return Sword63();
    case 'sword64': return Sword64();
    case 'sword65': return Sword65();
    case 'sword66': return Sword66();
    case 'sword67': return Sword67();
    case 'sword68': return Sword68();
    case 'sword69': return Sword69();
    case 'sword70': return Sword70();
    case 'sword71': return Sword71();
    case 'sword72': return Sword72();
    case 'sword73': return Sword73();
    case 'sword74': return Sword74();
    case 'sword75': return Sword75();
    case 'sword76': return Sword76();
    case 'sword77': return Sword77();
    case 'sword78': return Sword78();
    case 'sword79': return Sword79();
    case 'sword80': return Sword80();
    case 'sword81': return Sword81();
    case 'sword82': return Sword82();
    case 'sword83': return Sword83();
    case 'sword84': return Sword84();
    case 'sword85': return Sword85();
    case 'sword86': return Sword86();
    case 'sword87': return Sword87();
    case 'sword88': return Sword88();
    case 'sword89': return Sword89();
    case 'sword90': return Sword90();
    case 'sword91': return Sword91();
    case 'sword92': return Sword92();
    case 'sword93': return Sword93();
    case 'sword94': return Sword94();
    case 'sword95': return Sword95();
    case 'sword96': return Sword96();
    case 'hpSmall':   return HpSmall();
    case 'hpMedium':   return HpMedium();
    case 'hpBig':     return HpBig();
    case 'hpFull':    return HpFull();
    case 'energySmall': return EnergySmall();
    case 'energyMedium': return EnergyMedium();
    case 'energyBig': return EnergyBig();
    case 'energyFull': return EnergyFull();
    case 'gold': return Gold();
    default: return NullItem();
  }
}

// Widget itemWidgetFromName(String id)
// {
//   switch(id){
//     case 'pureHat':   return PureHat('pureHat');
//     case 'strongHat':   return StrongHat('strongHat');
//     case 'gold':   return Gold('gold');
//     default: return PureHat('gold');
//   }
// }

abstract class Item
{
  Item()
  {
    assert(attackSpeed > - 0.06, 'Некорректное значение скорости атаки $id');
  }

  String id = '';
  void getEffect(KyrgyzGame game)
  {
    throw 'Not override catch item';
  }
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    throw 'Not override catch item from inventar';
  }

  void minusInInventar(KyrgyzGame game, InventarType type)
  {
    Map<String,int> hash;
    switch(type){
      case InventarType.armor:
        hash = game.playerData.armorInventar;
        break;
      case InventarType.weapon:
        hash = game.playerData.weaponInventar;
        break;
      case InventarType.flask:
        hash = game.playerData.flaskInventar;
        break;
      case InventarType.item:
        hash = game.playerData.itemInventar;
        break;
    }
    if(hash.containsKey(id)){
      int curr = hash[id]!;
      curr--;
      if(curr == 0){
        hash.remove(id);
      }else{
        hash[id] = curr;
      }
    }
  }

  bool isStaticObject = false;
  double hp = 0;
  double energy = 0;
  double armor = 0;
  bool inArmor = true;
  double chanceOfLoot = 0;
  double hurtMiss = 0;
  double damage = 0;
  bool enabled = true;
  double attackSpeed = 0; //Отнимается/прибавляется к скорости атаки
  DressType dressType = DressType.none;
  String source = '';
  int cost = 0;
  int? countOfUses;
  MagicDamage? magicDamage;
  double permanentDamage = 0;
  double secsOfPermDamage = 0;


  @override
  bool operator ==(Object other) {
    if(other is! Item){
      return false;
    }
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

