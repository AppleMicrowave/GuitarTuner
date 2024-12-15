#include "guitar.h"

Guitar::Guitar(QObject *parent) : QObject{parent} {
    image_path.setUrl("images/guitar_default.png");
}
