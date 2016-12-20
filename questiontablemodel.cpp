#include "questiontablemodel.h"

#include <QFile>
#include <QFileInfo>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QSettings>

QuestionQueryModel::QuestionQueryModel(QObject *parent)
  : QAbstractItemModel(parent)
{
  m_roles[ROLE_ID] = "id";
  m_roles[ROLE_TEXT] = "question_text";
  m_roles[ROLE_IMAGE_NAME] = "image_name";
  m_roles[ROLE_APPROVED] = "approved";
  m_roles[ROLE_THEME] = "theme";
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
    case ROLE_THEME:
      return question.theme;
    default:
      return QVariant();
    }
  }
  else
    return QVariant();
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
  jsonFile.close();

  QJsonDocument document = QJsonDocument::fromJson(ba);
  for (auto qObj: document.array())
  {
    // stepping into question
    QJsonObject obj = qObj.toObject();
    Question q;
    QJsonObject themeObject = obj.value("theme").toObject();
    q.theme = themeObject.value("name").toString();
    q.imageName = obj.value("image_name").toString();
    q.text = obj.value("text").toString();
    q.approved = obj.value("approved").toString() == "true"? true: false;

    QJsonArray answersArr = obj.value("answers").toArray();
    for (auto aObj: answersArr)
    {
      QJsonObject aaObj = aObj.toObject();
      Answer a;
      a.text = aaObj.value("text").toString();
      a.isCorrect = aaObj.value("is_correct").toString() == "true"? true: false;

      q.answers.append(a);
    }

    m_questions.append(q);
  }

  qDebug() << QString("%1 total questions loaded").arg(m_questions.count());
  QSettings settings;
  settings.setValue("jsonFilePath", filePath);
  settings.setValue("questionsFolder", "file://" + fileInfo.absolutePath() + "/question_images/");
}

int QuestionQueryModel::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent)
  return m_questions.count();
}

QString QuestionQueryModel::toJSON()
{
  QSettings settings;
  QFileInfo fileInfo(settings.value("jsonFilePath").toString());
  QFile jsonFile(fileInfo.absoluteFilePath());
  jsonFile.open(QIODevice::WriteOnly | QIODevice::Truncate);

  // [2] Fill json
  QJsonDocument document;
  QJsonArray questionsArray;
  for (const Question& q: m_questions)
  {
    QJsonObject questionObject;
    QJsonObject themeObject;
    themeObject["name"] = q.theme;
    questionObject["theme"] = themeObject;
    questionObject["image_name"] = q.imageName;
    questionObject["text"] = q.text;
    questionObject["approved"] = q.approved? "true": "false";

    QJsonArray answersArray;
    for (const Answer& a: q.answers)
    {
      QJsonObject answerObject;
      answerObject["text"] = a.text;
      answerObject["is_correct"] = a.isCorrect? "true": "false";
      answersArray.append(answerObject);
    }
    questionObject["answers"] = answersArray;

    questionsArray.append(questionObject);
  }

  document.setArray(questionsArray);
  QByteArray ba = document.toJson();
  jsonFile.write(ba.data());
  jsonFile.close();

  return QString();
}


QVariantMap QuestionQueryModel::get(int row)
{
  QVariantMap result;

  for (auto role : m_roles.keys())
    result[QString::fromLatin1(m_roles.value(role))] = index(row, 0, QModelIndex()).data(role);

  Question q = m_questions.at(row);
  QVariantList answersList;
  for (Answer& a: q.answers)
  {
    QVariantMap aMap;
    aMap["text"] = a.text;
    aMap["is_correct"] = a.isCorrect;
    answersList.append(aMap);
  }
  result["answers"] = answersList;

  return result;
}

void QuestionQueryModel::set(int row, const QVariantMap &value)
{
  Question& q = m_questions[row];
  q.text = value.value("text").toString();
  q.approved = value.value("approved").toString() == "true"? true: false;
  q.imageName = value.value("image_name").toString();
  q.theme = value.value("theme").toString();
  q.answers.clear();

  for (int i = 0; i < value.value("answers").toList().count(); i++)
  {
    QVariantList answersList = value.value("answers").toList();
    QVariantMap answerMap = answersList[i].toMap();
    Answer a;
    a.text = answerMap.value("text").toString();
    a.isCorrect = answerMap.value("is_correct").toString() == "true"? true: false;
    q.answers.append(a);
  }

  m_questions[row] = q;
}

void QuestionQueryModel::create()
{
  Question q;
  q.approved = false;
  beginInsertRows(QModelIndex(), 0, 0);
  m_questions.prepend(q);
  endInsertRows();
}

void QuestionQueryModel::remove(int row)
{
  if (m_questions.count() > row)
  {
    beginRemoveRows(QModelIndex(), row, row);
    m_questions.removeAt(row);
    endRemoveRows();
  }
}

void QuestionQueryModel::approve(int row)
{
  if (m_questions.count() > row)
  {
    m_questions[row].approved = true;
    QModelIndex mi = createIndex(row, 0);
    emit dataChanged(mi, mi);
  }
}

void QuestionQueryModel::setTheme(const QString &theme)
{
  m_theme = theme;
}

QModelIndex QuestionQueryModel::index(int row, int column, const QModelIndex &parent) const
{
  Q_UNUSED(parent)
  return createIndex(row, column);
}

int QuestionQueryModel::columnCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent)
  return 1;
}

QModelIndex QuestionQueryModel::parent(const QModelIndex &child) const
{
  Q_UNUSED(child)
  return QModelIndex();
}

int QuestionQueryModel::count() const
{
  return m_questions.count();
}
