#ifndef THEME_H
#define THEME_H

#include <QVariantMap>

struct Theme {
  int id;
  QString name;

  operator QVariantMap()
  {
    QVariantMap vm;
    vm.insert("id", id);
    vm.insert("name", name);
    return vm;
  }

  Theme() {}

  Theme(const QVariantMap &vm)
  {
    id = vm["id"].toInt();
    name = vm["name"].toString();
  }
};

#endif // THEME_H
