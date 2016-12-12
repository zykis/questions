#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <questiontablemodel.h>
#include <QQmlContext>
#include <QSettings>

// Local
#include "initdb.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);

  database::initDB();

  QQmlApplicationEngine engine;
  QuestionQueryModel questionModel;
  QSettings settings;
  if (settings.value("jsonFilePath", "").toString() != "") {
    questionModel.fromJSON(settings.value("jsonFilePath", "").toString());
  }

  QQmlContext* objectContext = engine.rootContext();
  objectContext->setContextProperty("questionModel", &questionModel);
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  return app.exec();
}
