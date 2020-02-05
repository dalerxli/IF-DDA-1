######################################################################
# Automatically generated by qmake (2.01a) Mon Dec 27 12:07:07 2010
######################################################################

TEMPLATE 	= 	app

VERSION         =       0.4.6

TARGET 		=       cdm

CONFIG          += 	qt thread opengl warn_off release

DEPENDPATH 	+= .

QT      	+= 	core concurrent widgets sql svg opengl printsupport

DEFINES 	+=      CDMVERSION=\\\"$$VERSION\\\" 
unix::DEFINES  +=      OS=LINUX
win32::DEFINES  +=      OS=WIN32

#DEFINES 	+= 	QT_NO_DEBUG_OUTPUT

MOC_DIR         = moc
RCC_DIR         = resources

!debug_and_release {
    OBJECTS_DIR       = obj
}

QMAKE_CXXFLAGS_RELEASE  -= -O2

QMAKE_CXXFLAGS 	+= -O3 

QMAKE_LFLAGS    += -fopenmp -lfftw3_omp -lfftw3 -lm
QMAKE_LFLAGS    += -O3

HEADERS 	+= 	cdmMain.h \
			cdmOptions.h \
			cdmOptionsWidget.h \
			cdmOptionsWindow.h \
			cdmBeamConfigDialog.h \
			cdmObjectConfigDialog.h \
			cdmEpsilonConfigDialog.h \
			cdmRunWidget.h \
			cdmRun.h \
                        cdmPlot.h \
			QsLog.h \
			QsDebugOutput.h \
			QsLogDest.h \
                        Assistant.h

SOURCES		+= 	cdmMain.cpp \
			cdmOptions.cpp \
			cdmOptionsWidget.cpp \
			cdmOptionsWindow.cpp \
			cdmBeamConfigDialog.cpp \
			cdmObjectConfigDialog.cpp \
			cdmEpsilonConfigDialog.cpp \
			cdmRunWidget.cpp \
			cdmRun.cpp \
			cdmPlot.cpp \
			QsLog.cpp \
			QsDebugOutput.cpp \
			QsLogDest.cpp \
                        Assistant.cpp

CDMLIB_LIB_PATH  =  	../cdmlib/lib

CDMLIB_INC_PATH  =      ../cdmlib

QWT_LIB_PATH     =  	../qwt-6.1.2/lib

QWT_INC_PATH     =      ../qwt-6.1.2/src

QWTPLOT3_LIB_PATH  =    ../qwtplot3d/lib

QWTPLOT3_INC_PATH  =    ../qwtplot3d/include

INCLUDEPATH 	+=	$$CDMLIB_INC_PATH $$QWT_INC_PATH $$QWTPLOT3_INC_PATH

win32::LIBS 	+= -L$$CDMLIB_LIB_PATH -lcdmlib \
                   -L$$QWT_LIB_PATH -lqwt \
                   -L$$QWTPLOT3_LIB_PATH -lqwtplot3d \
                   -lglu32 -lz -lopengl32 -lgfortran

HDF5_LIBS       = -L/usr/lib64 -lhdf5hl_fortran -lhdf5_hl -lhdf5_fortran -lhdf5
# sans HDF5
HDF5_LIBS       = 

unix:LIBS            += -Wl,-Bstatic \
                   -L$$CDMLIB_LIB_PATH -lcdmlib \
                   -L$$QWT_LIB_PATH -lqwt \
                   -L$$QWTPLOT3_LIB_PATH -lqwtplot3d \
                   -Wl,-Bdynamic \
                   -lGLU -lgfortran -lfftw3_omp -lfftw3 -lm -I/usr/lib64/gfortran/modules -I/usr/include $$HDF5_LIBS


# make install
documentation.extra = ./make_doc.run
documentation.path = /usr/local/bin/doc
documentation.files = doc/*

target.path = $$PWD/../bin

options.path = $$PWD/../bin
options.files = options.db3

data.path = $$PWD/../bin
data.files = $$PWD/../data/*

INSTALLS += target options data

QMAKE_DISTCLEAN += bin/*
