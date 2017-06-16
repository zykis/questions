import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
  id: questionItem

  function updateUIFromQuestion(question) {
    // 0 - EN, 1 - RU
    var lang = questionItem.combo_languages.currentIndex

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

    console.log("updateUIFromQuestion")
    console.log("question.answers[0]: ", question.answers[0])
    console.log("question.answers[1]: ", question.answers[1])
    console.log("question.answers[2]: ", question.answers[2])
    console.log("question.answers[3]: ", question.answers[3])
    console.log("question.answers[0].is_correct: ", question.answers[0].is_correct)
    console.log("question.answers[1].is_correct: ", question.answers[1].is_correct)
    console.log("question.answers[2].is_correct: ", question.answers[2].is_correct)
    console.log("question.answers[3].is_correct: ", question.answers[3].is_correct)
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
//      image.source = pathText.text
    }
    else
    {
      questionItem.pathText.text = ""
//      image.source = ""
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

  property alias questionText: questionText
  property alias answer1: answer1
  property alias answer2: answer2
  property alias answer3: answer3
  property alias answer4: answer4
  property alias answer1CorrectRadio: answer1CorrectRadio
  property alias answer2CorrectRadio: answer2CorrectRadio
  property alias answer3CorrectRadio: answer3CorrectRadio
  property alias answer4CorrectRadio: answer4CorrectRadio
  property alias combo_themes: comboBoxThemes
  property alias combo_languages: comboBoxLanguage
  property alias pathText: pathText

  signal languageComboIndexChanged(var i)

  ExclusiveGroup {
    id: answerRadioGroup
  }

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

        Component.onCompleted: {
          var m = []
          m.push("All themes")
          for (var i in questionModel.getThemesNames()) {
            m.push(questionModel.getThemesNames()[i])
          }
          comboBoxThemes.model = m
        }

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
        currentIndex: 1
        property int oldIndex: currentIndex

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
          languageComboIndexChanged(currentIndex)
//          updateQuestionFromUI(panel.currentIndex)
//          updateUIFromQuestion(questionModel.get(panel.currentIndex))
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
