#ifndef QUESTIONTABLEMODEL_H
#define QUESTIONTABLEMODEL_H

#include <QAbstractItemModel>

#include "quesiton.h"

#define ROLE_ID Qt::UserRole + 1
#define ROLE_TEXT Qt::UserRole + 2
#define ROLE_IMAGE_NAME Qt::UserRole + 3
#define ROLE_APPROVED Qt::UserRole + 4
#define ROLE_THEME Qt::UserRole + 5


class QuestionQueryModel : public QAbstractItemModel
{
  Q_OBJECT
  Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
  QuestionQueryModel(QObject* parent = 0);


  QHash<int, QByteArray> roleNames() const;
  QVariant data(const QModelIndex &idx, int role) const;

  Q_INVOKABLE QList<QVariantMap> answers(int questionRowID) const;

  Q_INVOKABLE void fromJSON(QString filePath);
  Q_INVOKABLE QString toJSON();

  Q_INVOKABLE QVariantMap get(int row);
  Q_INVOKABLE void set(int row, const QVariantMap& value);
  Q_INVOKABLE void create();
  Q_INVOKABLE void remove(int row);
  Q_INVOKABLE void approve(int row);
  Q_INVOKABLE void setTheme(const QString& theme);

private:
  QHash<int, QByteArray> m_roles;
  QList<Question> m_questions;
  QString m_theme;

public:
  Q_INVOKABLE int count() const;

signals:
  void countChanged();

private:
  QModelIndex index(int row, int column, const QModelIndex &parent) const;
  int rowCount(const QModelIndex &parent) const;
  int columnCount(const QModelIndex &parent) const;
  QModelIndex parent(const QModelIndex &child) const;
};

#endif // QUESTIONTABLEMODEL_H

