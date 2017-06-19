// Qt
#include <QFileInfo>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QDebug>

// Local
#include "heroparser.h"


QList<Hero> HeroParser::parse(QString heroesFilePath)
{
  QList<Hero> heroes;

  QFileInfo fileInfo(heroesFilePath);
  QFile jsonFile(fileInfo.absoluteFilePath());
  if (!jsonFile.open(QIODevice::ReadOnly)) {
    qDebug() << "File open error: " << heroesFilePath;
    return heroes;
  }

  QByteArray ba = jsonFile.readAll();
  jsonFile.close();

  QJsonParseError error;
  QJsonDocument document = QJsonDocument::fromJson(ba, &error);
  if (document.isNull())
  {
    qDebug() << "heroes.json parse error: " << error.errorString();
  }
  for (auto qObj: document.array())
  {
    QJsonObject obj = qObj.toObject();
    Hero h;
    h.name = obj.value("name").toString();

    h.strength = obj.value("str").toDouble();
    h.strength_per_lvl = obj.value("str_per_lvl").toDouble();
    h.agility = obj.value("agi").toDouble();
    h.agility_per_lvl = obj.value("agi_per_lvl").toDouble();
    h.intelligence = obj.value("int").toDouble();
    h.intelligence_per_lvl = obj.value("int_per_lvl").toDouble();

    h.armor = obj.value("armor").toDouble();
    h.movement_speed = obj.value("movement_speed").toDouble();
    h.melee = obj.value("melee").toBool();
    h.attack_range = obj.value("attack_range").toDouble();

    heroes.append(h);
  }

  return heroes;
}
