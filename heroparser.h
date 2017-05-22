#ifndef HEROPARSER_H
#define HEROPARSER_H

#include <QObject>
#include <QList>
#include "hero.h"

class HeroParser
{

public:
  static QList<Hero> parse(QString heroesFilePath);
};

#endif // HEROPARSER_H
