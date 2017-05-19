#ifndef QUESITON_H
#define QUESITON_H

// Local
#include "answer.h"
#include "theme.h"

// Qt
#include <QList>
#include <QVariantMap>


struct Question
{
  int id;
  QString textEn;
  QString textRu;
  QString imageName;
  Theme theme;
  bool approved;
  QList<Answer> answers;

  Question()
  {
    approved = false;
    for(int i = 0; i < 4; i++)
      answers.append(Answer());
  }

  operator QVariantMap()
  {
    QVariantMap vm;
    vm["id"] = id;
    vm["text_en"] = textEn;
    vm["text_ru"] = textRu;
    vm["approved"] = approved;
    vm["theme"] = (QVariantMap)theme;

    QVariantList vl;
    for (Answer a: answers)
    {
      vl << (QVariantMap)a;
    }
    vm["answers"] = vl;
    return vm;
  }
};

#endif // QUESITON_H
