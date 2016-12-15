import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

Item {
  id: root

  function loadQuestion(question) {

    answer1.text = question.answers[0] !== undefined? question.answers[0].text: ""
    answer2.text = question.answers[1] !== undefined? question.answers[1].text: ""
    answer3.text = question.answers[2] !== undefined? question.answers[2].text: ""
    answer4.text = question.answers[3] !== undefined? question.answers[3].text: ""

    answer1CorrectRadio.checked = question.answers[0] !== undefined? question.answers[0].is_correct? true: false: false
    answer2CorrectRadio.checked = question.answers[1] !== undefined? question.answers[1].is_correct? true: false: false
    answer3CorrectRadio.checked = question.answers[2] !== undefined? question.answers[2].is_correct? true: false: false
    answer4CorrectRadio.checked = question.answers[3] !== undefined? question.answers[3].is_correct? true: false: false

    questionText.text = question.question_text

    pathText.text = settings.questionsFolder + question.image_name
    image.source = pathText.text
  }

  function getQuestion(row) {
    var q = {}
    q.text = questionText.text
    q.image_name = pathText.text.substring(pathText.text.lastIndexOf('/') + 1)
    q.answers = []
    var a1 = { "text": answer1.text, "is_correct": answer1CorrectRadio.checked? "true": "false" }
    var a2 = { "text": answer2.text, "is_correct": answer2CorrectRadio.checked? "true": "false" }
    var a3 = { "text": answer3.text, "is_correct": answer3CorrectRadio.checked? "true": "false" }
    var a4 = { "text": answer4.text, "is_correct": answer4CorrectRadio.checked? "true": "false" }
    if (a1.text !== "")
      q.answers.push(a1)
    if (a2.text !== "")
      q.answers.push(a2)
    if (a3.text !== "")
      q.answers.push(a3)
    if (a4.text !== "")
      q.answers.push(a4)

    return q
  }

  Settings {
    id: settings
    property string jsonFilePath
    property string questionsFolder
  }

  Rectangle {
    id: questionItem

    anchors.top: parent.top
    anchors.left: panel.right
    anchors.right: parent.right
    anchors.leftMargin: 16
    height: 220

    color: "#eee"

    Column {
      anchors.fill: parent
      anchors.topMargin: 24
      spacing: 10

      TextArea {
        id: questionText

        height: 60
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8

        Text {
          anchors.bottom: questionText.top
          anchors.horizontalCenter: questionText.horizontalCenter
          anchors.margins: 4
          text: "Вопрос:"
          opacity: 0.54
        }
      }

      Item {
        id: answersItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        height: 80

        Item {
          id: row1
          height: 30
          anchors.left: parent.left
          anchors.right: parent.right

          TextField {
            id: answer1
            placeholderText: "Ответ 1"
            height: 30
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.right: parent.horizontalCenter
          }

          RadioButton {
            id: answer1CorrectRadio
            anchors.right: answer1.left
            anchors.verticalCenter: parent.verticalCenter
            exclusiveGroup: answerRadioGroup
          }

          TextField {
            id: answer2
            placeholderText: "Ответ 2"
            height: 30
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: 30
            anchors.right: parent.right
          }

          RadioButton {
            id: answer2CorrectRadio
            anchors.right: answer2.left
            anchors.verticalCenter: parent.verticalCenter
            exclusiveGroup: answerRadioGroup
          }
        }

        Item {
          id: row2
          height: 30
          anchors.top: row1.bottom
          anchors.topMargin: 4
          anchors.left: parent.left
          anchors.right: parent.right

          TextField {
            id: answer3
            placeholderText: "Ответ 3"
            height: 30
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.right: parent.horizontalCenter
          }

          RadioButton {
            id: answer3CorrectRadio
            anchors.right: answer3.left
            anchors.verticalCenter: parent.verticalCenter
            exclusiveGroup: answerRadioGroup
          }

          TextField {
            id: answer4
            placeholderText: "Ответ 4"
            height: 30
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: 30
            anchors.right: parent.right
          }

          RadioButton {
            id: answer4CorrectRadio
            anchors.right: answer4.left
            anchors.verticalCenter: parent.verticalCenter
            exclusiveGroup: answerRadioGroup
          }
        }

        TextField {
          id: pathText
          anchors.top: row2.bottom
          anchors.topMargin: 8
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.leftMargin: 44
          anchors.rightMargin: 44
          placeholderText: "Путь до файла изображения"

          onEditingFinished: {
            image.source = text
          }

          Button {
            id: browse
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: "Указать"
            onClicked: fileDialog.open()
          }
        }
      }
    }
  }

  Button {
    anchors.right: parent.right
    anchors.top: parent.top
    width: 32
    height: 32
    text: "WTF"
    onClicked: {
      jsonOpenDialog.open()
    }
  }

  Rectangle {
    id: imagePreview
    anchors.bottom: statusBar.top
    anchors.top: questionItem.bottom
    anchors.margins: 8
    width: height * 1.777
    anchors.horizontalCenter: questionItem.horizontalCenter
    color: "#ddd"

    Image {
      id: image
      anchors.fill: parent
      fillMode: Image.PreserveAspectFit
      asynchronous: true
    }
  }

  Rectangle {
    id: statusBar

    anchors.bottom: parent.bottom
    height: 40
    anchors.left: questionItem.left
    anchors.right: parent.right

    Button {
      anchors.right: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: 16
      text: "Загрузить"
      onClicked: {
        var data = getQuestion(panel.currentIndex)
        questionModel.set(panel.currentIndex, data)
        questionModel.toJSON()
      }
    }

    Button {
      anchors.left: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: 16
      text: "Очистить"
    }
  }

  FileDialog {
    id: fileDialog
    folder: shortcuts.home
    title: "Изображение вопроса"
    width: 800
    height: 600
    nameFilters: [ "Image files (*.jpg *.png)" ]
    onAccepted: {
      pathText.text = fileUrl
    }
  }

  FileDialog {
    id: jsonOpenDialog
    folder: shortcuts.home
    title: "Открыть файл с вопросами"
    width: 800
    height: 600
    nameFilters: [ "JSON files (*.json)" ]
    onAccepted: {
      var path = fileUrl.toString();
      path = path.replace(/^(file:\/{2})/,"");
      questionModel.fromJSON(path)
    }
  }

  ExclusiveGroup {
    id: answerRadioGroup
  }

  ListView {
    id: panel
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 200

    model: questionModel

    header: Rectangle {
      width: parent.width
      height: 58

      ComboBox {
        model: ["все", "лор", "соревнования", "механика"]
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 8
        anchors.topMargin: 24

        Text {
          anchors.bottom: parent.top
          anchors.margins: 4
          anchors.horizontalCenter: parent.horizontalCenter
          text: "Тема"
        }
      }
    }

    delegate: Item {
      id: del
      width: parent.width
      height: 40

      Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: "#eee"
        border.width: index === panel.currentIndex? 1: 0
        border.color: "#000"

        Text {
          id: txt
          anchors.fill: parent
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignLeft
          anchors.leftMargin: 4
          elide: Text.ElideRight
          text: question_text
          color: "#000"
          opacity: 0.54
        }
      }

      Rectangle {
        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 12
        height: width
        radius: height / 2
        color: approved? "#4CAF50": "gray"
        border.color: index === panel.currentIndex? "#000": "#1B5E20"
        border.width: index === panel.currentIndex? 1: 0
      }

      MouseArea {
        anchors.fill: parent
        onClicked: {
          //! TODO: Загрузка интерфейса из модели для последующего редактирования
          console.log(txt.text)
          loadQuestion(questionModel.get(index))
          panel.currentIndex = index
        }
      }
    }
  }
}
