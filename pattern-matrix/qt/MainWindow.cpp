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

    QGraphicsView *view = new QGraphicsView;
    view->setViewport(new QGLWidget(QGLFormat(QGL::SampleBuffers)));
    view->resize(800,600);
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
}
