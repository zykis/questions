import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

Item {
  id: root

  Rectangle {
    id: questionItem

    anchors.top: parent.top
    anchors.left: panel.right
    anchors.right: parent.right
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
      image.source = fileUrl
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
      console.log(path)
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

    delegate: Item {
      id: del
      width: parent.width
      height: 40
      property string q_text: question_text

      Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        color: "#eee"
      }

      Rectangle {
        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 12
        height: width
        radius: height / 2
        color: "#4CAF50"
        border.color: "#1B5E20"

        Text {
          anchors.fill: parent
          verticalAlignment: Text.AlignVCenter
          anchors.leftMargin: 4
          elide: Text.ElideRight
          text: del.q_text
          color: "#000"
          opacity: 0.54
        }
      }

    }
  }
}
