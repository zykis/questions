#include "questiontablemodel.h"

#include <QFile>
#include <QFileInfo>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

QuestionTableModel::QuestionTableModel(QObject *parent):
  QSqlTableModel::QSqlTableModel(parent)
{
  m_roles.insert(ROLE_ID, "id");
  m_roles.insert(ROLE_TEXT, "question_text");
  m_roles.insert(ROLE_IMAGE_NAME, "image_name");
  m_roles.insert(ROLE_APPROVED, "approved");
}

QHash<int, QByteArray> QuestionTableModel::roleNames() const
{
  return m_roles;
}

QVariant QuestionTableModel::data(const QModelIndex &idx, int role) const
{
  if (role > Qt::UserRole)
  {
    const Question& question = m_questions.at(idx.row());
    switch (role) {
    case ROLE_ID:
      return question.id;
    case ROLE_TEXT:
      return question.text;
    case ROLE_IMAGE_NAME:
    return question.imageName;
    case ROLE_APPROVED:
    return question.approved;
    default:
      return QVariant();
    }
  }
  else
  {
    return QSqlTableModel::data(idx, role);
  }
}


QList<QVariantMap> QuestionTableModel::answers(int questionRowID) const
{
  QList<QVariantMap> vml;
  for (Answer a: m_questions.at(questionRowID).answers) {
    QVariantMap vm = static_cast<QVariantMap>(a);
    vml.append(vm);
  }
  return vml;
}

void QuestionTableModel::fromJSON(QString filePath)
{
  m_questions.clear();

  QFileInfo fileInfo(filePath);
  QFile jsonFile(fileInfo.absoluteFilePath());
  jsonFile.open(QIODevice::ReadOnly);
  QByteArray ba = jsonFile.readAll();

  QJsonDocument document = QJsonDocument::fromJson(ba);
  for (auto qObj: document.array())
  {
    // stepping into question
    QJsonObject obj = qObj.toObject();
    Question q;
    q.theme = obj.value("theme").toString();
    q.imageName = obj.value("image").toString();
    q.text = obj.value("question").toString();

    QJsonArray answersArr = obj.value("answers").toArray();
    for (auto aObj: answersArr)
    {
      Answer a;
      a.text = aObj.toString();

      q.answers.append(a);
    }

    int rightIndex = obj.value("correct_answer_index").toInt();
    q.answers[rightIndex - 1].isCorrect = true;

    m_questions.append(q);
  }
  setTable("questions");
  select();

  qDebug() << QString("%1 total questions loaded").arg(m_questions.count());
}

int QuestionTableModel::rowCount(const QModelIndex &parent) const
{
  return m_questions.count();
}

QString QuestionTableModel::toJSON()
{
  return QString();
}
