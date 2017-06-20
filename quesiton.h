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
    vm["image_name"] = imageName;

    QVariantList vl;
    for (Answer a: answers)
    {
      vl << (QVariantMap)a;
    }
    vm["answers"] = vl;
    return vm;
  }

  Question(const QVariantMap &vm)
  {
    id = vm["id"].toInt();
    textEn = vm["text_en"].toString();
    textRu = vm["text_ru"].toString();
    approved = vm["approved"].toBool();
    Theme t = vm["theme"].toMap();
    theme = t;
    imageName = vm["image_name"].toString();

    answers.clear();
    for (QVariant vma: vm["answers"].toList()) {
      QVariantMap vmm = vma.toMap();
      Answer a(vmm);
      answers.append(a);
    }
  }
};

#endif // QUESITON_H
