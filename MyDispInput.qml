import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Item {
            id: dispInput

            property string inputText: "0"
// .7483  .2517
            Rectangle {
                anchors.fill: parent
                width: parent.width
                height: parent.height
                color: appTheme.colorTheme_1_3

            }

            Label {
                anchors.fill: parent
                anchors.rightMargin: width * .0833
                anchors.bottomMargin: height * 0.1

                minimumPixelSize: 1
                //.18625*640 119.2/20=5.96
                font.pixelSize: height/5.96
                lineHeight: 1.5 //(30*5.96)/height

                font.letterSpacing: .5
                font.family: openSans.name
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit

                color: appTheme.colorTheme_1_6
                text: dispInput.inputText

                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignBottom
            }

        }
