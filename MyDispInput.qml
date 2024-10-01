import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Item {
            id: dispInput

            property string inputText: "0"

            Rectangle {
                anchors.fill: parent
                color: appTheme.colorTheme_1_3
            }

            Label {
                anchors.fill: parent
                anchors.rightMargin: 30
                anchors.topMargin: 40

                minimumPixelSize: 1
                font.pixelSize: 20
                lineHeight: 1.5
                font.letterSpacing: .5
                font.family: "Open Sans"
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit

                color: appTheme.colorTheme_1_6
                text: dispInput.inputText

                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }

        }
