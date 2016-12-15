#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <questiontablemodel.h>
#include <QQmlContext>
#include <QSettings>
#include <QDebug>

// Local
#include "initdb.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  app.setOrganizationName("zykis");
  app.setOrganizationDomain("zykis.ru");
  app.setApplicationName("questions");
  QSettings settings;
  qDebug() << "Settings path to questions: " << settings.value("questionsFolder", "WTF").toString();

  database::initDB();

  QQmlApplicationEngine engine;
  QuestionQueryModel questionModel;
  if (settings.value("jsonFilePath", "").toString() != "") {
    questionModel.fromJSON(settings.value("jsonFilePath", "").toString());
  }

  QQmlContext* objectContext = engine.rootContext();
  objectContext->setContextProperty("questionModel", &questionModel);
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  return app.exec();
}
