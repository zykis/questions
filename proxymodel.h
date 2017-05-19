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

    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const;
//    QModelIndex mapFromSource(const QModelIndex &sourceIndex) const;
//    QModelIndex mapToSource(const QModelIndex &proxyIndex) const;

    Q_INVOKABLE void setThemeName(QString themeName);
    Q_INVOKABLE int count() const;
    Q_INVOKABLE QVariantMap get(int row) const;

  private:
    QString m_themeName;

  signals:
    void countChanged();
};

#endif // PROXYMODEL_H
