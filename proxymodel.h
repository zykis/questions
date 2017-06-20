#ifndef PROXYMODEL_H
#define PROXYMODEL_H

#include <QSortFilterProxyModel>

class Question;
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
//    Q_INVOKABLE void add(QVariantMap q);
    Q_INVOKABLE void remove(int row);
    Q_INVOKABLE void approve(int row);

public slots:
    void set(int row, const QVariantMap &value);

  private:
    QString m_themeName;
    Question sourceQuestion(int row);

  signals:
    void countChanged();
};

#endif // PROXYMODEL_H
