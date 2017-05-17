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
  QVariant themeName = sourceModel()->data(mi, ROLE_THEME);

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
