import QtQuick 2.0
import QtQuick.Controls 1.4
//from createQuestionPage import

Item {
  id: root

//  color: "#eee"

  signal addRequested (var q)
  signal cancelRequested ()

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

      model: templateModel
      currentIndex: -1

      onCurrentIndexChanged: {
        if (currentIndex >= 0) {
          var q = templateModel.get(currentIndex)
          questionItem.updateUIFromQuestion(q)
          forceActiveFocus()
        }
        else {
          questionItem.clearQuestion()
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
              templateModel.remove(panel.currentIndex)
              panel.currentIndex = -1
              if (templateModel.count > 0)
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
            text: "<b>" + (templateModel.count - index) + ".</b> " + text_en
            color: approved? "#fff" : "#212121"
            opacity: 0.86
          }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: {
//            var data = updateQuestionFromUI(panel.currentIndex)
//            templateModel.set(panel.currentIndex, data)
            panel.currentIndex = index
//            var q = templateModel.get(index)
//            questionItem.updateUIFromQuestion(q)
          }
        }
      }
    }
  }

  QuestionItem {
    id: questionItem

    anchors.top: parent.top
    anchors.left: scrollView.right
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
      onClicked: addRequested(templateModel.get(panel.currentIndex))
      anchors.verticalCenter: parent.verticalCenter
    }

    Button {
      text: "Отмена"
      onClicked: cancelRequested()
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}
