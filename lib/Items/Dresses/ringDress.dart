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
    dressType = DressType.ring;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.armor, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
    game.playerData.playerMagicSpell = PlayerMagicSpell.darkBall;
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
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.armor, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
    game.playerData.playerMagicSpell = PlayerMagicSpell.electroBall;
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
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.armor, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
    game.playerData.playerMagicSpell = PlayerMagicSpell.fireBallBlue;
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
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.armor, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
    game.playerData.playerMagicSpell = PlayerMagicSpell.fireBallRed;
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
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.armor, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
    game.playerData.playerMagicSpell = PlayerMagicSpell.poisonBall;
  }
}
