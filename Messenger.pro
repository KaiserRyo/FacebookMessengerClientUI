APP_NAME = Messenger

CONFIG		+= qt warn_on cascades10 mobility

QT 			+= network
QT 			+= xml

MOBILITY 	+= sensors

include(config.pri)

LIBS += -lbb
LIBS += -lbbdata
LIBS += -lbbsystem
LIBS += -lbbdevice
LIBS += -lbbmultimedia
LIBS += -lbbcascadesmultimedia
LIBS += -lbbplatformbbm 
LIBS += -lbbplatform

LIBS += -lbbcascadesplaces
LIBS += -lQtLocationSubset

LIBS += -lcamapi
LIBS += -lGLESv1_CM
LIBS += -lexif

LIBS += -lscreen
LIBS += -lcrypto
LIBS += -lcurl
LIBS += -lpackageinfo
