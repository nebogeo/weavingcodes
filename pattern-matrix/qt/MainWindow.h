#include <QtGui>
#include "generated/ui_pattern-matrix.h"
#include "generated/ui_matrix-toggle.h"

#include <iostream>
#include <string>
#include "interpreter.h"

using namespace std;


class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow();

protected:

private slots:

    void warp_change(int s) { m_size=s; rebuild(); }

    void button_pressed(bool s) {
        char first[4096];
        snprintf(first,4096,"(loom-update-size! loom %i (list ",m_size);

        string code = first;

        for (vector<QPushButton*>::iterator i=m_buttons.begin(); i!=m_buttons.end(); ++i) {
            if ((*i)->isChecked()) {
                code+="1 ";
            } else {
                code+="0 ";
            }
        }
        code+="))";

        interpreter::eval(code);
    }

private:
    Ui_MainWindow m_Ui;

    int m_size;
    vector<QPushButton*> m_buttons;

    void rebuild() {
        if (m_size>0) {
            clear_layout(m_Ui.verticalLayoutMatrix);
            m_buttons.clear();

            for (int warp = 0; warp<m_size; warp++) {
                QHBoxLayout *row_layout = new QHBoxLayout;
                for (int weft = 0; weft<m_size; weft++) {
                    Ui_MatrixToggle mt;
                    QWidget *w = new QWidget;
                    mt.setupUi(w);
                    connect(mt.pushButton, SIGNAL(toggled(bool)), this, SLOT(button_pressed(bool)));
                    m_buttons.push_back(mt.pushButton);
                    row_layout->addWidget(w);
                }
                m_Ui.verticalLayoutMatrix->addLayout(row_layout);
            }
        }
    }



    void clear_layout(QLayout *layout) {
        QLayoutItem *item;
        while((item = layout->takeAt(0))) {
            if (item->layout()) {
                clear_layout(item->layout());
                delete item->layout();
            }
            if (item->widget()) {
                delete item->widget();
            }
            //delete item;
        }
    }
};
