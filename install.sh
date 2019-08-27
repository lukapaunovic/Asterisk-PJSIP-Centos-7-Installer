sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config

yum install -y epel-release dmidecode gcc-c++ ncurses-devel libxml2-devel make wget openssl-devel newt-devel kernel-devel sqlite-devel libuuid-devel gtk2-devel jansson-devel binutils-devel patch bzip2 bzip2-libs
yum groupinstall "Development Tools" -y

adduser asterisk -c "Asterisk User"

randstring=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32};echo;)
echo $randstring > /home/asterisk/password
echo $randstring | passwd --stdin asterisk

usermod -aG wheel asterisk

su asterisk

randstring=$(cat /home/asterisk/password)
mkdir ~/build && cd ~/build

wget https://www.pjsip.org/release/2.8/pjproject-2.8.tar.bz2

tar xvjf pjproject-2.8.tar.bz2

cd pjproject-2.8

./configure CFLAGS="-DNDEBUG -DPJ_HAS_IPV6=1" --prefix=/usr --libdir=/usr/lib64 --enable-shared --disable-video --disable-sound --disable-opencore-amr

make dep

make

echo $randstring | sudo -S make install
echo $randstring | sudo -S ldconfig


ldconfig -p | grep pj

cd ~/build

wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz

tar -zxvf asterisk-16-current.tar.gz

cd asterisk-16.*

echo $randstring | sudo -S yum -y install svn

./contrib/scripts/get_mp3_source.sh

echo $randstring |  sudo -S contrib/scripts/install_prereq install

./configure --libdir=/usr/lib64 --with-jansson-bundled

make menuselect

make

echo $randstring | sudo -S make install
echo $randstring | sudo -S make samples
echo $randstring | sudo -S make config


echo $randstring | sudo -S chown asterisk. /var/run/asterisk
echo $randstring | sudo -S chown asterisk. -R /etc/asterisk
echo $randstring | sudo -S chown asterisk. -R /var/{lib,log,spool}/asterisk

echo $randstring | sudo -S service asterisk start

echo Your asterisk user password is: $randstring
echo Reboot is recommended
echo Access Asterisk console with asterisk -rvv
