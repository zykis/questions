#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <questiontablemodel.h>
#include <QQmlContext>
#include <QSettings>
#include <QDebug>
#include <QSortFilterProxyModel>

// Local
#include "initdb.h"
#include "proxymodel.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  app.setOrganizationName("zykis");
  app.setOrganizationDomain("zykis.ru");
  app.setApplicationName("questions");
  QSettings settings;

//  database::initDB();

  QQmlApplicationEngine engine;
  QuestionQueryModel questionModel;
  if (settings.value("jsonFilePath", "").toString() != "") {
    questionModel.fromJSON(settings.value("jsonFilePath", "").toString());
  }
  ProxyModel proxyModel;
  proxyModel.setSourceModel(&questionModel);
  proxyModel.setFilterRole(Qt::UserRole + 4);


  QQmlContext* objectContext = engine.rootContext();
  objectContext->setContextProperty("questionModel", &questionModel);
  objectContext->setContextProperty("proxyModel", &proxyModel);
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  return app.exec();
}
