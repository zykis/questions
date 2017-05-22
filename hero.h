#ifndef HERO_H
#define HERO_H

#include <QString>
#include <QVariant>


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

    qWarning() << QString("No key: %1 in hero").arg(key);
    return QVariant();
  }
};

#endif // HERO_H
