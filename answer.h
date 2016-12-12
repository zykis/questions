#ifndef ANSWER_H
#define ANSWER_H

#include <QVariantMap>

struct Answer {
  int id;
  QString text;
  bool isCorrect;

  operator QVariantMap() const {
    QVariantMap vm;
    vm.insert("text", text);
    vm.insert("isCorrect", isCorrect);
    return vm;
  }
};

#endif // ANSWER_H
