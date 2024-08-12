import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'package:game_flame/kyrgyz_game.dart';

class Ring1 extends Item
{
  Ring1()
  {
    id = 'Ring1';
    source = 'images/inventar/ring/1.png';
    hp = 0;
    cost = 100;
    armor = 0.01;
    permanentDamage = 2;
    secsOfPermDamage = 3;
    dressType = DressType.ring;
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
  Ring2()
  {
    id = 'Ring2';
    source = 'images/inventar/ring/2.png';
    hp = 0;
    cost = 100;
    armor = 0.01;
    dressType = DressType.ring;
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
    id = 'Ring3';
    source = 'images/inventar/ring/3.png';
    hp = 0;
    cost = 100;
    armor = 0.01;
    dressType = DressType.ring;
    magicDamage = MagicDamage.lightning;
    magicSpellVariant = MagicSpellVariant.circle;
    permanentDamage = 2;
    secsOfPermDamage = 1;
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
    id = 'Ring4';
    source = 'images/inventar/ring/4.png';
    hp = 0;
    cost = 100;
    armor = 0.01;
    dressType = DressType.ring;
    magicDamage = MagicDamage.poison;
    magicSpellVariant = MagicSpellVariant.forward;
    permanentDamage = 1;
    secsOfPermDamage = 8;
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
    id = 'Ring5';
    source = 'images/inventar/ring/5.png';
    hp = 0;
    cost = 100;
    armor = 0.01;
    dressType = DressType.ring;
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
