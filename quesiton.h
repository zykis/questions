#ifndef QUESITON_H
#define QUESITON_H
#include <QList>
#include "answer.h"

struct Question
{
  int id;
  QString textEn;
  QString textRu;
  QString imageName;
  QString theme;
  bool approved;
  QList<Answer> answers;
};

#endif // QUESITON_H
