#-------------------------------------------------
#
# Project created by QtCreator 2016-09-11T19:43:19
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = SampleApplication
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp

HEADERS  += mainwindow.h

FORMS    += mainwindow.ui

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../SampleLibrary/release/ -lSampleLibrary
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../SampleLibrary/debug/ -lSampleLibrary
else:unix: LIBS += -L$$OUT_PWD/../SampleLibrary/ -lSampleLibrary

INCLUDEPATH += $$PWD/../SampleLibrary
DEPENDPATH += $$PWD/../SampleLibrary
