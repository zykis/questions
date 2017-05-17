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

    return ""
  }

  function updateUIFromQuestion(question) {

    // 0 - EN, 1 - RU
    var lang = comboBoxLanguage.currentIndex
    console.log("LANG: " + lang)
    console.log("question.text_en = " + question.text_en)
    console.log("question.text_ru = " + question.text_ru)
    switch (lang) {
      case 0: // EN
        questionText.text = question.text_en
        answer1.text = question.answers[0] !== undefined? question.answers[0].text_en: ""
        answer2.text = question.answers[1] !== undefined? question.answers[1].text_en: ""
        answer3.text = question.answers[2] !== undefined? question.answers[2].text_en: ""
        answer4.text = question.answers[3] !== undefined? question.answers[3].text_en: ""
        break;

      case 1:
        questionText.text = question.text_ru
        answer1.text = question.answers[0] !== undefined? question.answers[0].text_ru: ""
        answer2.text = question.answers[1] !== undefined? question.answers[1].text_ru: ""
        answer3.text = question.answers[2] !== undefined? question.answers[2].text_ru: ""
        answer4.text = question.answers[3] !== undefined? question.answers[3].text_ru: ""
        break;
    }

    answer1.placeholderText = question.answers[0]? question.answers[0].text_en === "" ? "Ответ 1" : question.answers[0].text_en : ""
    answer2.placeholderText = question.answers[1]? question.answers[1].text_en === "" ? "Ответ 2" : question.answers[1].text_en : ""
    answer3.placeholderText = question.answers[2]? question.answers[2].text_en === "" ? "Ответ 3" : question.answers[2].text_en : ""
    answer4.placeholderText = question.answers[3]? question.answers[3].text_en === "" ? "Ответ 4" : question.answers[3].text_en : ""

    answer1CorrectRadio.checked = question.answers[0] !== undefined? question.answers[0].is_correct? true: false: false
    answer2CorrectRadio.checked = question.answers[1] !== undefined? question.answers[1].is_correct? true: false: false
    answer3CorrectRadio.checked = question.answers[2] !== undefined? question.answers[2].is_correct? true: false: false
    answer4CorrectRadio.checked = question.answers[3] !== undefined? question.answers[3].is_correct? true: false: false

    if (question.theme === "heroes / items")
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
    comboBoxLanguage.currentIndex = 0

    pathText.text = ""
    image.source = ""
  }

  function createQuestion() {
    questionModel.create()
    panel.currentIndex = -1
    panel.currentIndex = 0
  }

  function createQuestionFromTemplate() {

  }

  function updateQuestionFromUI(row) {
    var q = questionModel.get(row)
    // 0 - EN, 1 - RU
    var lang = comboBoxLanguage.oldIndex
    var a1 = q.answers[0];
    var a2 = q.answers[1];
    var a3 = q.answers[2];
    var a4 = q.answers[3];

    switch(lang) {
      case 0: // EN
        if (questionText.text !== "")
          q.text_en = questionText.text

        if (answer1.text !== "")
          a1.text_en = answer1.text
        if (answer2.text !== "")
          a2.text_en = answer2.text
        if (answer3.text !== "")
          a3.text_en = answer3.text
        if (answer4.text !== "")
          a4.text_en = answer4.text
        break;

      case 1: // RU
        if (questionText.text !== "")
          q.text_ru = questionText.text

        if (answer1.text !== "")
          a1.text_ru = answer1.text
        if (answer2.text !== "")
          a2.text_ru = answer2.text
        if (answer3.text !== "")
          a3.text_ru = answer3.text
        if (answer4.text !== "")
          a4.text_ru = answer4.text
        break;
    }

    if (a1)
      a1.is_correct = answer1CorrectRadio.checked? true: false
    if (a2)
      a2.is_correct = answer2CorrectRadio.checked? true: false
    if (a3)
      a3.is_correct = answer3CorrectRadio.checked? true: false
    if (a4)
      a4.is_correct = answer4CorrectRadio.checked? true: false
    q.answers = []
    if (a1)
      q.answers.push(a1)
    if (a2)
      q.answers.push(a2)
    if (a3)
      q.answers.push(a3)
    if (a4)
      q.answers.push(a4)
    q.approved = questionModel.get(row).approved
    q.image_name = pathText.text.substring(pathText.text.lastIndexOf('/') + 1)
    switch (comboBoxThemes.currentIndex)
    {
    case 0:
      break;
    case 1:
      q.theme = "heroes / items"
      break;
    case 2:
      q.theme = "tournaments"
      break;
    case 3:
      q.theme = "mechanics"
      break;
    default:
      break;
    }

    questionModel.set(row, q)
    return q
  }

  Rectangle {
    id: toolbar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 64

    Row {
      id: scrollViewToolbar

      anchors.left: parent.left
      anchors.leftMargin: 8
      width: scrollView.width
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      ComboBox {
        id: themesComboBox
        width: 140

        Component.onCompleted: {
          var m = []
          m.push("All themes")
          for (var i in questionModel.getThemesNames()) {
            m.push(questionModel.getThemesNames()[i])
          }
          themesComboBox.model = m
        }

        onCurrentIndexChanged: {
          if (currentIndex == -1)
            return
          if (currentIndex === 0)
          {
            questionModel.setTheme("");
          }
          else
          {
            var t = questionModel.getThemesNames()[currentIndex + 1]
            questionModel.setTheme(t);
          }
        }

        Text {
          anchors.bottom: parent.top
          anchors.margins: 4
          text: "Тема"
          opacity: 0.54
          color: "#fff"
        }
      }

      Button {
        text: "Новый"
        onClicked: createQuestion()
      }

      Button {
        text: "Из шаблона"
        onClicked: createQuestionFromTemplate()
      }
    }

    Row {
      id: commonToolbar

      anchors.left: scrollViewToolbar.right
      anchors.leftMargin: 8
      anchors.right: parent.right
      anchors.rightMargin: 8
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      Button {
        id: saveButton
        text: "Сохранить"
        onClicked: {
          updateQuestionFromUI(panel.currentIndex)
          questionModel.toJSON()
        }
      }

      Button {
        text: "Загрузить"
        onClicked: {
          jsonOpenDialog.open()
        }
      }
    }
  }

  Rectangle {
    id: questionItem

    anchors.top: toolbar.bottom
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
          anchors.right: parent.horizontalCenter
          anchors.rightMargin: 8
          width: 180
          model: ["Не указана", "Герои / Предметы", "Турниры", "Механика"]

          Text {
            anchors.right: parent.left
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: "Тема:"
            opacity: 0.86
            color: "#fff"
          }
        }

        ComboBox {
          id: comboBoxLanguage

          anchors.top: row2.bottom
          anchors.topMargin: 8
          anchors.left: parent.horizontalCenter
          anchors.leftMargin: 48
          width: 180
          model: ["Английский", "Русский"]
          property int oldIndex: 0

          Text {
            anchors.right: parent.left
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: "Язык:"
            opacity: 0.86
            color: "#fff"
          }

          signal langageChanged()

          onCurrentIndexChanged: {
            updateQuestionFromUI(panel.currentIndex)
            updateUIFromQuestion(questionModel.get(panel.currentIndex))
            oldIndex = currentIndex
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
      panel.model = []
      panel.model = questionModel
    }
  }

  ExclusiveGroup {
    id: answerRadioGroup
  }

  ScrollView {
    id: scrollView

    anchors.left: parent.left
    anchors.top: toolbar.bottom
    anchors.bottom: parent.bottom
    width: 320

    ListView {
      id: panel

      anchors.fill: parent
      anchors.rightMargin: 0

      model: questionModel
      currentIndex: -1

      onCurrentIndexChanged: {
        if (currentIndex >= 0) {
          updateUIFromQuestion(questionModel.get(currentIndex))
          forceActiveFocus()
        }
        else
          clearQuestion()
      }

      delegate: FocusScope {
        id: del
        width: parent.width
        height: 30

        Rectangle {
          focus: true

          anchors.fill: parent
          anchors.bottomMargin: 1
          color:  approved? "#00897B" : "#F5F5F5"
          border.width: index === panel.currentIndex? 1: 0
          border.color: "#000"

          Rectangle {
            anchors.fill: parent
            color: Qt.darker(parent.color, 1.2)
            visible: index === panel.currentIndex
          }

          Keys.onDeletePressed: {
            if (panel.currentIndex >= 0) {
              questionModel.remove(panel.currentIndex)
              panel.currentIndex = -1
              if (questionModel.count > 0)
                panel.currentIndex = 0
            }
          }

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
            text: "<b>" + (questionModel.count - index) + ".</b> " + text_en
            color: approved? "#fff" : "#212121"
            opacity: 0.86
          }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            var data = updateQuestionFromUI(panel.currentIndex)
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
