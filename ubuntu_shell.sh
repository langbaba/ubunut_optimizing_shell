#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

github="raw.githubusercontent.com/chiakge/Linux-NetSpeed/master"
sh_ver="v1.0.0"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

#————————————开发环境————————————\
# 16 docker环境下的alimysql
install_docker_AliMysql(){
  docker pull tekintian/alisql
  read -p "输入aliMysql数据库存储路径  :" mySqlDataPath

   mkdir -p "${mySqlDataPath}/data"
   mkdir -p "${mySqlDataPath}/logs"

   echo "[mysqld]
basedir=/usr/local/mysql
datadir=/data/mysql/data
user=mysql
port =3306
max_connections = 1650
table_open_cache = 2000
lower_case_table_names = 1
event_scheduler=ON
wait_timeout = 86400
sort_buffer_size = 848KB
read_buffer_size = 848KB
read_rnd_buffer_size = 432KB
join_buffer_size = 432KB
net_buffer_length = 16K
thread_cache_size = 100
skip_name_resolve
symbolic-links=0

[mysqld_safe]

[client]
   " > "${mySqlDataPath}/my.cnf"

   echo -e " ----------------------   运行以下命令启动    --------------------------------"
   echo -e "${info} docker run   -it -d -p 13306:3306 -e MYSQL_ROOT_PASSWORD=123456 -v ${mySqlDataPath}/my.cnf:/usr/local/mysql/etc/my.cnf  -v ${mySqlDataPath}/data:/data/mysql/data -v ${mySqlDataPath}/logs:/data/mysql/log tekintian/alisql"
   echo -e " ----------------------   启动后到docker中运行一下命令开启远程访问    --------------------------------"
   echo -e " grant all PRIVILEGES on *.* to root@'%'  identified by '123456';"
   echo -e " flush privileges; "
}


# 15 docker环境下的redis
  install_docker_redis(){
    docker pull bitnami/redis
    echo -e " ----------------------   运行以下命令启动    --------------------------------"
    echo -e "${info} docker run --name redis -e REDIS_PASSWORD=password123 bitnami/redis:latest"
    echo -e "${info} 更多命令参考 : https://hub.docker.com/r/bitnami/redis/"
  }
# 10 安装node环境
install_node(){
   read -p "输入node安装路径  :" nodePath
   mkdir -fR "${nodePath}"
   mkdir -p "${nodePath}"
   cd "${nodePath}"
   rm node-*.tar.gz*

   axel -n 5  https://npm.taobao.org/mirrors/node/v10.9.0/node-v10.9.0-linux-x64.tar.gz
   tar -zxvf node-v10.9.0-linux-x64.tar.gz
   rm node-v10.9.0-linux-x64.tar.gz

   node_home="${nodePath}/node-v10.9.0-linux-x64"
   sed -i '/export NODE_HOME/d' ~/.profile

   echo "export NODE_HOME=${node_home}
export PATH=${node_home}/bin:\$PATH
">> ~/.profile

  /bin/sh -c "sudo rm -f /usr/bin/node && sudo ln -s \"${node_home}/bin/node\" /usr/bin/node"

  source ~/.profile
  npm install -g cnpm --registry=https://registry.npm.taobao.org
}

#9 安装docker
install_docker(){
  curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun 
}


#8 安装maven环境
install_maven(){
  read -p "输入maven安装路径  :" mavenPath
  mkdir -fR "${mavenPath}"
  mkdir -p "${mavenPath}"
  cd "${mavenPath}"
  rm apache-maven*.zip*
  axel -n 5 http://mirrors.hust.edu.cn/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.zip
  unzip apache-maven-3.5.4-bin.zip

  rm -f   apache-maven*.zip*

  M2_Home="${mavenPath}/apache-maven-3.5.4"
  sed -i '/export M2_HOME/d' ~/.profile

echo "export M2_HOME=${M2_Home}
export PATH=${M2_Home}/bin:\$PATH
">> ~/.profile

source ~/.profile

# 增加本地仓库路径
sed -i "s/<localRepository>\\/path\\/to\\/local\\/repo<\\/localRepository>/--><localRepository>~\\/mvnRep<\\/localRepository><!--/g" "${M2_Home}/conf/settings.xml"
# 增加mvn 阿里源
sed -i "s/<\\/mirrors>/<mirror><id>alimaven<\\/id><name>aliyun maven<\\/name><url>http:\\/\\/maven.aliyun.com\\/nexus\\/content\\/groups\\/public\\/<\\/url><mirrorOf>central<\\/mirrorOf><\\/mirror><\\/mirrors>/g" "${M2_Home}/conf/settings.xml"

}


