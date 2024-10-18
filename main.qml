import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    /*** Property **********************************************/
    width: appTheme.appWidth
    height: appTheme.appHeight
    visible: true
    title: qsTr(appTheme.appTitle)

    MyAppTheme {
        id: appTheme
    }

    SecretMenu {
        id: secretMenu
    }
    FontLoader {
        id: openSans
        source: "qrc:/Open Sans/OpenSans.ttf"
    }
    /*** Layout ************************************************/

    Item{// удерживает все элементы
        id: mainContent
        anchors.fill: parent

        Rectangle{// задний фон
            anchors.fill: parent

            color: appTheme.colorTeal
        }

        // отступ

        //.139375 + .046875 = .18625

        // элемент для отображения ввода
        MyDispInput {
            id: dispInput
            width: parent.width
            height: parent.height * .18625
            anchors{
                top: parent.top
                topMargin: parent.height * .000001
                horizontalCenter: parent.horizontalCenter

            }
        }
        // элемент для отображения вывода
        MyDispOutput {
            id: dispOutput
            width: parent.width
            height: parent.height * .09375
            anchors{
                top: parent.top
                topMargin: parent.height * .18625 //контролирует отступ от верха

            }
        }
        // область отвечающая за кнопки
        MyCalcButtons {
            id: calcButtons
            width: parent.width * .8666 // 360-312=48 1-48/360
            height: parent.height * .61875 // 396/640
            anchors{//привязка (bottom - нижнего края элемента к другому элементу)
                bottom: parent.bottom
                bottomMargin: parent.height * .07 // 640-180-396 = 64 ~ 40/640
                horizontalCenter: parent.horizontalCenter
                }
        }


    }
}

