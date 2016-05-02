#!/bin/bash

#installs autoconf, automake, libtool to the current directory (installs in a directory called 'util')

CC=gcc

AUTOCONF_VERS=autoconf-2.69
AUTOMAKE_VERS=automake-1.15
LIBTOOL_VERS=libtool-2.4.6

#
# Should not need to modify any lines below
#
INSTALL_DIR=$(pwd)

wget http://ftp.gnu.org/gnu/autoconf/$AUTOCONF_VERS.tar.gz
tar xzf $AUTOCONF_VERS.tar.gz
cd $AUTOCONF_VERS
./configure --prefix=$INSTALL_DIR/util CC=$CC
make
make install
cd ..

wget http://ftp.gnu.org/gnu/automake/$AUTOMAKE_VERS.tar.gz
tar xzf $AUTOMAKE_VERS.tar.gz
cd $AUTOMAKE_VERS
./configure --prefix=$INSTALL_DIR/util CC=$CC
make
make install
cd ..

wget http://www.dvlnx.com/software/gnu/libtool/$LIBTOOL_VERS.tar.gz
tar xzf $LIBTOOL_VERS.tar.gz
cd $LIBTOOL_VERS
./configure --prefix=$INSTALL_DIR/util CC=$CC
make
make install
cd ..

#rm -fr autoconf* automake* libtool* util
#PATH=$INSTALL_DIR/util/bin:$PATH

NO_COLOR='\033[0m'
GREEN_COLOR='\033[32;01m'
RED_COLOR='\033[31;01m'

printf "\n${GREEN_COLOR}   *** YOU NEED TO ADD THE util DIR TO PATH ****\n       In bash: ${RED_COLOR} export PATH=\"${INSTALL_DIR}/util/bin:\$PATH\" ${GREEN_COLOR} ${GREEN_COLOR} \n       In csh: ${RED_COLOR} setenv PATH \"${INSTALL_DIR}/util/bin:\$PATH\" ${NO_COLOR} \n\n"

