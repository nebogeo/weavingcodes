#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <unistd.h>
#include <QtGui>
#include "MainWindow.h"

#ifdef __APPLE__
#include "CoreFoundation/CoreFoundation.h"
#endif

using namespace std;

int main( int argc , char *argv[] ){
#ifdef __APPLE__
  CFBundleRef mainBundle = CFBundleGetMainBundle();
  CFURLRef resourcesURL = CFBundleCopyResourcesDirectoryURL(mainBundle);
  char path[PATH_MAX];
  if (!CFURLGetFileSystemRepresentation(resourcesURL, TRUE, (UInt8 *)path, PATH_MAX))
    {
      // error!
    }
  CFRelease(resourcesURL);

  chdir(path);
  std::cout << "Current Path: " << path << std::endl;
#endif

    QApplication app(argc, argv);
    MainWindow mainWin;
    mainWin.show();

    return app.exec();
}
