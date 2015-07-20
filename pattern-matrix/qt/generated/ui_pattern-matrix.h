/********************************************************************************
** Form generated from reading UI file 'pattern-matrixVB4993.ui'
**
** Created: Mon Jul 20 21:01:47 2015
**      by: Qt User Interface Compiler version 4.8.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef PATTERN_2D_MATRIXVB4993_H
#define PATTERN_2D_MATRIXVB4993_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QGridLayout>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QMainWindow>
#include <QtGui/QPushButton>
#include <QtGui/QSpacerItem>
#include <QtGui/QSpinBox>
#include <QtGui/QTabWidget>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QHBoxLayout *horizontalLayout;
    QTabWidget *tabWidget;
    QWidget *tab;
    QHBoxLayout *horizontalLayout_3;
    QVBoxLayout *verticalLayout;
    QHBoxLayout *horizontalLayout_2;
    QLabel *label;
    QSpinBox *spinBoxWarp;
    QLabel *label_2;
    QPushButton *pushButtonWeft1;
    QPushButton *pushButtonWeft2;
    QLabel *label_3;
    QPushButton *pushButtonWarp1;
    QPushButton *pushButtonWarp2;
    QSpacerItem *horizontalSpacer_3;
    QGridLayout *gridLayout;
    QVBoxLayout *verticalLayout_2;
    QSpacerItem *verticalSpacer;
    QSpacerItem *horizontalSpacer_2;
    QSpacerItem *verticalSpacer_2;
    QSpacerItem *horizontalSpacer;
    QVBoxLayout *verticalLayoutMatrix;
    QWidget *tab_2;
    QHBoxLayout *horizontalLayout_5;
    QVBoxLayout *verticalLayout_3;
    QHBoxLayout *horizontalLayoutEditContainer;
    QHBoxLayout *horizontalLayout_4;
    QPushButton *pushButtonEval;
    QSpacerItem *horizontalSpacer_4;
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
        tabWidget = new QTabWidget(centralwidget);
        tabWidget->setObjectName(QString::fromUtf8("tabWidget"));
        tab = new QWidget();
        tab->setObjectName(QString::fromUtf8("tab"));
        horizontalLayout_3 = new QHBoxLayout(tab);
        horizontalLayout_3->setObjectName(QString::fromUtf8("horizontalLayout_3"));
        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        label = new QLabel(tab);
        label->setObjectName(QString::fromUtf8("label"));

        horizontalLayout_2->addWidget(label);

        spinBoxWarp = new QSpinBox(tab);
        spinBoxWarp->setObjectName(QString::fromUtf8("spinBoxWarp"));

        horizontalLayout_2->addWidget(spinBoxWarp);

        label_2 = new QLabel(tab);
        label_2->setObjectName(QString::fromUtf8("label_2"));

        horizontalLayout_2->addWidget(label_2);

        pushButtonWeft1 = new QPushButton(tab);
        pushButtonWeft1->setObjectName(QString::fromUtf8("pushButtonWeft1"));

        horizontalLayout_2->addWidget(pushButtonWeft1);

        pushButtonWeft2 = new QPushButton(tab);
        pushButtonWeft2->setObjectName(QString::fromUtf8("pushButtonWeft2"));

        horizontalLayout_2->addWidget(pushButtonWeft2);

        label_3 = new QLabel(tab);
        label_3->setObjectName(QString::fromUtf8("label_3"));

        horizontalLayout_2->addWidget(label_3);

        pushButtonWarp1 = new QPushButton(tab);
        pushButtonWarp1->setObjectName(QString::fromUtf8("pushButtonWarp1"));

        horizontalLayout_2->addWidget(pushButtonWarp1);

        pushButtonWarp2 = new QPushButton(tab);
        pushButtonWarp2->setObjectName(QString::fromUtf8("pushButtonWarp2"));

        horizontalLayout_2->addWidget(pushButtonWarp2);

        horizontalSpacer_3 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_2->addItem(horizontalSpacer_3);


        verticalLayout->addLayout(horizontalLayout_2);

        gridLayout = new QGridLayout();
        gridLayout->setObjectName(QString::fromUtf8("gridLayout"));
        verticalLayout_2 = new QVBoxLayout();
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        verticalSpacer = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_2->addItem(verticalSpacer);


        gridLayout->addLayout(verticalLayout_2, 2, 1, 1, 1);

        horizontalSpacer_2 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout->addItem(horizontalSpacer_2, 1, 2, 1, 1);

        verticalSpacer_2 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout->addItem(verticalSpacer_2, 0, 1, 1, 1);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout->addItem(horizontalSpacer, 1, 0, 1, 1);

        verticalLayoutMatrix = new QVBoxLayout();
        verticalLayoutMatrix->setObjectName(QString::fromUtf8("verticalLayoutMatrix"));

        gridLayout->addLayout(verticalLayoutMatrix, 1, 1, 1, 1);


        verticalLayout->addLayout(gridLayout);


        horizontalLayout_3->addLayout(verticalLayout);

        tabWidget->addTab(tab, QString());
        tab_2 = new QWidget();
        tab_2->setObjectName(QString::fromUtf8("tab_2"));
        horizontalLayout_5 = new QHBoxLayout(tab_2);
        horizontalLayout_5->setObjectName(QString::fromUtf8("horizontalLayout_5"));
        verticalLayout_3 = new QVBoxLayout();
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        horizontalLayoutEditContainer = new QHBoxLayout();
        horizontalLayoutEditContainer->setObjectName(QString::fromUtf8("horizontalLayoutEditContainer"));

        verticalLayout_3->addLayout(horizontalLayoutEditContainer);

        horizontalLayout_4 = new QHBoxLayout();
        horizontalLayout_4->setObjectName(QString::fromUtf8("horizontalLayout_4"));
        pushButtonEval = new QPushButton(tab_2);
        pushButtonEval->setObjectName(QString::fromUtf8("pushButtonEval"));

        horizontalLayout_4->addWidget(pushButtonEval);

        horizontalSpacer_4 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_4->addItem(horizontalSpacer_4);


        verticalLayout_3->addLayout(horizontalLayout_4);


        horizontalLayout_5->addLayout(verticalLayout_3);

        tabWidget->addTab(tab_2, QString());

        horizontalLayout->addWidget(tabWidget);

        verticalLayoutLoom = new QVBoxLayout();
        verticalLayoutLoom->setObjectName(QString::fromUtf8("verticalLayoutLoom"));

        horizontalLayout->addLayout(verticalLayoutLoom);

        MainWindow->setCentralWidget(centralwidget);

        retranslateUi(MainWindow);
        QObject::connect(spinBoxWarp, SIGNAL(valueChanged(int)), MainWindow, SLOT(warp_change(int)));
        QObject::connect(pushButtonWeft1, SIGNAL(released()), MainWindow, SLOT(weft_colour1()));
        QObject::connect(pushButtonWeft2, SIGNAL(released()), MainWindow, SLOT(weft_colour2()));
        QObject::connect(pushButtonWarp1, SIGNAL(released()), MainWindow, SLOT(warp_colour1()));
        QObject::connect(pushButtonWarp2, SIGNAL(released()), MainWindow, SLOT(warp_colour2()));
        QObject::connect(pushButtonEval, SIGNAL(released()), MainWindow, SLOT(eval()));

        tabWidget->setCurrentIndex(1);


        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "Weavecoding Pattern Matrix 0.1", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("MainWindow", "Draft size", 0, QApplication::UnicodeUTF8));
        label_2->setText(QApplication::translate("MainWindow", "Weft colours", 0, QApplication::UnicodeUTF8));
        pushButtonWeft1->setText(QString());
        pushButtonWeft2->setText(QString());
        label_3->setText(QApplication::translate("MainWindow", "Warp colours", 0, QApplication::UnicodeUTF8));
        pushButtonWarp1->setText(QString());
        pushButtonWarp2->setText(QString());
        tabWidget->setTabText(tabWidget->indexOf(tab), QApplication::translate("MainWindow", "Matrix", 0, QApplication::UnicodeUTF8));
        pushButtonEval->setText(QApplication::translate("MainWindow", "Eval", 0, QApplication::UnicodeUTF8));
        tabWidget->setTabText(tabWidget->indexOf(tab_2), QApplication::translate("MainWindow", "Livecode", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // PATTERN_2D_MATRIXVB4993_H
