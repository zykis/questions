#ifndef PROXYMODEL_H
#define PROXYMODEL_H

#include <QSortFilterProxyModel>


class ProxyModel: public QSortFilterProxyModel
{
  Q_OBJECT

    Q_PROPERTY(int count READ count NOTIFY countChanged)
  public:
    ProxyModel(QObject* parent = nullptr);
    virtual ~ProxyModel();

    Q_INVOKABLE void setThemeName(QString themeName);
    Q_INVOKABLE int count() const;

    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const;

  private:
    QString m_themeName;

  signals:
    void countChanged();
};

#endif // PROXYMODEL_H
