#include "mathexpressionevaluator.h"
#include <QStack>
#include <QDebug>
#include <QRegularExpression>
#include <QString>

MathExpressionEvaluator::MathExpressionEvaluator(QObject *parent) : QObject(parent) {}

MathExpressionEvaluator::~MathExpressionEvaluator() {}

// Метод для вызова из QML
QString MathExpressionEvaluator::evaluateExpression(const QString &expression)
{
    try {
        QString rpn = toRPN(expression);
        QString result = evaluateRPN(rpn);
        return result;  // Вернём результат как строку
    } catch (const std::exception &ex) {
        return QString("Error: ") + ex.what();
    }
}

QString MathExpressionEvaluator::invertSign(const QString &inputText) {
    QString input = inputText.trimmed();

    // Ищем последнее число в строке
    int lastDigitIndex = -1;
    for (int i = input.length() - 1; i >= 0; --i) {
        if (input[i].isDigit() || input[i] == '.') {
            lastDigitIndex = i;
        } else if (input[i] == ')') {
            // Пропускаем закрывающую скобку
            continue;
        } else {
            break;
        }
    }

    // Если нет числа в строке
    if (lastDigitIndex == -1) {
        return input;  // Возвращаем исходный ввод, если не нашли числа
    }

    // Находим начало последнего числа (для дробных или целых чисел)
    int start = lastDigitIndex;
    while (start > 0 && (input[start - 1].isDigit() || input[start - 1] == '.')) {
        start--;
    }

    // Проверяем символ перед числом или перед скобками
    QChar charBeforeNumber = (start > 0) ? input[start - 1] : '\0';

    // Если перед числом закрывающая скобка, находим соответствующую открывающую
    if (charBeforeNumber == ')') {
        int openBracketIndex = -1;
        int bracketCounter = 1;
        for (int i = start - 2; i >= 0; --i) {
            if (input[i] == ')') {
                bracketCounter++;
            } else if (input[i] == '(') {
                bracketCounter--;
                if (bracketCounter == 0) {
                    openBracketIndex = i;
                    break;
                }
            }
        }

        if (openBracketIndex != -1) {
            // Проверяем символ перед открывающей скобкой
            QChar charBeforeBracket = (openBracketIndex > 0) ? input[openBracketIndex - 1] : '\0';
            if (charBeforeBracket == '-') {
                // Если перед скобкой минус, удаляем его
                input.remove(openBracketIndex - 1, 1);
            } else {
                // В остальных случаях добавляем минус перед скобкой
                input.insert(openBracketIndex, '-');
            }
        }
    } else if (charBeforeNumber == '-') {
        // Если перед числом минус, заменяем его на плюс
        input.replace(start - 1, 1, '+');
    } else if (charBeforeNumber == '+') {
        // Если перед числом плюс, заменяем его на минус
        input.replace(start - 1, 1, '-');
    } else {
        // В остальных случаях добавляем минус перед числом
        input.insert(start, '-');
    }

    return input;
}


// Преобразование выражения в обратную польскую запись (RPN)
QString MathExpressionEvaluator::toRPN(const QString &expression)
{
    QStack<QChar> ops;
    QString output;
    bool expectNegative = true;

    for (int i = 0; i < expression.length(); ++i) {
        QChar token = expression[i];

        if (token.isDigit() || token == '.') {
            output += token;
            expectNegative = false;
        } else if (token == '(') {
            ops.push(token);
            expectNegative = true;
        } else if (token == ')') {
            output += ' ';
            while (!ops.isEmpty() && ops.top() != '(') {
                output += ops.pop();
                output += ' ';
            }
            if (!ops.isEmpty()) {
                ops.pop();
            }
            expectNegative = false;
        } else if (isOperator(token)) {
            output += ' ';
            if (token == '-' && expectNegative) {
                output += '-';
            } else {
                while (!ops.isEmpty() && precedence(ops.top()) >= precedence(token)) {
                    output += ops.pop();
                    output += ' ';
                }
                ops.push(token);
                expectNegative = true;
            }
        }
    }

    while (!ops.isEmpty()) {
        output += ' ' + ops.pop();
    }

    return output.trimmed();
}

// Вычисление выражения в обратной польской записи (RPN)
QString MathExpressionEvaluator::evaluateRPN(const QString &rpn)
{
    QStack<QString> values;
    QStringList tokens = rpn.split(QRegularExpression("\\s+"), Qt::SkipEmptyParts);

    for (const QString &token : tokens) {
        if (QRegularExpression("^[-+]?\\d*\\.?\\d+$").match(token).hasMatch()) {
            values.push(token);  // Работаем с числом как со строкой
        } else if (isOperator(token[0])) {
            if (values.size() < 2) {
                throw std::runtime_error("Invalid expression: insufficient operands for operation");
            }
            QString b = values.pop();
            QString a = values.pop();
            values.push(applyOperator(token[0], a, b));
        }
    }

    if (values.isEmpty()) {
        throw std::runtime_error("Invalid expression: no result on stack");
    }

    return values.top();
}

//typedef boost::multiprecision::cpp_dec_float_50 high_precision_float;
// Применение оператора к двум операндам
QString MathExpressionEvaluator::applyOperator(QChar op, const QString &a, const QString &b)
{
    double numA = a.toDouble();
    double numB = b.toDouble();
    double result;
    // high_precision_float numA(a.toStdString());  // Преобразуем строку в число высокой точности
    // high_precision_float numB(b.toStdString());
    // high_precision_float result;

    if (op == '+') {
        result = numA + numB;
    } else if (op == '-') {
        result = numA - numB;
    } else if (op == '*' || op == QChar(0x00D7)) {
        result = numA * numB;
    } else if (op == '/' || op == QChar(0x00F7)) {
        if (numB == 0) throw std::runtime_error("Division by zero");
        result = numA / numB;
    } else if (op == '%') {
        result = std::fmod(numA, numB);
    } else {
        throw std::runtime_error("Unknown operator");
    }

     return QString::number(result, 'f', 25);
    //return QString::fromStdString(result.str(25, std::ios_base::fixed));
}

// Проверка, является ли символ оператором
bool MathExpressionEvaluator::isOperator(QChar token) const
{
    return token == '+' || token == '-' || token == '*' || token == '/' ||
           token == QChar(0x00F7) || token == QChar(0x00D7) || token == '%';
}

// Определение приоритета оператора
int MathExpressionEvaluator::precedence(QChar op) const
{
    if (op == '+' || op == '-') {
        return 1;
    } else if (op == '*' || op == QChar(0x00D7) || op == '/' || op == QChar(0x00F7)) {
        return 2;
    } else if (op == '%') {
        return 3;
    } else {
        return 0;
    }
}
