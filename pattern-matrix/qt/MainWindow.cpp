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

}
