#-------------------------------------------------
#
# Project created by QtCreator 2016-09-11T19:42:42
#
#-------------------------------------------------

QT       += testlib

QT       -= gui

TARGET = tst_sampletest
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += tst_sampletest.cpp
DEFINES += SRCDIR=\\\"$$PWD/\\\"

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../SampleLibrary/release/ -lSampleLibrary
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../SampleLibrary/debug/ -lSampleLibrary
else:unix: LIBS += -L$$OUT_PWD/../SampleLibrary/ -lSampleLibrary

INCLUDEPATH += $$PWD/../SampleLibrary
DEPENDPATH += $$PWD/../SampleLibrary
