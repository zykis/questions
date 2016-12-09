#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <questiontablemodel.h>
#include <QQmlContext>

// Local
#include "initdb.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);

  database::initDB();

  QQmlApplicationEngine engine;
  QuestionTableModel questionModel;
  QQmlContext* objectContext = engine.rootContext();
  objectContext->setContextProperty("questionModel", &questionModel);
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  return app.exec();
}
