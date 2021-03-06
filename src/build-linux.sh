#!/bin/sh

VERSION=$(python -c 'import artisanlib; print(artisanlib.__version__)')
NAME=artisan-linux-${VERSION}
RPM_NAME=artisan-${VERSION}

# fix debian/DEBIAN/control _VERSION_
sed -i "s/_VERSION_/${VERSION}/g" debian/DEBIAN/control


# prepare debian directory

gzip -9 debian/usr/share/man/man1/artisan.1
gzip -9 debian/usr/share/doc/artisan/changelog


# build CentOS i386 .rpm

rm -rf debian/usr/share/artisan
tar -xf dist-centos.tar -C debian/usr/share
mv debian/usr/share/dist debian/usr/share/artisan
find debian -name .svn -exec rm -rf {} \; > /dev/null 2>&1
chown -R root:root debian
chmod -R go-w debian
chmod 0644 debian/usr/share/artisan/*.so*
rm ${NAME}_i386.deb
fakeroot dpkg --build debian ${NAME}_i386.deb
alien -r ${NAME}_i386.deb
mv ${RPM_NAME}-2.i386.rpm ${NAME}_i386.rpm

# build Ubuntu .deb

rm -rf debian/usr/share/artisan
tar -xf dist-ubuntu.tar -C debian/usr/share
mv debian/usr/share/dist debian/usr/share/artisan
find debian -name .svn -exec rm -rf {} \; > /dev/null 2>&1
chown -R root:root debian
chmod -R go-w debian
chmod 0644 debian/usr/share/artisan/*.so*
rm ${NAME}_i386-glibc2.4.deb
fakeroot dpkg --build debian ${NAME}_i386-glibc2.4.deb

# build CentOS amd64 .rpm

sed -i "s/i386/amd64/g" debian/DEBIAN/control

rm -rf debian/usr/share/artisan
tar -xf dist-centos64.tar -C debian/usr/share
mv debian/usr/share/dist debian/usr/share/artisan
find debian -name .svn -exec rm -rf {} \; > /dev/null 2>&1
chown -R root:root debian
chmod -R go-w debian
chmod 0644 debian/usr/share/artisan/*.so*
rm ${NAME}_amd64.deb
fakeroot dpkg --build debian ${NAME}_amd64.deb
alien -r ${NAME}_amd64.deb
mv ${RPM_NAME}-2.x86_64.rpm ${NAME}_x86_64.rpm

# fix debian/DEBIAN/control architecture
sed -i "s/amd64/i386/g" debian/DEBIAN/control

# fix debian/DEBIAN/control _VERSION_
sed -i "s/${VERSION}/_VERSION_/g" debian/DEBIAN/control