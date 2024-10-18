#ifndef MATHEXPRESSIONEVALUATOR_H
#define MATHEXPRESSIONEVALUATOR_H

#include <QObject>
#include <QString>
#include <QStack>
#include <QRegularExpression>

//#include <boost\libs\multiprecision\include\boost\multiprecision\cpp_dec_float.hpp>

class MathExpressionEvaluator : public QObject
{
    Q_OBJECT
public:
    explicit MathExpressionEvaluator(QObject *parent = nullptr);
    ~MathExpressionEvaluator();

    Q_INVOKABLE QString evaluateExpression(const QString &expression);
    Q_INVOKABLE QString invertSign(const QString &inputText);

private:
    QString toRPN(const QString &expression);
    QString evaluateRPN(const QString &rpn);  // Возвращаем строку для работы с длинными числами

    bool isOperator(QChar token) const;
    int precedence(QChar op) const;
    QString applyOperator(QChar op, const QString &a, const QString &b);  // Строки для обработки длинных чисел
};

#endif // MATHEXPRESSIONEVALUATOR_H
