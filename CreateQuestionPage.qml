import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

Item {
  id: root

  Settings {
    id: settings
    property string jsonFilePath
    property string questionsFolder
  }

  Component.onCompleted: {
    if (questionModel.count > 0)
      panel.currentIndex = 0
  }

  function ifImageExists(imageName) {
    var img = Image
    img.source = settings.questionsFolder + imageName
    return img.status === Image.Ready
  }

  function canApproveCurrentQuestion() {
    if (questionText.text === "") {
      return "Текст вопроса - пуст"
    }

    if (answer1.text === "" || answer2.text === "") {
      return "Должно быть минимум 2 ответа"
    }

    if (answerRadioGroup.current === null) {
      return "Не выбран правильный ответ"
    }

    if (comboBoxThemes.currentIndex === 0) {
      return "Не указана тема"
    }

//    if (image.status !== Image.Ready) {
//      return "Отсутствует изображение вопроса"
//    }

    return ""
  }

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

    if (question.theme === "lore")
      comboBoxThemes.currentIndex = 1
    else if (question.theme === "tournaments")
      comboBoxThemes.currentIndex = 2
    else if (question.theme === "mechanics")
      comboBoxThemes.currentIndex = 3
    else
      comboBoxThemes.currentIndex = 0

    if (question.image_name)
    {
      pathText.text = settings.questionsFolder + question.image_name
      image.source = pathText.text
    }
    else
    {
      pathText.text = ""
      image.source = ""
    }
  }

  function clearQuestion() {
    answer1.text = ""
    answer2.text = ""
    answer3.text = ""
    answer4.text = ""

    answer1CorrectRadio.checked = false
    answer2CorrectRadio.checked = false
    answer3CorrectRadio.checked = false
    answer4CorrectRadio.checked = false

    questionText.text = ""

    comboBoxThemes.currentIndex = 0

    pathText.text = ""
    image.source = ""
  }

  function createQuestion() {
    questionModel.create()
    panel.currentIndex = -1
    panel.currentIndex = 0
  }

  function getQuestion(row) {
    var q = {}
    q.text = questionText.text
    q.image_name = pathText.text.substring(pathText.text.lastIndexOf('/') + 1)
    q.answers = []
    q.approved = questionModel.get(row).approved
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

    switch (comboBoxThemes.currentIndex)
    {
    case 0:
      q.theme = ""
      break;
    case 1:
      q.theme = "lore"
      break;
    case 2:
      q.theme = "tournaments"
      break;
    case 3:
      q.theme = "mechanics"
      break;
    default:
      q.theme = ""
    }

    return q
  }

  Rectangle {
    id: questionItem

    anchors.top: parent.top
    anchors.left: scrollView.right
    anchors.right: parent.right
    anchors.leftMargin: 16
    height: 240

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
          opacity: 0.86
          color: "#fff"
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
            activeFocusOnTab: false
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
            activeFocusOnTab: false
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
            activeFocusOnTab: false
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
            activeFocusOnTab: false
          }
        }

        ComboBox {
          id: comboBoxThemes

          anchors.top: row2.bottom
          anchors.topMargin: 8
          anchors.horizontalCenter: parent.horizontalCenter
          width: 250
          model: ["Не указана", "Лор", "Турниры", "Механика"]

          Text {
            anchors.right: parent.left
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: "Тема:"
            opacity: 0.86
            color: "#fff"
          }
        }

        TextField {
          id: pathText
          anchors.top: comboBoxThemes.bottom
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
      visible: false
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
      text: "Утвердить"
      onClicked: {
        if (panel.currentIndex >= 0) {
          var str = canApproveCurrentQuestion()
          if (str !== "") {
            messageDialog.text = str
            messageDialog.open()
          }
          else {
            questionModel.approve(panel.currentIndex)
          }
        }
      }
    }

    Button {
      anchors.left: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: 16
      text: "Удалить"
      onClicked: {
        if (panel.currentIndex >= 0) {
          questionModel.remove(panel.currentIndex)
          panel.currentIndex = -1
          if (questionModel.count > 0)
            panel.currentIndex = 0
        }
      }
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

  ScrollView {
    id: scrollView

    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 320

    ListView {
      id: panel

      anchors.fill: parent
      anchors.rightMargin: 0

      model: questionModel
      currentIndex: -1

      onCurrentIndexChanged: {
        if (currentIndex >= 0)
          loadQuestion(questionModel.get(currentIndex))
        else
          clearQuestion()
      }

      header: Rectangle {
        width: parent.width
        height: 88

        ComboBox {
          id: themesComboBox

          model: ["все", "лор", "соревнования", "механика"]
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.margins: 8
          anchors.topMargin: 24
          onCurrentIndexChanged: {
            if (currentIndex == -1)
              return
            console.log(currentIndex)
            if (currentIndex === 0)
            {
              questionModel.setTheme("");
            }
            else if (currentIndex === 1)
            {
              questionModel.setTheme("lore");
            }
            else if (currentIndex === 2)
            {
             questionModel.setTheme("tournaments");
            }
            else if (currentIndex === 3)
            {
              questionModel.setTheme("mechanics");
            }
          }

          Text {
            anchors.bottom: parent.top
            anchors.margins: 4
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Тема"
            opacity: 0.54
            color: "#fff"
          }
        }

        Button {
          id: saveButton

          anchors.right: parent.horizontalCenter
          anchors.top: themesComboBox.bottom
          anchors.topMargin: 5
          anchors.rightMargin: 4
          text: "Сохранить"
          onClicked: {
            var data = getQuestion(panel.currentIndex)
            questionModel.set(panel.currentIndex, data)
            questionModel.toJSON()
          }
        }

        Button {
          anchors.top: themesComboBox.bottom
          anchors.topMargin: 5
          anchors.leftMargin: 4
          anchors.left: parent.horizontalCenter
          text: "Новый"
          onClicked: createQuestion()
        }
      }

      delegate: Item {
        id: del
        width: parent.width
        height: index == panel.currentIndex? 80: 40
        Behavior on height { NumberAnimation { easing.type: Easing.InOutQuad } }

        Rectangle {
          anchors.fill: parent
          anchors.bottomMargin: 1
          color: approved? "#3F51B5": "#BF360C"
          border.width: index === panel.currentIndex? 1: 0
          border.color: "#000"

          Image {
            id: invisibleImage
            source: image_name !== ""? settings.questionsFolder + image_name: ""
            visible: false
          }

          Image {
            id: iconExists
            source: invisibleImage.status === Image.Ready? "qrc:///icon.svg": "qrc:///icon_black.svg"
            visible: image_name
            sourceSize.width: 36
            sourceSize.height: 36
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: visible? 36: 0
          }

          Text {
            id: txt
            anchors.left: iconExists.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            anchors.leftMargin: 4
            anchors.rightMargin: 8
            elide: Text.ElideRight
            text: "<b>" + (questionModel.count - index) + ".</b> " + question_text
            color: "#fff"
            opacity: 0.86
          }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            var data = getQuestion(panel.currentIndex)
            questionModel.set(panel.currentIndex, data)
            panel.currentIndex = index
          }
        }
      }
    }
  }

  MessageDialog {
    id: messageDialog
    title: "Невозможно утвердить вопрос"
  }
}
