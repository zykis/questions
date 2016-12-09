import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

Window {
  visible: true
  width: 1280
  height: 800
  title: "Вопросы"

  Rectangle {
    id: questionItem

    width: parent.width
    height: 220

    color: "#ddd"

    Column {
      anchors.fill: parent
      anchors.topMargin: 24
      spacing: 10

      TextArea {
        id: questionText

        height: 60
        width: parent.width * 2 / 3
        anchors.horizontalCenter: parent.horizontalCenter

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
          }
        }

        TextField {
          anchors.top: row2.bottom
          anchors.topMargin: 8
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.leftMargin: 44
          anchors.rightMargin: 44
          placeholderText: "Путь до файла изображения"

          Button {
            id: browse
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: "Browse"
            onClicked: fileDialog.open()
          }
        }
      }
    }


  }


  Rectangle {
    id: imagePreview
    anchors.bottom: parent.bottom
    anchors.top: questionItem.bottom
    width: height * 1.777
    anchors.horizontalCenter: parent.horizontalCenter
    color: "#eee"

  }

  FileDialog {
    id: fileDialog
    folder: shortcuts.home
    title: "Изображение вопроса"
    width: 800
    height: 600
    nameFilters: [ "Image files (*.jpg *.png)" ]
  }
}
