#include <QtGui>
#include <iostream>

#include "MainWindow.h"
#include "GLGraphicsScene.h"

using namespace std;


MainWindow::MainWindow()
{
    m_Ui.setupUi(this);
    setUnifiedTitleAndToolBarOnMac(true);
    m_size=0;
    dance_colour=0;

    QGraphicsView *view = new QGraphicsView;
    view->setViewport(new QGLWidget(QGLFormat(QGL::SampleBuffers)));
    view->resize(600,800);
    view->setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
    view->setScene(new GLGraphicsScene());

    m_Ui.verticalLayoutLoom->addWidget(view);

    m_Ui.verticalLayoutMatrix->setSpacing(0);
    m_Ui.verticalLayoutMatrix->setMargin(0);
    m_Ui.verticalLayoutMatrix->setContentsMargins(0,0,0,0);

    m_warp_colour.push_back(QColor(255,255,255));
    m_warp_colour.push_back(QColor(0,0,200));
    m_weft_colour.push_back(QColor(255,255,255));
    m_weft_colour.push_back(QColor(0,0,200));
    update_interface_colours();


    m_text_editor = new QTextEdit;

    QFont font;
    font.setFamily("Courier New");
    font.setFixedPitch(true);
    font.setPointSize(12);
    m_text_editor->setStyleSheet("background: black; color: white;");
    m_text_editor->setText("(clear)\n\
\n\
(set! loom\n\
  (with-state\n\
   (scale (vector 0.5 0.5 0.5))\n\
   (rotate (vector 0 35 0))\n\
   (translate (vector 0 -2 0))\n\
   (make-loom\n\
    (make-warp)\n\
    (make-wefts \n\
        (list (vector 0.5 0.5 1) (vector 1 0.5 0.5) (vector 0.5 1 0.5))))))\n\
\n\
(set-warp-yarn! loom (list (vector 0.5 0.5 1) (vector 1 0.5 0.5) (vector 0.5 1 0.5)))");
    m_text_editor->setFont(font);
    m_highlighter = new SyntaxHighlight(m_text_editor->document());

    m_Ui.horizontalLayoutEditContainer->addWidget(m_text_editor);

    warp_change(4);

    setFocus();
}
