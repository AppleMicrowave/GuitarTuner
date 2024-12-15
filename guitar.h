#ifndef GUITAR_H
#define GUITAR_H

#include <QObject>
#include <QtQML>

class Guitar : public QObject
{
    Q_OBJECT
   // Q_PROPERTY(QUrl Path READ Path WRITE setPath NOTIFY PathChanged FINAL)

public:
    explicit Guitar(QObject *parent = nullptr);
    Q_INVOKABLE QUrl getPath() {return image_path; }

private:
    QUrl image_path;
};

#endif // GUITAR_H
