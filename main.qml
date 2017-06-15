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
    visible: false
    onTemplateRequested: stack.push(templatePage)
  }

  TemplatePage {
    id: templatePage
    visible: false

    onAddRequested: {
      stack.pop()
      var questions = templateManager.generateQuestionsFromTemplate(q)
      console.log(questions)
      for (var qq in questions) {
        console.log(qq)
        for (var i in qq) {
          console.log("question[%1]: %2".arg(i).arg(qq[i]))
        }

        questionModel.add(questions[qq])
      }
    }
    onCancelRequested: stack.pop()
  }

  StackView {
    id: stack

    anchors.fill: parent
    initialItem: questionPage
  }
}
