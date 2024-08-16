import 'package:game_flame/Items/Dresses/armorDress.dart';
import 'package:game_flame/Items/Dresses/bootsDress.dart';
import 'package:game_flame/Items/Dresses/flasks.dart';
import 'package:game_flame/Items/Dresses/glovesDress.dart';
import 'package:game_flame/Items/Dresses/helmetDress.dart';
import 'package:game_flame/Items/Dresses/ringDress.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/Dresses/swordDress.dart';
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

String getMagicStateString(MagicDamage? magDamage)
{
  switch(magDamage)
  {
    case MagicDamage.none: return 'images/inventar/gif/blueCancel.gif';
    case MagicDamage.fire: return 'images/inventar/gif/red.gif';
    case MagicDamage.ice: return 'images/inventar/gif/blue.gif';
    case MagicDamage.poison: return 'images/inventar/gif/poison.gif';
    case MagicDamage.lightning: return 'images/inventar/gif/electro.gif';
    case MagicDamage.copyOfPlayer: return 'images/inventar/gif/dark.gif';
    case null:
      return 'images/inventar/gif/blueCancel.gif';
  }
}

enum MagicDamage
{
  none,
  fire,
  ice,
  poison,
  lightning,
  copyOfPlayer
}

enum InventarType
{
  helmet,
  bodyArmor,
  gloves,
  boots,
  sword,
  ring,
  flask,
  item,
}

Item itemFromName(String id)
{
  if(id.startsWith('sword')){
    return getSword(int.parse(id.split('sword')[1]));
  }
  if(id.startsWith('ring')){
    return getRing(int.parse(id.split('ring')[1]));
  }
  if(id.startsWith('boots')){
    return getBoots(int.parse(id.split('boots')[1]));
  }
  if(id.startsWith('helmet')){
    return getHelmet(int.parse(id.split('helmet')[1]));
  }
  if(id.startsWith('armor')){
    return getArmor(int.parse(id.split('armor')[1]));
  }
  if(id.startsWith('gloves')){
    return getGloves(int.parse(id.split('gloves')[1]));
  }
  switch(id){
    case 'keyForChestOfGlory': return KeyForChestOfGlory();
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
      case InventarType.bodyArmor:
        hash = game.playerData.bodyArmorInventar;
        break;
      case InventarType.sword:
        hash = game.playerData.swordInventar;
        break;
      case InventarType.flask:
        hash = game.playerData.flaskInventar;
        break;
      case InventarType.item:
        hash = game.playerData.itemInventar;
        break;
      case InventarType.helmet:
        hash = game.playerData.helmetInventar;
        break;
      case InventarType.gloves:
        hash = game.playerData.glovesInventar;
        break;
      case InventarType.boots:
        hash = game.playerData.bootsInventar;
        break;
      case InventarType.ring:
        hash = game.playerData.ringInventar;
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
  MagicSpellVariant magicSpellVariant = MagicSpellVariant.none;
  String? description;


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

