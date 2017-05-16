#ifndef QUESITON_H
#define QUESITON_H

// Local
#include "answer.h"
#include "theme.h"

// Qt
#include <QList>


struct Question
{
  int id;
  QString textEn;
  QString textRu;
  QString imageName;
  Theme theme;
  bool approved;
  QList<Answer> answers;
};

#endif // QUESITON_H
