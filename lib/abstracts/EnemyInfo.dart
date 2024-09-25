const damageDel = 40;
const armorDel = 40;
const healthDel = 40;

class GoblinInfo
{
  static const double _damage = 16;
  static const double _health = 80;
  static const double _armor = 0.8; //Damage scale на сколько будет умножаться урон игрока
  static const double speed = 70;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class GollemInfo
{
  static const double _damage = 28;
  static const double _health = 100;
  static const double speed = 50;
  static const double _armor = 0.06;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class HumanInfo
{
  static const double _damage = 19;
  static const double _health = 130;
  static const double _armor = 0.7;
  static const double speed = 60;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class MooseInfo
{
  static const double _damage = 29;
  static const double _health = 230;
  static const double _armor = 0.5;
  static const double speed = 50;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class OgrInfo
{
  static const double _damage = 28;
  static const double _health = 230;
  static const double _armor = 0.4;
  static const double speed = 50;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class OrcInfo
{
  static const double _damage = 22;
  static const double _health = 150;
  static const double _armor = 0.5;
  static const double speed = 60;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class OrcMageInfo
{
  static const double _damage = 15;
  static const double _health = 130;
  static const double _armor = 0.5;
  static const double speed = 60;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class ManySpikesInfo
{
  static const double _damage = 19;
  static damage(int level) => _damage + (_damage * level) / 10;
}

class SpkikeInfo
{
  static const double _damage = 21;
  static damage(int level) => _damage + (_damage * level) / damageDel;

}

class OrcAcidInfo
{
  static const double _damage = 18;
  static damage(int level) => _damage + (_damage * level) / damageDel;
}

class OrcAcidRainInfo
{
  static const double _damage = 20;
  static damage(int level) => _damage + (_damage * level) / damageDel;
}

class PotInfo
{
  static const double _damage = 11;
  static const double _health = 100;
  static const double _armor = 0.8;
  static const double speed = 40;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class SceletBossInfo
{
  static const double _damage = 41;
  static const double _health = 700;
  static const double _armor = 0.4;
  static const double speed = 40;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class SceletBoomInfo
{
  static const double _damage = 24;
  static damage(int level) => _damage + (_damage * level) / damageDel;
}

class PotBubbleInfo
{
  static const double _damage = 19;
  static damage(int level) => _damage + (_damage * level) / damageDel;
}

class AssasinUndeadInfo
{
  static const double _damage = 24;
  static const double _health = 130;
  static const double _armor = 0.45;
  static const double speed = 68;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class SkeletInfo
{
  static const double _damage = 19;
  static const double _health = 100;
  static const double _armor = 0.6;
  static const double speed = 60;
  static damage(int level) => _damage + (_damage * level) / damageDel;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class SkeletMageInfo
{
  static const double _health = 100;
  static const double _armor = 0.6;
  static const double speed = 60;
  static health(int level) => _health + (_health * level) / healthDel;
  static armor(int level) => _armor;
}

class SkeletBubbleInfo
{
  static const double _damage = 5;
  static damage(int level) => _damage + (_damage * level) / damageDel;
}

class SpinBladeInfo
{
  static const double _damage = 26;
  static damage(int level) => _damage + (_damage * level) / damageDel;
}

class ArrowInfo
{
  static const double _damage = 16;
  static damage(int level) => _damage + (_damage * level) / damageDel;
}

class BarrelInfo
{
  static const double _damage = 21;
  static damage(int level) => _damage + (_damage * level) / damageDel;
}

class BarrelWithMetalInfo
{
  static const double _damage = 23;
  static damage(int level) => _damage + (_damage * level) / damageDel;
}

class ElectroTrapInfo
{
  static const double _damage = 26;
  static damage(int level) => _damage + (_damage * level) / damageDel;
}