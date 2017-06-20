#include "proxymodel.h"
#include "quesiton.h"
#include "questiontablemodel.h"

#include <QModelIndex>


ProxyModel::ProxyModel(QObject *parent) :
  QSortFilterProxyModel(parent)
{}

ProxyModel::~ProxyModel()
{}

void ProxyModel::setThemeName(QString themeName)
{
  if (themeName.toLower() == "all themes")
    m_themeName = "";
  else
    m_themeName = themeName.toLower();
  invalidateFilter();
}

bool ProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
  Q_UNUSED(source_parent);
  QModelIndex mi = createIndex(source_row, 0);
  QVariant themeName = sourceModel()->data(mi, ROLE_THEME_NAME);

  if (m_themeName == "")
    return true;

  if (m_themeName == themeName)
    return true;
  else
    return false;
}

int ProxyModel::count() const
{
  return rowCount();
}

QVariantMap ProxyModel::get(int row) const
{
  QVariantMap result;
  QuestionQueryModel* src = qobject_cast<QuestionQueryModel*>(sourceModel());
  QList<Question> questions = src->questions();
  if (questions.count() == 0)
    return result;

  QModelIndex miProxy = index(row, 0);
  QModelIndex miSource = mapToSource(miProxy);
  int sourceIndex = miSource.row();
  if (sourceIndex == -1)
    return result;


  Question q = questions.at(sourceIndex);
  result = (QVariantMap)q;
  return result;
}

void ProxyModel::set(int row, const QVariantMap &value)
{
  if (row < 0)
    return;

  QuestionQueryModel* src = qobject_cast<QuestionQueryModel*>(sourceModel());
  QList<Question> questions = src->questions();

  QModelIndex miProxy = index(row, 0);
  QModelIndex miSource = mapToSource(miProxy);
  int sourceIndex = miSource.row();
  Question q = questions.at(sourceIndex);

  q.textEn = value.value("text_en").toString();
  q.textRu = value.value("text_ru").toString();
  q.approved = value.value("approved").toString() == "true"? true: false;
  q.imageName = value.value("image_name").toString();
  q.theme.textEn = value.value("theme").toString();
  q.answers.clear();

  QList<QVariant> rawAnswers = value.value("answers").toList();
  QList<QVariantMap> answers;
  for (QVariant v: rawAnswers) {
    answers.append(v.toMap());
  }

  for (QVariantMap answer: answers)
  {
    Answer a;
    a.textEn = answer["text_en"].toString();
    a.textRu = answer["text_ru"].toString();
    a.isCorrect = answer["is_correct"].toString() == "true"? true: false;

    q.answers.append(a);
  }

  src->setQuestion(&q, sourceIndex);

//  QModelIndex mi = index(row, 0);
  emit dataChanged(miProxy, miProxy);
}

void ProxyModel::remove(int row)
{
  if (row < 0)
    return;

  QuestionQueryModel* src = qobject_cast<QuestionQueryModel*>(sourceModel());
  QList<Question> questions = src->questions();

  if (questions.count() > row)
  {
    beginRemoveRows(QModelIndex(), 0, row);
    questions.removeAt(row);
    src->setQuestions(questions);
    endRemoveRows();
  }

}

Question ProxyModel::sourceQuestion(int row)
{
  if (row < 0)
    return QVariantMap();

  QuestionQueryModel* src = qobject_cast<QuestionQueryModel*>(sourceModel());
  QList<Question> questions = src->questions();
  QModelIndex miProxy = index(row, 0);
  QModelIndex miSource = mapToSource(miProxy);
  int sourceIndex = miSource.row();
  Question q = questions.at(sourceIndex);
  return q;
}

void ProxyModel::approve(int row)
{
  if (row < 0)
    return;

  QuestionQueryModel* src = qobject_cast<QuestionQueryModel*>(sourceModel());
  QList<Question> questions = src->questions();
  QModelIndex miProxy = index(row, 0);
  QModelIndex miSource = mapToSource(miProxy);
  int sourceIndex = miSource.row();
  Question q = questions[sourceIndex];
  q.approved = true;
  src->setQuestion(&q, sourceIndex);
}
