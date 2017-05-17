import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
  visible: true
  width: 1280
  height: 800
  title: "Вопросы"

  CreateQuestionPage {
    id: questionPage
    onTemplateRequested: stack.push(templatePage)
  }

  TemplatePage {
    id: templatePage

    onAddRequested: stack.pop()
    onCancelRequested: stack.pop()
  }

  StackView {
    id: stack

    anchors.fill: parent
    initialItem: questionPage
  }
}
