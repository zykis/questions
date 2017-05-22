// Qt
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
#include "templatemanager.h"


int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  app.setOrganizationName("zykis");
  app.setOrganizationDomain("zykis.ru");
  app.setApplicationName("questions");

  TemplateManager manager;
  QList<Question> templates = manager.parseTemplates("templates.txt");

  QSettings settings;

  QQmlApplicationEngine engine;
  QuestionQueryModel templateModel;
  templateModel.setQuestions(templates);

  QuestionQueryModel questionModel;
  if (settings.value("jsonFilePath", "").toString() != "") {
    questionModel.fromJSON(settings.value("jsonFilePath", "").toString());
  }
  ProxyModel proxyModel;
  proxyModel.setSourceModel(&questionModel);
  proxyModel.setFilterRole(Qt::UserRole + 4);

  QQmlContext* objectContext = engine.rootContext();
  objectContext->setContextProperty("templateManager", &manager);
  objectContext->setContextProperty("questionModel", &questionModel);
  objectContext->setContextProperty("templateModel", &templateModel);
  objectContext->setContextProperty("proxyModel", &proxyModel);
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

//  QObject* templatePage = engine.rootContext()->findChild<QObject*>("templatePage");
//  qDebug() << templatePage;

  return app.exec();
}
