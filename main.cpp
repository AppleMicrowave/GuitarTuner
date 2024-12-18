#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "guitar.h"
#include "audiomanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    qmlRegisterType<Guitar>("guitar", 1, 0, "Guitar");
    qmlRegisterType<AudioManager>("Audi", 1, 0, "AudioManager");
    engine.loadFromModule("Guitar_tuner", "Main");

    return app.exec();
}
