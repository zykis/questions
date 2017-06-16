#ifndef ANSWER_H
#define ANSWER_H

#include <QVariantMap>

struct Answer {
  int id;
  QString textEn;
  QString textRu;
  bool isCorrect;

  operator QVariantMap()
  {
    QVariantMap vm;
    vm.insert("text_en", textEn);
    vm.insert("text_ru", textRu);
    vm.insert("is_correct", isCorrect);
    return vm;
  }

  Answer() {}
  Answer(const QVariantMap& vm)
  {
    isCorrect = vm["is_correct"].toBool();
    textEn = vm["text_en"].toString();
    textRu = vm["text_ru"].toString();
  }
};

#endif // ANSWER_H
