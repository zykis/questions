#ifndef HERO_H
#define HERO_H

#include <QString>
#include <QVariant>

typedef enum { AbilityTypeActive = 0, AbilityTypePassive, AbilityTypeAutocast } AbilityType;
typedef enum { AbilityTargetNone = 0, AbilityTargetUnit, AbilityTargetArea } AbilityTarget;
typedef enum { EffectStun = 0, EffectRoot } Effect;
typedef enum { SpellImmunityPierceNo = 0, SpellImmunityPierceYes, SpellImmunityPiercePartially } SpellImmunityPierce;

struct Ability {
  QString name;
  AbilityType type;
  AbilityTarget target;
  SpellImmunityPierce spellImmunityPierce;
  QList<Effect> effects;

  int levels;

  float duration;
  float damage;

  QVariant getattr(QString key)
  {
    return QVariant();
  }
};

struct Hero {
  QString name;

  float strength;
  float strength_per_lvl;
  float agility;
  float agility_per_lvl;
  float intelligence;
  float intelligence_per_lvl;

  float armor;
  float movement_speed;
  bool melee;
  float attack_range;

  QList<Ability> abilities;

  QVariant getattr(QString key)
  {
    if (key == "name")
      return name;

    if (key == "strength")
      return strength;
    if (key == "strength_per_lvl")
      return strength_per_lvl;
    if (key == "agility")
      return agility;
    if (key == "agility_per_lvl")
      return agility_per_lvl;
    if (key == "intelligence")
      return intelligence;
    if (key == "intelligence_per_lvl")
      return intelligence_per_lvl;

    if (key == "armor")
      return armor;
    if (key == "movement_speed")
      return movement_speed;
    if (key == "melee")
      return melee;
    if (key == "attack_range")
      return attack_range;
    if (key == "ability")
      return QVariant();

    qWarning() << QString("No key: %1 in hero").arg(key);
    return QVariant();
  }
};

#endif // HERO_H
