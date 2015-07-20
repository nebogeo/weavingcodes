/********************************************************************************
** Form generated from reading UI file 'pattern-matrixOv4993.ui'
**
** Created: Mon Jul 20 17:03:13 2015
**      by: Qt User Interface Compiler version 4.8.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef PATTERN_2D_MATRIXOV4993_H
#define PATTERN_2D_MATRIXOV4993_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QMainWindow>
#include <QtGui/QSpinBox>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QHBoxLayout *horizontalLayout;
    QVBoxLayout *verticalLayout;
    QHBoxLayout *horizontalLayout_2;
    QLabel *label;
    QSpinBox *spinBoxWarp;
    QVBoxLayout *verticalLayoutMatrix;
    QVBoxLayout *verticalLayoutLoom;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(800, 600);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        horizontalLayout = new QHBoxLayout(centralwidget);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        label = new QLabel(centralwidget);
        label->setObjectName(QString::fromUtf8("label"));

        horizontalLayout_2->addWidget(label);

        spinBoxWarp = new QSpinBox(centralwidget);
        spinBoxWarp->setObjectName(QString::fromUtf8("spinBoxWarp"));

        horizontalLayout_2->addWidget(spinBoxWarp);


        verticalLayout->addLayout(horizontalLayout_2);

        verticalLayoutMatrix = new QVBoxLayout();
        verticalLayoutMatrix->setObjectName(QString::fromUtf8("verticalLayoutMatrix"));

        verticalLayout->addLayout(verticalLayoutMatrix);


        horizontalLayout->addLayout(verticalLayout);

        verticalLayoutLoom = new QVBoxLayout();
        verticalLayoutLoom->setObjectName(QString::fromUtf8("verticalLayoutLoom"));

        horizontalLayout->addLayout(verticalLayoutLoom);

        MainWindow->setCentralWidget(centralwidget);

        retranslateUi(MainWindow);
        QObject::connect(spinBoxWarp, SIGNAL(valueChanged(int)), MainWindow, SLOT(warp_change(int)));

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "MainWindow", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("MainWindow", "Draft size", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // PATTERN_2D_MATRIXOV4993_H
