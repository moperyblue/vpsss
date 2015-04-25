#!/bin/sh
mkdir -p /opt/software
cd /opt/software

yum install build-essential autoconf libtool libssl-dev gcc openssl openssl-devel git -y

rm -rf /opt/software/shadowsocks-libev

git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
./configure
make && make install

f=$(find / -type f -name "*shadowsocks.json");cp $f /root/config.json

#IP=$1
#IP=$(ifconfig|awk '/inet addr:/'|grep -v 127.0.0.1|grep -oP '(?<=inet addr:)[^ ]+'|head -1)
[[ -n $1 ]] && IP=$1 || IP=$(ifconfig|awk '/inet addr:/'|grep -v 127.0.0.1|grep -oP '(?<=inet addr:)[^ ]+'|head -1)
sed -i 's/127.0.0.1/'$IP'/;s/8388/444/;s/barfoo!/qhqvps/;s/null/"aes-256-cfb"/' /root/config.json

#echo "nohup /usr/local/bin/ss-server -c /root/config.json > /dev/null 2>&1 &" >> /etc/rc.local
[[ $(grep -c ss-server /etc/rc.local) == 0 ]] && echo "nohup /usr/local/bin/ss-server -c /root/config.json > /dev/null 2>&1 &" >> /etc/rc.local||echo 'it has be set to run on startup !'

echo "shadowsocks-libev installed !"
sleep 3 
#chkconfig sshd off

echo "server will be restarted !"
sleep 3 #default: seconds
reboot
