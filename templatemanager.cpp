// Qt
#include <QDebug>

// Local
#include "templatemanager.h"
#include "heroparser.h"

TemplateManager::TemplateManager()
{}

TemplateManager::~TemplateManager()
{}


QList<Question> TemplateManager::parseTemplates(QString templatesFilePath)
{
  QList<Question> templates;
  QFile file(templatesFilePath);
  if (!file.open(QIODevice::ReadOnly))
  {
    qDebug() << "Error opening file: " << templatesFilePath;
    return templates;
  }

  // [1] remove comments and empty lines
  QList<QString> lines;
  char buff[1024];
  while (file.readLine(buff, 1024) != -1) {
    QString line = QString(buff);
    if (line.startsWith('#') || (line.simplified() == ""))
      continue;
    else
      lines.append(line);
  }

  // [2] devide templates
  Question t;
  for (QString l: lines) {
    if (l.startsWith("EN: "))
      t.textEn = l.remove("EN: ");
    else if (l.startsWith("RU: ")) {
      t.textRu = l.remove("RU: ");
      templates.append(t);
    }
  }

  return templates;
}


//QList<Question> TemplateManager::generateQuestions(QList<Question> templates)
//{
//  QList<Question> questions;
//  for (Question t: templates) {
//    QList<Question> templateQuestions = generateQuestionsFromTemplate(t);
//    questions.append(templateQuestions);
//  }

//  return questions;
//}


//QVariantList TemplateManager::generateQuestionsFromTemplate(Question temp)
//{
//  QList<QVariant> questions;

//  int ind = temp.textEn.indexOf("$$");

//  int min_ind = temp.textEn.size(); // индекс элемента, следующего за $$property.name
//  for (char ch: escape_characters)
//  {
//    int ch_ind = temp.textEn.indexOf(ch, ind);
//    if (ch_ind < ind)
//      continue;

//    if (ch_ind < min_ind)
//      min_ind = ch_ind;
//  }

//  QString propertyName = temp.textEn.mid(ind + 2, min_ind - ind - 2);
//  qDebug() << "property name: " << propertyName;
//  if (propertyName.split('.').size() < 2) {
//    qDebug() << "property name %1 doesn't contain DOT";
//    return questions;
//  }

//  QString key = propertyName.split('.').at(1);

//  if (propertyName.split('.').first() == "hero") {
//    QList<Hero> heroes = HeroParser::parse("heroes.json");
//    for (Hero h: heroes) {
//      Question q;
//      Question t = temp;
//      QVariant property = h.getattr(key);
//      QString textEn = t.textEn.replace("$$" + propertyName, property.toString());
//      QString textRu = t.textRu.replace("$$" + propertyName, property.toString());

//      q.textEn = textEn;
//      q.textRu = textRu;
//      questions.append((QVariantMap)q);
//    }
//  }

//  return questions;
//}

QVariantList TemplateManager::generateQuestionsFromTemplate(QVariantMap tmp)
{
  Question temp = (Question)tmp;
  QList<QVariant> questions;

  int ind = temp.textEn.indexOf("$$");

  int min_ind = temp.textEn.size(); // индекс элемента, следующего за $$property.name
  for (char ch: escape_characters)
  {
    int ch_ind = temp.textEn.indexOf(ch, ind);
    if (ch_ind < ind)
      continue;

    if (ch_ind < min_ind)
      min_ind = ch_ind;
  }

  QString propertyName = temp.textEn.mid(ind + 2, min_ind - ind - 2);
  qDebug() << "property name: " << propertyName;
  if (propertyName.split('.').size() < 2) {
    qDebug() << "property name %1 doesn't contain DOT";
    return questions;
  }

  QString key = propertyName.split('.').at(1);

  if (propertyName.split('.').first() == "hero") {
    QList<Hero> heroes = HeroParser::parse("heroes.json");
    for (Hero h: heroes) {
      Question q;
      Question t = temp;
      QVariant property = h.getattr(key);
      QString textEn = t.textEn.replace("$$" + propertyName, property.toString());
      QString textRu = t.textRu.replace("$$" + propertyName, property.toString());

      q.textEn = textEn;
      q.textRu = textRu;
      questions.append((QVariantMap)q);
    }
  }

  return questions;
}
