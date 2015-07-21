######################################################################
# Automatically generated by qmake (2.01a) Sun Jul 5 17:49:45 2015
######################################################################

TEMPLATE = app
TARGET =
DEPENDPATH += . 2
INCLUDEPATH += . 2

QT += core gui opengl

# Input
HEADERS += MainWindow.h \
           GLGraphicsScene.h \
           SyntaxHighlight.h \
           generated/ui_pattern-matrix.h \
           generated/ui_matrix-toggle.h \

SOURCES += MainWindow.cpp \
           GLGraphicsScene.cpp \
           SyntaxHighlight.cpp \
           qtmain.cpp

# hmm, up and out to jellyfish...
INCLUDEPATH += ../../../jellyfish/src/

LIBS += -ljellyfish -lportaudio -ljpeg -lpng -lfftw3 -lsndfile -llo -ldl -lpthread -lm

# assets
RESOURCES     = pattern-matrix.qrc

unix {
DEFINES += ASSETS_PATH=\\\"/usr/local/lib/jellyfish/\\\"
sources.path = /usr/local/lib/jellyfish/
sources.files = jellyfish/*
INSTALLS += sources
target.path = /usr/local/bin/
INSTALLS += target
}

macx {
DEFINES += ASSETS_PATH=\\\"jellyfish/\\\"
LIBS += -framework CoreFoundation
}
