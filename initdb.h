#ifndef INITDB_H
#define INITDB_H

// Ot
#include <QFileInfo>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

namespace database
{
bool initDB()
{
  QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
  QString dbName = QString("questions.sqlite");

  QFileInfo checkFile(dbName);
  bool newDB = false;
  if (!checkFile.isFile())
  {
    qDebug() << "Database File does not exist. New Database will be created";
    newDB = true;
  }

  db.setDatabaseName(dbName);
  if (db.open())
    qDebug() << QString("Connected to Database file \"%1\"").arg(checkFile.absolutePath());
  else
    qDebug() <<  QString("Database file \"%1\" was not opened").arg(dbName);

  QSqlQuery query;
  QString queryText = "PRAGMA foreign_keys = ON";
  if (!query.exec(queryText))
  {
    qDebug() << "Wrong query:" << queryText;
    qDebug() << query.lastError();
  }

  if (newDB)
  {

    queryText = "CREATE TABLE IF NOT EXISTS themes ("
                "id INTEGER PRIMARY KEY, "
                "name TEXT NOT NULL, "
                "image_url TEXT "
                ")";
    if (!query.exec(queryText))
    {
      qDebug() << "Wrong query:" << queryText;
      qDebug() << query.lastError();
    }

    queryText = "INSERT INTO themes (name) VALUES (:name)";
    query.prepare(queryText);
    query.bindValue(":name", "lore");
    if (!query.exec())
    {
      qDebug() << "Wrong query:" << queryText;
      qDebug() << query.lastError();
    }

    queryText = "INSERT INTO themes (name) VALUES (:name)";
    query.prepare(queryText);
    query.bindValue(":name", "tournaments");
    if (!query.exec())
    {
      qDebug() << "Wrong query:" << queryText;
      qDebug() << query.lastError();
    }

    queryText = "INSERT INTO themes (name) VALUES (:name)";
    query.prepare(queryText);
    query.bindValue(":name", "mechanics");
    if (!query.exec())
    {
      qDebug() << "Wrong query:" << queryText;
      qDebug() << query.lastError();
    }

    queryText = "CREATE TABLE IF NOT EXISTS questions ("
                "id INTEGER PRIMARY KEY, "
                "theme_id INTEGER NOT NULL, "
                "image_url TEXT, "
                "text_en TEXT NOT NULL, "
                "text_ru TEXT NOT NULL, "
                "approved BOOLEAN DEFAULT FALSE, "
                "FOREIGN KEY(theme_id) REFERENCES themes(id) ON DELETE CASCADE ON UPDATE CASCADE"
                ")";
    if (!query.exec(queryText))
    {
      qDebug() << "Wrong query:" << queryText;
      qDebug() << query.lastError();
    }

    queryText = "CREATE TABLE IF NOT EXISTS answers ("
                "id INTEGER PRIMARY KEY, "
                "question_id INTEGER NOT NULL, "
                "text_en TEXT, "
                "text_ru TEXT, "
                "is_correct BOOLEAN, "
                "FOREIGN KEY(question_id) REFERENCES questions(id) ON DELETE CASCADE ON UPDATE CASCADE"
                ")";
    if (!query.exec(queryText))
    {
      qDebug() << "Wrong query:" << queryText;
      qDebug() << query.lastError();
    }
  }

  return true;
}
}

#endif // INITDB_H
