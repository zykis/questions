#ifndef QUESTIONTABLEMODEL_H
#define QUESTIONTABLEMODEL_H

#include <QSqlTableModel>

const int ROLE_ID = Qt::UserRole + 1;
const int ROLE_TEXT = Qt::UserRole + 2;
const int ROLE_IMAGE_NAME = Qt::UserRole + 3;
const int ROLE_APPROVED = Qt::UserRole + 4;

class QuestionTableModel : public QSqlTableModel
{
public:
  QuestionTableModel();


  struct Answer {
    int id;
    QString text;
    bool isCorrect;

    operator QVariantMap() const {
      QVariantMap vm;
      vm.insert("text", text);
      vm.insert("isCorrect", isCorrect);
      return vm;
    }
  };

  struct Question
  {
    int id;
    QString text;
    QString imageName;
    bool approved;
    QList<Answer> answers;
  };

  QHash<int, QByteArray> roleNames() const;
  QVariant data(const QModelIndex &idx, int role) const;

  Q_INVOKABLE QList<QVariantMap> answers(int questionRowID) const;

  void fromJSON(QString filePath);
  QString toJSON();

private:
  QHash<int, QByteArray> m_roles;
  QList<Question> m_questions;
};

#endif // QUESTIONTABLEMODEL_H

