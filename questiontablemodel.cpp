#include "questiontablemodel.h"

#include <QFile>
#include <QFileInfo>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

QuestionQueryModel::QuestionQueryModel(QObject *parent):
  QSqlQueryModel::QSqlQueryModel(parent)
{
  m_roles[ROLE_ID] = "id";
  m_roles[ROLE_TEXT] = "question_text";
  m_roles[ROLE_IMAGE_NAME] = "image_name";
  m_roles[ROLE_APPROVED] = "approved";
}

QHash<int, QByteArray> QuestionQueryModel::roleNames() const
{
  return m_roles;
}

QVariant QuestionQueryModel::data(const QModelIndex &idx, int role) const
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
    return QSqlQueryModel::data(idx, role);
  }
}


QList<QVariantMap> QuestionQueryModel::answers(int questionRowID) const
{
  QList<QVariantMap> vml;
  for (Answer a: m_questions.at(questionRowID).answers) {
    QVariantMap vm = static_cast<QVariantMap>(a);
    vml.append(vm);
  }
  return vml;
}

void QuestionQueryModel::fromJSON(QString filePath)
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
  setQuery("SELECT * FROM questions");

  qDebug() << QString("%1 total questions loaded").arg(m_questions.count());
}

int QuestionQueryModel::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent)
  return m_questions.count();
}

QString QuestionQueryModel::toJSON()
{
  return QString();
}