# 7 安装JDK
install_JDK(){
read -p "输入JDK安装路径  :" jdkPath
mkdir -fR "${jdkPath}"
mkdir -p "${jdkPath}"
cd "${jdkPath}"
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz

tar -zxvf jdk-*.tar.gz
rm -f jdk-*.tar.gz

#配置环境变量
jdk_home="${jdkPath}/jdk1.8.0_181"
sed -i '/export JAVA_HOME/d' ~/.profile
sed -i '/export CLASSPATH/d' ~/.profile
sed -i '/export PATH=${jdkPath}/d' ~/.profile

echo "export JAVA_HOME=${jdk_home}
export CLASSPATH=${jdk_home}/lib:.:${jdk_home}/jre/lib
export PATH=${jdk_home}/bin:\$PATH
">> ~/.profile

source ~/.profile
}


#————————————系统优化————————————\
# 12 VIM优化
opt_vim(){
 apt-get remove vim-common -y
 apt-get install vim -y

sed -i "/set nocompatible/d" /etc/vim/vimrc
sed -i "/set number/d" /etc/vim/vimrc
sed -i "/set ruler/d" /etc/vim/vimrc
sed -i "/syntax on/d" /etc/vim/vimrc
sed -i "/set lbr/d" /etc/vim/vimrc
sed -i "/set tabstop=4/d" /etc/vim/vimrc

echo "set nocompatible
set number
set ruler
syntax on
set lbr
set tabstop=4
">> /etc/vim/vimrc
}


# 6 中文安装
opt_installchinese(){
apt-get update
apt-get install -f
apt-get install language-pack-zh-hans fonts-wqy-zenhei curl  -y

sed -i '/LANG/d' ~/.profile
sed -i '/LANGUAGE/d' ~/.profile
sed -i '/LC_ALL/d' ~/.profile

echo "LANG=\"zh_CN.UTF-8\"
LANGUAGE=\"zh_CN:zh\"
LC_ALL=\"zh_CN.UTF-8\"
">> ~/.profile

sed -i '/LANG/d' /etc/environment
sed -i '/LANGUAGE/d' /etc/environment
sed -i '/LC_ALL/d' /etc/environment

echo "LANG=\"zh_CN.UTF-8\"
LANGUAGE=\"zh_CN:zh\"
LC_ALL=\"zh_CN.UTF-8\"
">> /etc/environment
}

# 5 禁止自动升级内核
opt_disableUpdateAuto(){
echo "APT::Periodic::Update-Package-Lists "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
" > /etc/apt/apt.conf.d/10periodic
}


# 4 更新时区
opt_timeZone(){
 echo -e "${Tip} 选择Asia-->Shanghai,确定即可"
 sleep 5
 dpkg-reconfigure tzdata
 apt-get install ntpdate -y
 ntpdate  0.cn.pool.ntp.org
/sbin/hwclock -w
}



# 3 优化TCP参数与open files
optimizing_system(){
  apt-get install -f
  apt-get update
  apt-get install unzip subversion  -y
  sed -i '/fs.file-max/d' /etc/sysctl.conf
	sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf

  echo "fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
net.ipv4.ip_forward = 1">>/etc/sysctl.conf
sysctl -p

echo "* soft  nofile  1000000
* hard  nofile  1000000
* soft  noproc  1000000
* hard  noproc  1000000
root soft  nofile  1000000
root hard  nofile  1000000
root soft  noproc  1000000
root hard  noproc  1000000">/etc/security/limits.conf
	echo "ulimit -SHn 1000000">>/etc/profile

  echo -e "${Tip} 需要重启系统后，才能生效系统优化配置"
}


