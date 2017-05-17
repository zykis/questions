import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
  id: root

  color: "#eee"

  signal addRequested
  signal cancelRequested

  QuestionItem {
    id: questionItem

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 40
  }

  Row {
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.rightMargin: 20
    spacing: 20
    height: 40

    Button {
      text: "Добавить"
      onClicked: addRequested()
      anchors.verticalCenter: parent.verticalCenter
    }

    Button {
      text: "Отмена"
      onClicked: cancelRequested()
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}
