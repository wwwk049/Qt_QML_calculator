#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include"mathexpressionevaluator.h"
#include<QQmlContext>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    MathExpressionEvaluator mathEvaluator;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("add", &mathEvaluator);
    engine.rootContext()->setContextProperty("mathEvaluator", &mathEvaluator);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
