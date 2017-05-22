#ifndef THEME_H
#define THEME_H

#include <QVariantMap>

struct Theme {
  int id;
  QString textEn;
  QString textRu;

  operator QVariantMap()
  {
    QVariantMap vm;
    vm.insert("text_en", textEn);
    vm.insert("text_ru", textRu);
    vm.insert("id", id);
    return vm;
  }

  Theme() {}

  Theme(const QVariantMap &vm)
  {
    id = vm["id"].toInt();
    textEn = vm["text_en"].toString();
    textRu = vm["text_ru"].toString();
  }
};

#endif // THEME_H
