import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
  id: questionItem

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
