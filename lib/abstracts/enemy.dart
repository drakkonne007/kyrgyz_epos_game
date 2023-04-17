

abstract class KyrgyzEnemy{
  double health = 0;
  double armor = 0;
  void doHurt({required double hurt, bool inArmor=true, double permanentDamage = 0, double secsOfPermDamage=0}){}
}