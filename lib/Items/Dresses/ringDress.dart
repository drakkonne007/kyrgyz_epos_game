import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

Item getRing(int id)
{
  switch(id)
  {
    case 1:
      return Ring1();
    case 2:
      return Ring2();
    case 3:
      return Ring3();
    case 4:
      return Ring4();
    case 5:
      return Ring5();
    // case 6:
    //   return Ring6();
    // case 7:
    //   return Ring7();
    // case 8:
    //   return Ring8();
    // case 9:
    //   return Ring9();
    // case 10:
    //   return Ring10();
    // case 11:
    //   return Ring11();
    // case 12:
    //   return Ring12();
    // case 13:
    //   return Ring13();
    // case 14:
    //   return Ring14();
    // case 15:
    //   return Ring15();
    // case 16:
    //   return Ring16();
    // case 17:
    //   return Ring17();
    // case 18:
    //   return Ring18();
    // case 19:
    //   return Ring19();
    // case 20:
    //   return Ring20();
    // case 21:
    //   return Ring21();
    // case 22:
    //   return Ring22();
    // case 23:
    //   return Ring23();
    // case 24:
    //   return Ring24();
    // case 25:
    //   return Ring25();
    // case 26:
    //   return Ring26();
    default: throw 'Ring with id $id not found';
  }
}

class Ring1 extends Item
{
  Ring1()
  {
    id = 'ring1';
    source = 'images/inventar/ring/1.png';
    hp = 0;
    cost = 100;
    armor = 0.01;
    manaCost = 10;
    permanentDamage = 3;
    secsOfPermDamage = 3;
    dressType = InventarType.ring;
    magicDamage = MagicDamage.fire;
    magicSpellVariant = MagicSpellVariant.forward;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.ring, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Ring2 extends Item
{
  ringRing2()
  {
    id = 'ring2';
    source = 'images/inventar/ring/2.png';
    hp = 0;
    cost = 100;
    manaCost = 10;
    armor = 0.01;
    dressType = InventarType.ring;
    magicDamage = MagicDamage.ice;
    magicSpellVariant = MagicSpellVariant.circle;
    permanentDamage = 0;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.ring, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Ring3 extends Item
{
  Ring3()
  {
    id = 'ring3';
    source = 'images/inventar/ring/3.png';
    hp = 0;
    cost = 100;
    manaCost = 10;
    armor = 0.01;
    dressType = InventarType.ring;
    magicDamage = MagicDamage.lightning;
    magicSpellVariant = MagicSpellVariant.circle;
    permanentDamage = 4;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.ring, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Ring4 extends Item
{
  Ring4()
  {
    id = 'ring4';
    source = 'images/inventar/ring/4.png';
    hp = 0;
    cost = 100;
    manaCost = 10;
    armor = 0.01;
    dressType = InventarType.ring;
    magicDamage = MagicDamage.poison;
    magicSpellVariant = MagicSpellVariant.forward;
    permanentDamage = 2;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.ring, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Ring5 extends Item
{
  Ring5()
  {
    id = 'ring5';
    source = 'images/inventar/ring/5.png';
    hp = 0;
    cost = 100;
    manaCost = 10;
    armor = 0.01;
    dressType = InventarType.ring;
    magicDamage = MagicDamage.copyOfPlayer;
    magicSpellVariant = MagicSpellVariant.forward;
    secsOfPermDamage = 15;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.ring, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}
