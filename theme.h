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
};

#endif // THEME_H
