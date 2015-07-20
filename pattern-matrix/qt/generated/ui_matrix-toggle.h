/********************************************************************************
** Form generated from reading UI file 'matrix-toggletI4993.ui'
**
** Created: Mon Jul 20 14:47:37 2015
**      by: Qt User Interface Compiler version 4.8.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef MATRIX_2D_TOGGLETI4993_H
#define MATRIX_2D_TOGGLETI4993_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QPushButton>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MatrixToggle
{
public:
    QHBoxLayout *horizontalLayout;
    QPushButton *pushButton;

    void setupUi(QWidget *MatrixToggle)
    {
        if (MatrixToggle->objectName().isEmpty())
            MatrixToggle->setObjectName(QString::fromUtf8("MatrixToggle"));
        MatrixToggle->resize(104, 92);
        QSizePolicy sizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(MatrixToggle->sizePolicy().hasHeightForWidth());
        MatrixToggle->setSizePolicy(sizePolicy);
        horizontalLayout = new QHBoxLayout(MatrixToggle);
        horizontalLayout->setSpacing(0);
        horizontalLayout->setContentsMargins(0, 0, 0, 0);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        pushButton = new QPushButton(MatrixToggle);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));
        QIcon icon;
        icon.addFile(QString::fromUtf8(":/images/images/black.png"), QSize(), QIcon::Normal, QIcon::Off);
        icon.addFile(QString::fromUtf8(":/images/images/white.png"), QSize(), QIcon::Normal, QIcon::On);
        pushButton->setIcon(icon);
        pushButton->setIconSize(QSize(64, 64));
        pushButton->setCheckable(true);
        pushButton->setFlat(true);

        horizontalLayout->addWidget(pushButton);


        retranslateUi(MatrixToggle);

        QMetaObject::connectSlotsByName(MatrixToggle);
    } // setupUi

    void retranslateUi(QWidget *MatrixToggle)
    {
        MatrixToggle->setWindowTitle(QApplication::translate("MatrixToggle", "Form", 0, QApplication::UnicodeUTF8));
        pushButton->setText(QString());
    } // retranslateUi

};

namespace Ui {
    class MatrixToggle: public Ui_MatrixToggle {};
} // namespace Ui

QT_END_NAMESPACE

#endif // MATRIX_2D_TOGGLETI4993_H
