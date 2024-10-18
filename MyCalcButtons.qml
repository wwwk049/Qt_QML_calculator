import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts


Item {//область для кнопок
            id: calcButtons

            property int rowCount: 5
            property int colCount: 4
//Ширина каждой кнопки вычисляется как 19.23% (~60) от ширины родительского элемента (области для кнопок)
            property real buttonWidth: width * .1923
//Высота кнопки равна ширине, что делает кнопки квадратными
            property real buttonHeight: buttonWidth

//пространство, которое остаётся между рядами кнопок
            property real rowSpacingAllocation: height-(buttonHeight*rowCount)
//пространство, оставшееся между столбцами кнопок (гор)
            property real colSpacingAllocation: width-(buttonWidth*colCount)

//вычисляется точное расстояние (отступ) между строками кнопок
            property real rowSpacing: rowSpacingAllocation/(rowCount-1)
//вычисляется расстояние между столбцами кнопок
            property real colSpacing: colSpacingAllocation/(colCount-1)



            //модель кнопок
            property var buttonsModel: [
                {"buttonText":"()","buttonColor":appTheme.colorTheme_1_2,"buttonTextColor":appTheme.colorTheme_1_6,"buttonType":"operator"},
                {"buttonText":"+/_","buttonColor":appTheme.colorTheme_1_2,"buttonTextColor":appTheme.colorTheme_1_6,"buttonType":"inversion"},
                {"buttonText":"%","buttonColor":appTheme.colorTheme_1_2, "buttonTextColor":appTheme.colorTheme_1_6,"buttonType":"operator"},
                {"buttonText":"÷","buttonColor":appTheme.colorTheme_1_2,"buttonTextColor":appTheme.colorTheme_1_6,"buttonType":"operator"},
                {"buttonText":"7","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"digit"},
                {"buttonText":"8","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"digit"},
                {"buttonText":"9","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"digit"},
                {"buttonText":"×","buttonColor":appTheme.colorTheme_1_2,"buttonTextColor":appTheme.colorTheme_1_6,"buttonType":"operator"},
                {"buttonText":"4","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"digit"},
                {"buttonText":"5","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"digit"},
                {"buttonText":"6","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"digit"},
                {"buttonText":"-","buttonColor":appTheme.colorTheme_1_2,"buttonTextColor":appTheme.colorTheme_1_6,"buttonType":"operator"},
                {"buttonText":"1","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"digit"},
                {"buttonText":"2","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"digit"},
                {"buttonText":"3","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"digit"},
                {"buttonText":"+","buttonColor":appTheme.colorTheme_1_2,"buttonTextColor":appTheme.colorTheme_1_6,"buttonType":"operator"},
                {"buttonText":"C","buttonColor":appTheme.colorTheme_1_5,"buttonTextColor":appTheme.colorTheme_1_6,"buttonType":"clear"},
                {"buttonText":"0","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"digit"},
                {"buttonText":".","buttonColor":appTheme.colorTheme_1_4,"buttonTextColor":appTheme.colorTeal,"buttonType":"point"},
                {"buttonText":"=","buttonColor":appTheme.colorTheme_1_2,"buttonTextColor":appTheme.colorTheme_1_6,"buttonType":"operator"}
            ]


            Rectangle {
                anchors.fill: parent
                color: appTheme.colorTeal
            }
            //макет сетки
            GridLayout{

                ////кол-во строк
                rows: calcButtons.rowCount
                //интервал между строк
                rowSpacing: calcButtons.rowSpacing

                //кол-во столбцов
                columns: calcButtons.colCount
                //интервал между столбцами
                columnSpacing: calcButtons.colSpacing


                    //используем повторителm
                    Repeater{
                        MyCalcButton {
                            implicitHeight: calcButtons.buttonHeight
                            implicitWidth: calcButtons.buttonWidth


                            buttonText: modelData.buttonText //применяем текст из модели
                            buttonColor: modelData.buttonColor
                            buttonTextColor: modelData.buttonTextColor

                            //3 связываем функцию щелчка и изменений
                            clickFunction:function(){
                                renderInput(modelData.buttonText, modelData.buttonType)
                            }
                        }
                        model: calcButtons.buttonsModel
                    }


            }
            //функция для добавления входных данных
            function renderInput(buttonText, buttonType){

                switch(buttonType){
                case 'clear':
                    dispInput.inputText="0"
                    dispOutput.outputText="0"
                    break;
                case 'digit':
                    var currentInput=dispInput.inputText
                    if(currentInput==="0"){
                        dispInput.inputText=""
                    }
                    dispInput.inputText=dispInput.inputText+buttonText
                    break;
                case 'operator':
                    handleOperator(buttonText)
                    break;
                case 'inversion':
                    inversionOperator()
                    break;
                case 'point':
                    dispInput.inputText=dispInput.inputText+buttonText
                    break;
                default:
                    break;

                }

            }
            function handleOperator(operator){//вставляю операторы

                /*если выражение/значение есть в поле ввода и выражение/значение в поле вывода,
                то после нажатия оператора, прибавляю его к полю вывода, который был предварительно перемещен в поле ввода.
                */

                var currentInput=dispInput.inputText //записал зн из поля ввода
                if(currentInput!=="0"){
                    var outData=dispOutput.outputText //назн новый текс

                    //если был нажат оператор, проверка:
                    if(outData!=="0"){//если в поле вывода не 0, то загоняем текстполя вывода в ввод
                        dispInput.inputText=outData
                        dispInput.inputText=dispInput.inputText+operator
                    }else{
                        dispInput.inputText=dispInput.inputText+operator
                    }
                } else {if(currentInput==="0"){//далее надо проверить какие операторы были нажаты в случае, если в поле ввода 0
                            if(operator==="+"||operator==="-"||operator==="×"||operator==="%"){
                                dispInput.inputText=dispInput.inputText+operator
                            }
                    }
                }

            }
            //функция кнопки "+/_" для изменения поля ввода
            function inversionOperator(){
                    var currentInput = dispInput.inputText;
                    var invertedInput = mathEvaluator.invertSign(currentInput);
                    dispInput.inputText = invertedInput;
            }
        }
