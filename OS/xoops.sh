#!/bin/bash
# xoops.sh

echo -e "\033[31;42m ============= Xoops 2.5.6 Install Shell Script on CentOS 6.6 x64 =============\033[0m"
echo -e "\033[31m 2015/06/19 ============= \033[0m"

if  [ "`grep SELINUX=disabled /etc/selinux/config`" == "" ]; then
/usr/sbin/setenforce 0
# disable SELinux
sed -i -e "s@SELINUX=enforcing@#SELINUX=enforcing@"   /etc/selinux/config
sed -i -e "s@SELINUX=permissive@#SELINUX=permissive@"   /etc/selinux/config
sed -i -e "/SELINUX=/aSELINUX=disabled"   /etc/selinux/config
fi
# 安裝 mysql,httpd...等套件
yum -y install mysql mysql-server httpd php php-mysql wget php-mbstring php-gd

chkconfig httpd on
service httpd restart

chkconfig mysqld on
service mysqld restart

#下載 xoops 並解壓縮後到建立的資料夾內 /var/www/html/xoops
wget http://xoops.tn.edu.tw/uploads/tad_uploader/user_11853/23_564_xoops-2.5.6_tw_20130502.zip
unzip  23_564_xoops-2.5.6_tw_20130502.zip
mkdir /var/www/html/xoops
cp -r  xoops-2.5.6/htdocs/.   /var/www/html/xoops/.

# 修改檔案權限來安裝
chmod -R 777  /var/www/html/xoops/uploads
chmod 777     /var/www/html/xoops/mainfile.php
chmod 777     /var/www/html/xoops/include/license.php

chmod  777  /var/www/html/xoops/xoops_data/caches
chmod  777  /var/www/html/xoops/xoops_data/caches/xoops_cache
chmod  777  /var/www/html/xoops/xoops_data/caches/smarty_cache
chmod  777  /var/www/html/xoops/xoops_data/caches/smarty_compile
chmod  777  /var/www/html/xoops/xoops_data/configs
chmod  -R 777  /var/www/html/xoops/xoops_data/data
# 建立資料庫 DB NAME:"XoopsDB" USER:xsa Pwd:Passw0rd
mysql -e "create database XoopsDB"
mysql -e "show databases; "
mysql -e "grant all on XoopsDB.* to xsa@localhost; "
mysql -e "set password for xsa@localhost=password('Passw0rd'); "
mysql -e "flush privileges; "
mysql -e "use mysql;  select Host,User,Password from user; "
#用 firefox 打開 xoops 安裝環境
firefox http://localhost/xoops &