#ifndef QUESTIONTABLEMODEL_H
#define QUESTIONTABLEMODEL_H

#include <QAbstractItemModel>

#include "quesiton.h"

#define ROLE_ID Qt::UserRole + 1
#define ROLE_IMAGE_NAME Qt::UserRole + 2
#define ROLE_APPROVED Qt::UserRole + 3
#define ROLE_THEME_NAME Qt::UserRole + 4
#define ROLE_THEME_ID Qt::UserRole + 7
#define ROLE_TEXT_EN Qt::UserRole + 5
#define ROLE_TEXT_RU Qt::UserRole + 6


class QuestionQueryModel : public QAbstractItemModel
{
  Q_OBJECT
  Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
  QuestionQueryModel(QObject* parent = 0);

  QHash<int, QByteArray> roleNames() const;
  QVariant data(const QModelIndex &idx, int role) const;

  Q_INVOKABLE void fromJSON(QString filePath);
  Q_INVOKABLE QString toJSON();

  Q_INVOKABLE QVariantMap get(int row);
  Q_INVOKABLE QStringList getThemesNames() const;
  void setQuestion(Question* q, int row);

public:
  Q_INVOKABLE int count() const;
  QList<Question> questions() const;
  void setQuestions(QList<Question> questions);

public slots:
  void set(int row, const QVariantMap& value);
  void create();
  void add(QVariantMap q);
//  void add(QList<Question> questionList);
  void remove(int row);
  void setTheme(const QString& theme);

signals:
  void countChanged();

public:
  QModelIndex index(int row, int column, const QModelIndex &parent) const;
  int rowCount(const QModelIndex &parent) const;
  int columnCount(const QModelIndex &parent) const;
  QModelIndex parent(const QModelIndex &child) const;

private:
  QHash<int, QByteArray> m_roles;
  QList<Question> m_questions;
  QString m_theme;
};

#endif // QUESTIONTABLEMODEL_H

