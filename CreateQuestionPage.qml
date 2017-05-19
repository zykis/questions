import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

Item {
  id: root

  signal templateRequested

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
    if (questionItem.questionText.text === "") {
      return "Текст вопроса - пуст"
    }

    if (questionItem.answer1.text === "" || answer2.text === "") {
      return "Должно быть минимум 2 ответа"
    }

    if (questionItem.answerRadioGroup.current === null) {
      return "Не выбран правильный ответ"
    }

    if (questionItem.combo_themes.currentIndex === 0) {
      return "Не указана тема"
    }

    return ""
  }

  function updateUIFromQuestion(question) {
    // 0 - EN, 1 - RU
    var lang = questionItem.combo_languages.currentIndex

//    console.log('\n')
//    console.log("language ind: " + lang)
//    for (var i in question)
//    {
//      console.log("q[%1] = %2".arg(i).arg(question[i]))
//    }

//    for (var j = 0; j < question.answers.length; j++)
//    {
//      console.log("%1 %2".arg(j).arg(question['answers'][j].text_en))
//    }


    switch (lang) {
      case 0: // EN
        questionItem.questionText.text = question.text_en
        questionItem.answer1.text = question.answers[0] !== undefined? question.answers[0].text_en: ""
        questionItem.answer2.text = question.answers[1] !== undefined? question.answers[1].text_en: ""
        questionItem.answer3.text = question.answers[2] !== undefined? question.answers[2].text_en: ""
        questionItem.answer4.text = question.answers[3] !== undefined? question.answers[3].text_en: ""
        break;

      case 1:
        questionItem.questionText.text = question.text_ru
        questionItem.answer1.text = question.answers[0] !== undefined? question.answers[0].text_ru: ""
        questionItem.answer2.text = question.answers[1] !== undefined? question.answers[1].text_ru: ""
        questionItem.answer3.text = question.answers[2] !== undefined? question.answers[2].text_ru: ""
        questionItem.answer4.text = question.answers[3] !== undefined? question.answers[3].text_ru: ""
        break;
    }

    questionItem.answer1.placeholderText = question.answers[0]? question.answers[0].text_en === "" ? "Ответ 1" : question.answers[0].text_en : ""
    questionItem.answer2.placeholderText = question.answers[1]? question.answers[1].text_en === "" ? "Ответ 2" : question.answers[1].text_en : ""
    questionItem.answer3.placeholderText = question.answers[2]? question.answers[2].text_en === "" ? "Ответ 3" : question.answers[2].text_en : ""
    questionItem.answer4.placeholderText = question.answers[3]? question.answers[3].text_en === "" ? "Ответ 4" : question.answers[3].text_en : ""

    questionItem.answer1CorrectRadio.checked = question.answers[0] !== undefined? question.answers[0].is_correct? true: false: false
    questionItem.answer2CorrectRadio.checked = question.answers[1] !== undefined? question.answers[1].is_correct? true: false: false
    questionItem.answer3CorrectRadio.checked = question.answers[2] !== undefined? question.answers[2].is_correct? true: false: false
    questionItem.answer4CorrectRadio.checked = question.answers[3] !== undefined? question.answers[3].is_correct? true: false: false

    if (question.theme.text_en === "heroes / items")
      questionItem.combo_themes.currentIndex = 1
    else if (question.theme.text_en === "tournaments")
      questionItem.combo_themes.currentIndex = 2
    else if (question.theme.text_en === "mechanics")
      questionItem.combo_themes.currentIndex = 3
    else
      questionItem.combo_themes.currentIndex = 0

    if (question.image_name)
    {
      pathText.text = settings.questionsFolder + question.image_name
      image.source = pathText.text
    }
    else
    {
      questionItem.pathText.text = ""
      image.source = ""
    }
  }

  function clearQuestion() {
    questionItem.answer1.text = ""
    questionItem.answer2.text = ""
    questionItem.answer3.text = ""
    questionItem.answer4.text = ""

    questionItem.answer1CorrectRadio.checked = false
    questionItem.answer2CorrectRadio.checked = false
    questionItem.answer3CorrectRadio.checked = false
    questionItem.answer4CorrectRadio.checked = false

    questionItem.questionText.text = ""

    questionItem.combo_themes.currentIndex = 0
    questionItem.combo_languages.currentIndex = 0

    questionItem.pathText.text = ""
    image.source = ""
  }

  function createQuestion() {
    questionModel.create()
    panel.currentIndex = -1
    panel.currentIndex = 0
  }

  function createQuestionFromTemplate() {
    root.templateRequested()
  }

  function updateQuestionFromUI(row) {
    var q = proxyModel.get(row)
//    for (var i in q)
//    {
//      console.log("q[%1] = %2".arg(i).arg(q[i]))
//    }

    // 0 - EN, 1 - RU
    var lang = questionItem.combo_languages.oldIndex
    var a1 = q.answers[0];
    var a2 = q.answers[1];
    var a3 = q.answers[2];
    var a4 = q.answers[3];

    switch(lang) {
      case 0: // EN
        if (questionItem.questionText.text !== "")
          q.text_en = questionItem.questionText.text

        if ((a1) && (questionItem.answer1.text !== ""))
          a1.text_en = questionItem.answer1.text
        if ((a2) && (questionItem.answer2.text !== ""))
          a2.text_en = questionItem.answer2.text
        if ((a3) && (questionItem.answer3.text !== ""))
          a3.text_en = questionItem.answer3.text
        if ((a4) && (questionItem.answer4.text !== ""))
          a4.text_en = questionItem.answer4.text
        break;

      case 1: // RU
        if (questionItem.questionText.text !== "")
          q.text_ru = questionItem.questionText.text

        if ((a1) && (questionItem.answer1.text !== ""))
          a1.text_ru = questionItem.answer1.text
        if ((a2) && (questionItem.answer2.text !== ""))
          a2.text_ru = questionItem.answer2.text
        if ((a3) && (questionItem.answer3.text !== ""))
          a3.text_ru = questionItem.answer3.text
        if ((a4) && (questionItem.answer4.text !== ""))
          a4.text_ru = questionItem.answer4.text
        break;
    }

    if (a1)
      a1.is_correct = questionItem.answer1CorrectRadio.checked? true: false
    if (a2)
      a2.is_correct = questionItem.answer2CorrectRadio.checked? true: false
    if (a3)
      a3.is_correct = questionItem.answer3CorrectRadio.checked? true: false
    if (a4)
      a4.is_correct = questionItem.answer4CorrectRadio.checked? true: false

    q.answers = []
    if (a1)
      q.answers.push(a1)
    if (a2)
      q.answers.push(a2)
    if (a3)
      q.answers.push(a3)
    if (a4)
      q.answers.push(a4)

    q.approved = proxyModel.get(row).approved
    q.image_name = questionItem.pathText.text.substring(questionItem.pathText.text.lastIndexOf('/') + 1)
    switch (questionItem.combo_themes.currentIndex)
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

    proxyModel.set(row, q)
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
          var t = questionModel.getThemesNames()[currentIndex - 1]
          proxyModel.setThemeName(t);
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

  QuestionItem {
    id: questionItem
    anchors.top: toolbar.bottom
    anchors.left: scrollView.right
    anchors.right: parent.right
    anchors.leftMargin: 16
    height: 240
    color: "#eee"

    onLanguageComboIndexChanged: {
      updateQuestionFromUI(panel.currentIndex)
      updateUIFromQuestion(proxyModel.get(panel.currentIndex))
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

      model: proxyModel
      currentIndex: -1

      onCurrentIndexChanged: {
        if (currentIndex >= 0) {
          updateUIFromQuestion(proxyModel.get(currentIndex))
          forceActiveFocus()
        }
        else {
          clearQuestion()
        }
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
            text: "<b>" + (proxyModel.count - index) + ".</b> " + text_en
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
