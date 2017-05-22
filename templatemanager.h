#ifndef TEMPLATEMANAGER_H
#define TEMPLATEMANAGER_H

// Qt
#include <QObject>
#include <QString>

// Local
#include "quesiton.h"

const char escape_characters[] = {':', '?', ' '};


class TemplateManager: public QObject
{
  Q_OBJECT

public:
  TemplateManager();
  ~TemplateManager();

public:
  QList<Question> parseTemplates(QString templatesFilePath);
//  QList<Question> generateQuestions(QList<Question> templates);
//  Q_INVOKABLE QVariantList generateQuestionsFromTemplate(Question temp);
  Q_INVOKABLE QVariantList generateQuestionsFromTemplate(QVariantMap temp);
};

#endif // TEMPLATEMANAGER_H
