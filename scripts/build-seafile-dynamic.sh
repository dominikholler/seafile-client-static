#!/bin/bash
#Requested 'gobject-2.0 >= 2.26.0'

#http://superuser.com/questions/339537/where-can-i-get-therepositories-for-old-ubuntu-versions
#sudo apt-get install autoconf automake libtool libevent-dev libgtk2.0-dev uuid-dev intltool libsqlite3-dev valac cmake libicu-dev
#sudo apt-get build-dep libqt4-dev 
#sudo apt-get build-dep openssl

#export MAKE_JOBS=$(nproc)
export MAKE_JOBS=2

#export version=2.1.0-testing
export version=2.1.1-testing


export JANSSON_PREFIX=/opt/seafile
export SSL_PREFIX=/opt/seafile
export QT_PREFIX=/opt/seafile
export SEAFILE_PREFIX=/opt/seafile
export LIBEVENT_PREFIX=/opt/seafile

export PKG_CONFIG_PATH=$LIBEVENT_PREFIX/lib/pkgconfig:$JANSSON_PREFIX/lib/pkgconfig:$SSL_PREFIX/lib/pkgconfig:$QT_PREFIX/lib/pkgconfig:$SEAFILE_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
export PATH=$LIBEVENT_PREFIX/bin:$JANSSON_PREFIX/bin:$SSL_PREFIX/bin:$QT_PREFIX/bin:$SEAFILE_PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$LIBEVENT_PREFIX/lib:$JANSSON_PREFIX/lib:$SSL_PREFIX/lib:$QT_PREFIX/lib:$PREFIX/lib:$LD_LIBRARY_PATH
export COMMONFLAGS="-I$LIBEVENT_PREFIX/include -I$JANSSON_PREFIX/include -I$SSL_PREFIX/include -I$QT_PREFIX/include -I${SEAFILE_PREFIX}/include "
export CFLAGS="$COMMONFLAGS"
export CXXFLAGS="$COMMONFLAGS "
#-fno-builtin, -static-libgcc -all-static
export LDFLAGS="-L$LIBEVENT_PREFIX/lib -L$JANSSON_PREFIX/lib -L$SSL_PREFIX/lib -L$QT_PREFIX/lib -I${SEAFILE_PREFIX}/lib "


export PREFIX=$JANSSON_PREFIX
export JANSSON_VER=2.4
wget -nc http://www.digip.org/jansson/releases/jansson-$JANSSON_VER.tar.bz2
tar xvjf jansson-$JANSSON_VER.tar.bz2
cd jansson-$JANSSON_VER
./configure --prefix=$PREFIX && make -j $MAKE_JOBS install || read
cd ..


export PREFIX=$SSL_PREFIX
export SSL_NAME=openssl-1.0.1e
wget -nc http://www.openssl.org/source/$SSL_NAME.tar.gz
tar xzf $SSL_NAME.tar.gz
cd $SSL_NAME
./config --prefix=$PREFIX no-idea no-mdc2 no-rc5 zlib-dynamic shared enable-tlsext no-ssl2 $CFLAGS && make depend && make install
cd ..

export PREFIX=$QT_PREFIX

#export QT_NAME=qt-everywhere-opensource-src-4.8.5
#wget -nc http://download.qt-project.org/official_releases/qt/4.8/4.8.5/$QT_NAME.tar.gz
#tar xzf $QT_NAME.tar.gz 
#cd $QT_NAME
#./configure -confirm-license \
#	            -prefix $PREFIX \
#	            -sysconfdir "/etc/xdg" \
#	            -opensource \
#	            -plugin-sql-sqlite \
#	            -xmlpatterns \
#	            -no-multimedia \
#	            -no-audio-backend \
#	            -no-phonon \
#	            -no-phonon-backend \
#	            -svg \
#	            -no-webkit \
#	            -script \
#	            -scripttools \
#	            -platform linux-g++ \
#	            -no-rpath \
#	            -optimized-qmake \
#	            -dbus-linked \
#	            -reduce-relocations \
#	            -no-separate-debug-info \
#	            -verbose \
#	            -system-nas-sound \
#	            -no-openvg \
#	            -lfontconfig \
#	            -I/usr/include/freetype2 \
#	            -qvfb \
#	            -icu \
#              -openssl-linked \
# -static -no-qt3support -qt-zlib -qt-libtiff -qt-libpng -qt-libmng -qt-libjpeg -nomake examples -nomake demos -nomake docs -no-nis -no-cups -no-gtkstyle -no-glib -no-sm && make -j $MAKE_JOBS install || read
#cd ..

export LIBEVENT_VER=2.0.21-stable
export PREFIX=$LIBEVENT_PREFIX
wget -nc https://github.com/downloads/libevent/libevent/libevent-$LIBEVENT_VER.tar.gz
tar xvzf libevent-$LIBEVENT_VER.tar.gz
cd libevent-$LIBEVENT_VER
./configure --prefix=$PREFIX && make -j $MAKE_JOBS install
cd ..


export PREFIX=$SEAFILE_PREFIX
mkdir $version
wget --content-disposition -nc https://github.com/haiwen/libsearpc/archive/v${version}.tar.gz
wget --content-disposition -nc https://github.com/haiwen/ccnet/archive/v${version}.tar.gz
wget --content-disposition -nc https://github.com/haiwen/seafile/archive/v${version}.tar.gz
wget --content-disposition -nc https://github.com/haiwen/seafile-client/archive/v${version}.tar.gz

cd $version
tar xf ../libsearpc-${version}.tar.gz
tar xf ../ccnet-${version}.tar.gz
tar xf ../seafile-${version}.tar.gz
tar xf ../seafile-client-${version}.tar.gz

cd libsearpc-${version}
./autogen.sh && ./configure --prefix=$PREFIX && make install
cd ..

cd ccnet-${version}
./autogen.sh
./configure --prefix=$PREFIX && make install
cd ..

cd seafile-${version}/
./autogen.sh && ./configure --prefix=$PREFIX --disable-fuse  && make install
cd ..


cd seafile-client-${version}
export VERBOSE=1
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX . && make install
cd ..


cd /opt
rm -rf seafile/ssl seafile/include seafile/lib/*.a seafile/bin/openssl
cp seafile.old/bin/run_seafile-applet.sh seafile/bin/
tar cvJf /tmp/seafile-client-$version-natty.tar.xz seafile

# -o seafile-applet -rdynamic -L/home/user/tmp/seafile/build/qt/lib -L/home/user/tmp/seafile/build/seafile-2.0.8/lib /home/user/tmp/seafile/build/qt/lib/libQtGui.a -lXrender -lfontconfig -lfreetype -lXext -lX11 /home/user/tmp/seafile/build/qt/lib/libQtNetwork.a /home/user/tmp/seafile/build/qt/lib/libQtCore.a -lrt -lpthread -ldl /home/user/tmp/seafile/build/qt/lib/libQtNetwork.a -lgio-2.0 -lgobject-2.0 -lglib-2.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0 /home/user/tmp/seafile/build/qt/lib/libQtCore.a -lrt -lpthread -ldl -lgio-2.0 -lgobject-2.0 -lglib-2.0  -lgio-2.0 -lgobject-2.0 -lglib-2.0 -Wl,-rpath,/home/user/tmp/seafile/build/qt/lib:/home/user/tmp/seafile/build/seafile-2.0.8/lib:  -Wl,-Bstatic -lsqlite3 -lssl -lcrypto -lccnet -lseafile -lsearpc -lsearpc-json-glib -lgio-2.0 -luuid -levent -ljansson 

# rm seafile-applet && make && ldd  seafile-applet 

