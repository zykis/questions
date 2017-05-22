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
    vm.insert("isCorrect", isCorrect);
    return vm;
  }

  Answer() {}
  Answer(const QVariantMap& vm)
  {
    isCorrect = vm["isCorrect"].toBool();
    textEn = vm["text_en"].toString();
    textRu = vm["text_ru"].toString();
  }
};

#endif // ANSWER_H
