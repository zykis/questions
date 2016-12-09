#include "questiontablemodel.h"

QuestionTableModel::QuestionTableModel()
{
  m_roles.insert(ROLE_ID, "id");
  m_roles.insert(ROLE_TEXT, "text");
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
