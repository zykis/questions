#ifndef QUESTIONTABLEMODEL_H
#define QUESTIONTABLEMODEL_H

#include <QSqlQueryModel>

#include "quesiton.h"

#define ROLE_ID Qt::UserRole + 1
#define ROLE_TEXT Qt::UserRole + 2
#define ROLE_IMAGE_NAME Qt::UserRole + 3
#define ROLE_APPROVED Qt::UserRole + 4


class QuestionQueryModel : public QSqlQueryModel
{
  Q_OBJECT

public:
  QuestionQueryModel(QObject* parent = 0);

  QHash<int, QByteArray> roleNames() const;
  QVariant data(const QModelIndex &idx, int role) const;

  Q_INVOKABLE QList<QVariantMap> answers(int questionRowID) const;

  Q_INVOKABLE void fromJSON(QString filePath);
  Q_INVOKABLE QString toJSON();
  int rowCount(const QModelIndex &parent) const;

private:
  QHash<int, QByteArray> m_roles;
  QList<Question> m_questions;
};

#endif // QUESTIONTABLEMODEL_H

