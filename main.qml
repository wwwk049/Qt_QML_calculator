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
    /*** Layout ************************************************/

    Item{// удерживает все элементы
        id: mainContent
        anchors.fill: parent

        Rectangle{// задний фон
            anchors.fill: parent

            color: appTheme.colorTeal
        }

        // элемент для отображения ввода
        MyDispInput {
            id: dispInput
            width: parent.width
            height: parent.height * .175
            anchors{
                top: parent.top
                topMargin: parent.height * .0001
                horizontalCenter: parent.horizontalCenter

            }
        }
        // элемент для отображения вывода
        MyDispOutput {
            id: dispOutput
            width: parent.width
            height: parent.height * .1
            anchors{
                top: parent.top
                topMargin: parent.height * .175//контролирует отступ от верха

            }
        }
        // область отвечающая за кнопки
        MyCalcButtons {
            id: calcButtons
            width: parent.width * .9
            height: parent.height * .6
            anchors{//привязка (bottom - нижнего края элемента к другому элементу)
                bottom: parent.bottom
                bottomMargin: parent.height * .075
                horizontalCenter: parent.horizontalCenter
                }
        }


    }
}