#————————————网络管理————————————
# 1 开启BBR
enable_bbr(){
  sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
  
  echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	sysctl -p
	echo -e "${Info}BBR启动成功！"
}
# 2 修改DNS
opt_DNS(){
  sed -i '/nameserver/d' /etc/resolvconf/resolv.conf.d/base
  sed -i '/nameserver/d' /etc/resolvconf/resolv.conf.d/base

  echo "nameserver 114.114.114.114" >> /etc/resolvconf/resolv.conf.d/base
  echo "nameserver 223.5.5.5" >> /etc/resolvconf/resolv.conf.d/base

  resolvconf -u
}

install_openSSH(){
  rm -f openssh-*.tar*
  apt-get install -f
  apt-get update
  apt-get install axel zlib1g-dev libssl-dev libpam0g-dev make gcc -y
  axel -n 10   http://ftp.jaist.ac.jp/pub/OpenBSD/OpenSSH/portable/openssh-7.8p1.tar.gz
  tar -zxvf openssh-7.8p1.tar.gz
  rm openssh-7.8p1.tar.gz
  cd openssh-7.8p1
  cp /etc/ssh/sshd_config ./sshd_config_bak
  ./configure --prefix=/usr --sysconfdir=/etc/ssh --with-zlib --with-pam --with-md5-passwords 
  make -j4 && make install
  mv /usr/sbin/sshd /usr/sbin/sshd.old
  cp sshd /usr/sbin
  cp sshd_config_bak /etc/ssh_sshd_config
#修改配置

  /etc/init.d/ssh restart
}

#————————————内核管理————————————
# 0 内核升级
Update_LinuxKenrel(){
    #替换源
    Codename=$(lsb_release -c --short)
    cp /etc/apt/sources.list /etc/apt/sources.list.bak
    echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${Codename} main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${Codename} main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${Codename}-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${Codename}-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${Codename}-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${Codename}-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${Codename}-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${Codename}-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${Codename}-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${Codename}-proposed main restricted universe multiverse
    " > /etc/apt/sources.list

    apt-get install -f
    apt-get update
    apt-get install apt -y
    apt-get install apparmor openssh-server  apt apt-transport-https apt-utils base-files dnsutils dpkg  lshw mount openssl udev ubuntu-release-upgrader-core uuid-runtime wget axel unzip -y
  
      mkdir bbr 
       cd bbr
            # kernel_version="4.15.18"
          # axel -n 10  "http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.15.18/linux-headers-${kernel_version}-041518_4.15.18-041518.201804190330_all.deb"
          # axel -n 10   "http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.15.18/linux-headers-${kernel_version}-041518-generic_4.15.18-041518.201804190330_amd64.deb"
          # axel -n 10   "http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.15.18/linux-image-${kernel_version}-041518-generic_4.15.18-041518.201804190330_amd64.deb"
          
          kernel_version="4.18.8"
          apt-get update
          # apt-get install libssl-dev -y
          # apt-get install aptitude -y
          # aptitude install libssl-dev -y
          wget http://kr.archive.ubuntu.com/ubuntu/pool/main/l/linux-base/linux-base_4.5ubuntu1~16.04.1_all.deb
          dpkg -i linux-base*.deb
          wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4.1_amd64.deb
          dpkg -i libssl1.1*.deb
          axel -n 5 http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18.8/linux-headers-4.18.8-041808_4.18.8-041808.201809150431_all.deb
          axel -n 5 http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18.8/linux-headers-4.18.8-041808-generic_4.18.8-041808.201809150431_amd64.deb
          axel -n 5 http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18.8/linux-image-unsigned-4.18.8-041808-generic_4.18.8-041808.201809150431_amd64.deb
          axel -n 5 http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.18.8/linux-modules-4.18.8-041808-generic_4.18.8-041808.201809150431_amd64.deb

         dpkg -i linux-*.deb
		     cd .. && rm -rf bbr

     #删除旧内核
      deb_total=`dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | wc -l`
      if [ "${deb_total}" > "1" ]; then
        echo -e "检测到 ${deb_total} 个其余内核，开始卸载..."
        for((integer = 1; integer <= ${deb_total}; integer++)); do
          deb_del=`dpkg -l|grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | head -${integer}`
          echo -e "开始卸载 ${deb_del} 内核..."
          apt-get purge -y ${deb_del}
          echo -e "卸载 ${deb_del} 内核卸载完成，继续..."
        done
        echo -e "内核卸载完毕，继续..."
      else
        echo -e " 检测到 内核 数量不正确，请检查 !" && exit 1
      fi

       apt-get install -f -y
}


