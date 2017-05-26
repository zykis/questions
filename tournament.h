#ifndef TOURNAMENT_H
#define TOURNAMENT_H

#include <QString>
#include <QVariant>

#include "hero.h"

typedef enum region {
  NorthAmerica = 0, SouthAmerica, Europe, CIS, China, SEA // south east asia
} Region;

struct Player {
  QString name;

};

struct Team {
  QString name;
  Region region;
};

struct Tournament {
  QString name;

  float prizepool;
  float prize1place;

  QList<Hero> mostBans;
  QList<Hero> mostPicks;

  QString winnerTeam;
  QStringList directInviteTeams;
  QMap<QString, QString> qualifiedTeams;

  QVariant getattr(QString key)
  {
    if (key == "name")
      return name;
    qWarning() << QString("No key: %1 in tournament").arg(key);
    return QVariant();
  }
};

#endif // TOURNAMENT_H
