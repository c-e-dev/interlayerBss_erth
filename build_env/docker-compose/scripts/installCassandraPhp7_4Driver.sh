#/bin/bash
##For Php 7.4

#Install Multiarch Support
wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.27-3ubuntu1.3_amd64.deb
dpkg -i multiarch-support_2.27-3ubuntu1.3_amd64.deb

apt-get install -y libgmp-dev

# Install DataStax C++ (required for PHP Extension)
wget https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.35.0/libuv1-dev_1.35.0-1_amd64.deb
wget https://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.35.0/libuv1_1.35.0-1_amd64.deb
wget https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.15.3/cassandra-cpp-driver-dev_2.15.3-1_amd64.deb
wget https://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.15.3/cassandra-cpp-driver_2.15.3-1_amd64.deb
dpkg -i libuv1_1.35.0-1_amd64.deb
dpkg -i libuv1-dev_1.35.0-1_amd64.deb
dpkg -i cassandra-cpp-driver_2.15.3-1_amd64.deb
dpkg -i cassandra-cpp-driver-dev_2.15.3-1_amd64.deb

# Install PHP Extension
cd /usr/src
git clone https://github.com/datastax/php-driver.git

cd /usr/src/php-driver/ext
phpize7.4
mkdir /usr/src/php-driver/build
cd /usr/src/php-driver/build
../ext/configure --with-php-config=/usr/bin/php-config7.4 > /dev/null
make clean
make
make install
chmod 644 /usr/lib/php/20190902/cassandra.so

echo "; configuration for php cassandra module" >/etc/php/7.4/mods-available/cassandra.ini
echo "; priority=20" >>/etc/php/7.4/mods-available/cassandra.ini
echo "extension=cassandra.so" >>/etc/php/7.4/mods-available/cassandra.ini

phpenmod cassandra

# Clean Up
rm -R /usr/src/php-driver

exit 0