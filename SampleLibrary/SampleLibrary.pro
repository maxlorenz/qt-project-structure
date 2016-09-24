#-------------------------------------------------
#
# Project created by QtCreator 2016-09-11T19:44:31
#
#-------------------------------------------------

QT       -= gui

TARGET = SampleLibrary
TEMPLATE = lib

DEFINES += SAMPLELIBRARY_LIBRARY

SOURCES += samplelibrary.cpp

HEADERS += samplelibrary.h\
        samplelibrary_global.h

unix {
    target.path = /usr/lib
    INSTALLS += target
}
