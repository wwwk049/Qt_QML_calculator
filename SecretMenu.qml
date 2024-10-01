import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: secretMenu
    anchors.fill: parent
    visible: false  // По умолчанию невидимо

    Rectangle {
        anchors.fill: parent
        color: "#00F79C"

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Секретное меню"
                color: appTheme.colorTheme_1_5
                font.pixelSize: 40
            }

            Button {
                text: "Назад"
                onClicked: {
                    secretMenu.visible = false  // Скрыть секретное меню
                    mainContent.visible = true  // Показать содержимое главного окна
                }
            }
        }
    }
}