#开始菜单
start_menu(){
clear
Version=$(lsb_release -r --short)
Codename=$(lsb_release -c --short)
OSArch=$(uname -m)
echo && echo -e " ubuntu server 一键安装管理脚本 ${Red_font_prefix}[${sh_ver}]${Font_color_suffix}
  -- coolzlay | blog.csdn.net/zhangjianying --
 当前系统:  ${Codename} ${Version} ${OSArch}
# ————————————内核管理(需要root)————————————
#  ${Green_font_prefix}[0].${Font_color_suffix} 升级Linux Kernel 4.18.8 内核
# ————————————网络管理(需要root)————————————
#  ${Green_font_prefix}[1].${Font_color_suffix} 开启 TCP - BBR 算法 
#  ${Green_font_prefix}[2].${Font_color_suffix} 修改DNS为114与阿里公共DNS 223.5.5.5
#  ${Green_font_prefix}[11].${Font_color_suffix} 安装openSSH 7.8p1
# ————————————系统优化(需要root)————————————
#  ${Green_font_prefix}[3].${Font_color_suffix} 优化TCP参数与open files
#  ${Green_font_prefix}[4].${Font_color_suffix} 设置系统时区为东8[shanghai]
#  ${Green_font_prefix}[5].${Font_color_suffix} 禁止系统自动升级内核(高危漏洞也不自动升级)
#  ${Green_font_prefix}[6].${Font_color_suffix} 中文字体安装(支持java环境下图片输出中文)
#  ${Green_font_prefix}[12].${Font_color_suffix} 优化VIM
#  ${Green_font_prefix}[9].${Font_color_suffix} 安装docker环境
# ————————————开发环境(不需要root)————————————
#  ${Green_font_prefix}[7].${Font_color_suffix} Oracle JDK8u181 安装
#  ${Green_font_prefix}[8].${Font_color_suffix} 安装Maven环境
#  ${Green_font_prefix}[10].${Font_color_suffix} 安装node v10.9.0环境
#  ${Green_font_prefix}[15].${Font_color_suffix} 安装 docker环境下的redis
#  ${Green_font_prefix}[16].${Font_color_suffix} 安装 docker环境下的ALiMysql
# ————————————————————————————————"


read -p " 请输入对应操作字符 :" num
  case "$num" in
      0)
      Update_LinuxKenrel
      ;;
      1)
      enable_bbr
      ;;
      2)
      opt_DNS
      ;;
      3)
      optimizing_system
      ;;
      4)
      opt_timeZone
      ;;
      5)
      opt_disableUpdateAuto
      ;;
      6)
      opt_installchinese
      ;;
      7)
      install_JDK
      ;;
      8)
      install_maven
      ;;
      11)
      install_openSSH
      ;;
      12)
      opt_vim
      ;;
      15)
      install_docker_redis
      ;;
      16)
      install_docker_AliMysql
      ;;
      10)
      install_node
      ;;
      9)
      install_docker
      ;;
      *)
      clear
      echo -e "${Error}:请输入正确数字 [0-8]"
      sleep 5s
      start_menu
      ;;
  esac

}


start_menu