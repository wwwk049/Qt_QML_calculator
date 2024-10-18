import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts
import QtQuick.Controls 2.15 //для компонента Label


Item {
    id: calcButton //индентификатор нашей кнопки

    property string buttonText: ""  // Текст кнопки

    // Цвета для кнопок

    property color buttonColor: {//для начального цвета
        if (buttonText === "C") {
            return Qt.lighter(appTheme.colorTheme_1_5, 1)  // Кнопка "C" на 50% светлее цвета #F25E5E
        } else if (buttonText.match(/[0-9]/)) {
            return appTheme.colorTheme_1_3  // Цвет для кнопок с цифрами
        } else {
            return appTheme.colorTheme_1_7  // Цвет для кнопок с символами
        }
    }

    property color buttonTextColor: appTheme.colorTheme_1_6  // Цвет текста по умолчанию

    property color hoverColor: { //при наведении цвет фона
        if (buttonText === "C") {
            return Qt.lighter(appTheme.colorTheme_1_5, 1.3)
        } else if (buttonText.match(/[0-9]/)) {
            return appTheme.colorTheme_1_3
        } else {
            return appTheme.colorTheme_1_7
        }
    }
    property color pressedColor: {//цвет фона при нажатии
        if (buttonText === "C") {
            return Qt.lighter(appTheme.colorTheme_1_5, 1.3)
        } else if (buttonText.match(/[0-9]/)) {
            return appTheme.colorTheme_1_3
        } else {
            return appTheme.colorTheme_1_7
        }
    }

    property color hoverTextColor: appTheme.colorTheme_1_6  // Цвет текста при наведении
    property color pressedTextColor: "#000000"  // Цвет текста при нажатии

    // Вспомогательные свойства для отслеживания состояния
        property bool hovered: false
        property bool pressed: false
    //определяем функцию для обновления поля ввода// var-без типа //2 для передачи
    property var clickFunction: undefined

    Rectangle {//сами кнопки
            anchors.fill: parent
            width: calcButtons.buttonWidth
            height: calcButtons.buttonWidth

            radius: calcButtons.buttonWidth/2

            clip: true
            // Изменяем цвет в зависимости от состояния
            color: pressed ? calcButton.pressedColor : hovered ? calcButton.hoverColor : calcButton.buttonColor
            // MouseArea для обработки событий нажатия и наведения
            MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    // Функция для вычисления нахождения курсора внутри круга
                    function isMouseInsideCircle(mouseX, mouseY) {
                        const centerX = parent.width / 2;
                        const centerY = parent.height / 2;
                        const deltaX = mouseX - centerX;
                        const deltaY = mouseY - centerY;
                        const distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
                        return distance <= (parent.width / 2); // Проверяем попадание в круг
                        }

                    //таймер для скобок ()
                    property bool longPressTriggered: false
                    Timer {
                                    id: longPressTimer
                                    interval: 1000 // 1 секунды
                                    repeat: false
                                    onTriggered: {
                                        mouseArea.longPressTriggered = true
                                        console.log("Long press action triggered")
                                        // Здесь можно добавить логику для долгого нажатия
                                        if(calcButton.buttonText ==="()"){
                                            var currentInput=dispInput.inputText
                                            if(currentInput !="0"){
                                                    dispInput.inputText=dispInput.inputText+")"
                                                }
                                            }
                                    }
                            }


                    // Таймер для активации комбинации
                    Timer {
                                    id: combinationTimer
                                    interval: 5001 // 5 секунд для ввода комбинации
                                    repeat: false
                                    onTriggered: {
                                        if(dispInput.inputText ==="123"){
                                            mainContent.visible = false
                                            secretMenu.visible = true
                                        dispInput.inputText = "0"  // Сбрасываем ввод
                                        console.log("Combination input time ended.")}
                                        else{dispInput.inputText = "0"}
                                    }
                                }


                    //таймер для =
                    property bool equallyPress: false
                    Timer {
                                    id: equallyPressTimer
                                    interval: 4000 // 4 секунды
                                    repeat: false
                                    onTriggered: {
                                        mouseArea.equallyPress = true
                                        console.log("equally")
                                        // логика для долгого нажатия
                                            dispInput.inputText=""
                                            combinationTimer.start()
                                        }
                            }




                    onPositionChanged: {
                                    if (isMouseInsideCircle(mouseX, mouseY)) {
                                        calcButton.hovered = true;
                                    } else {
                                        calcButton.hovered = false;
                                    }
                                }

                    onPressed: {//срабатывает при нажатии на кнопку мыши
                                if (isMouseInsideCircle(mouseX, mouseY)) {
                                    calcButton.pressed = true;
                                    mouseArea.longPressTriggered = false; // Сброс перед началом нового нажатия ()
                                    mouseArea.equallyPress = false; // Сброс перед началом нового нажатия =
                                    if(calcButton.buttonText === "()"){
                                        longPressTimer.start()
                                    } else {  if(calcButton.buttonText === "="){
                                        equallyPressTimer.start()} else{clickFunction()}
                                    }

                                }
                            }

                    onReleased: {//срабатывает при отпускании кнопки мыши
                                calcButton.pressed = false //Возвращает значение свойства
                                if(calcButton.buttonText ==="()"){
                                        longPressTimer.stop()
                                        if (!mouseArea.longPressTriggered) {
                                                //console.log("Short press action triggered")
                                                var currentInput=dispInput.inputText
                                                if(currentInput==="0"){
                                                        dispInput.inputText="("
                                                }
                                                else{dispInput.inputText=dispInput.inputText+"("}

                                            }
                                    }

                                if(calcButton.buttonText ==="="){
                                        equallyPressTimer.stop()
                                        if (!mouseArea.equallyPress) {
                                                console.log("Short equally")
                                                //отправка в C++
                                                dispOutput.outputText = add.evaluateExpression(dispInput.inputText);
                                            }
                                    }
                                mouseArea.longPressTriggered = false; // Сброс значения после отпускания ()
                                mouseArea.equallyPress = false; // Сброс значения после отпускания =
                                }

                    onExited:  {// Сбрасываем цвет при выходе мыши за пределы элемента
                                calcButton.hovered = false
                                }


                    onCanceled: {// Сбрасываем цвет при отмене (начал нажатие, но переместил мышь за пределы области)
                                calcButton.pressed = false
                                }
                    }
            }

    Label {

        //центрированная метка (ее размеры)
        width: parent.width * .5
        height: width
        anchors.centerIn: parent

        minimumPixelSize: 1  //минимальный размер шрифта в пикселях
        font.pixelSize: {
            if (calcButton.buttonText === "÷" || calcButton.buttonText === "×" || calcButton.buttonText === "—" ||
                   calcButton.buttonText === "+" || calcButton.buttonText === "=")
                width * 1.2
            else
                width * 0.8
        }
        lineHeight: 1.25  // межстрочный интервал: 30 пикселей / 24 пикселя = 1.25
        font.letterSpacing: 1 // межбуквенный интервал в пикселях
        font.family: openSans.name  // шрифт
        font.weight: Font.DemiBold // Semibold
        //fontSizeMode: Text.Fit //вписываю в метку (достаточно изменить pixelSize, чтобы понять в чем дело)

        //совет
        // Изменяем цвет текста в зависимости от состояния
        color: pressed ? calcButton.pressedTextColor : hovered ? calcButton.hoverTextColor : calcButton.buttonTextColor

        //color: calcButton.buttonTextColor
        text: calcButton.buttonText

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

}
