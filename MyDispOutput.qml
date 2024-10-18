import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Item {
            id: dispOutput
            property string outputText: "0"
            Rectangle {
                anchors.fill: parent
                color: appTheme.colorTheme_1_3
                radius: 20
                // Прямоугольник, закрывающий верхние углы
                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            width: parent.width
                            height: parent.height / 3  // Закрываем верхнюю половину
                            color: appTheme.colorTheme_1_3
                            border.width: 0  // Убираем границу
                        }
            }

            Label {
                anchors.fill: parent
                anchors.rightMargin: width * .0833 //~30 30/360
                anchors.bottomMargin: height * .2

                minimumPixelSize: 1  //минимальный размер шрифта в пикселях
                //640*.093375 = 60
                font.pixelSize: height * .83333
                lineHeight: 1.2  // межстрочный интервал: 60 пикселей / 50 пикселя = 1.2
                font.letterSpacing: .5 // межбуквенный интервал в пикселях
                font.family: openSans.name  // шрифт
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit //вписываю в метку (достаточно изменить pixelSize, чтобы понять в чем дело)

                color: appTheme.colorTheme_1_6
                text: dispOutput.outputText

                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
        }
