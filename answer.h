#ifndef ANSWER_H
#define ANSWER_H

#include <QVariantMap>

struct Answer {
  int id;
  QString textEn;
  QString textRu;
  bool isCorrect;

  operator QVariantMap() const {
    QVariantMap vm;
    vm.insert("text_en", textEn);
    vm.insert("text_ru", textRu);
    vm.insert("isCorrect", isCorrect);
    return vm;
  }
};

#endif // ANSWER_H
