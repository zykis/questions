#ifndef QUESITON_H
#define QUESITON_H
#include <QList>
#include "answer.h"

struct Question
{
  int id;
  QString text;
  QString imageName;
  QString theme;
  bool approved;
  QList<Answer> answers;
};

#endif // QUESITON_H
