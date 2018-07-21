#!/bin/bash
Get_Dist()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    else
        DISTRO='unknow'
    fi
}

# Check if user is root
[ $(id -u) != "0" ] && echo "Error: You must be root to run this script, please use root to install lnmp" && exit 1
#创建用户
if [ $(cat /etc/passwd | grep work | wc -l) -eq 0 ]; then
    useradd work
fi

Get_Dist

# mysql
while :
do
    # Set mysql install flag
    read -p "install MySQL [y/N]: [N] " mysql
    if [ $mysql ]; then
        if [ $mysql == "y" -o $mysql == "N" ];then
            if [ $mysql == "y" ];then
                while :
                do
                    # Set password
                    read -p "Please input the root password of MySQL:" mysqlrootpwd
                    if (( ${#mysqlrootpwd} >= 5));then
                        break
                    else
                        echo "least 5 characters"
                    fi
                done
            fi
            break
        fi
    else
        mysql="N"
        break
    fi
done
# php
if [ $mysql -a $mysql == "N" ];then
  while :
  do
      #Set php install flag
      read -p "install PHP [y/N]: [N] " php
      if [ $php ]; then
          if [ $php == "y" -o $php == "N" ];then
              break;
          fi
      else
          php="N"
          break
      fi
  done
  # php version
  if [ $php == "y" ];then
      while :
      do
          read -p "Install PHP version [55(5.5.38)/56(5.6.30)/70(7.0.15)/71(7.1.1)]:" php_v
          php_v_arr=${php_v//,/ };
          php_version=();
          while [ ${#php_version[*]} == 0 ]
          do
              for php_v_item in $php_v_arr
              do
                  # Select php version
                  if [ $php_v_item -eq 55 -o $php_v_item -eq 56 -o $php_v_item -eq 70 -o $php_v_item -eq 71 ];then
                      case $php_v_item in
                          55)
                              php_version[55]=5.5.38;
                              ;;
                          56)
                              php_version[56]=5.6.30;
                              ;;
                          70)
                              php_version[70]=7.0.15;
                              ;;
                           71)
                              php_version[71]=7.1.1;
                              ;;
                      esac
                  fi
              done
              if [ ${#php_version[*]} == 0 ];then
                  read -p "Install PHP version [55(5.5.38)/56(5.6.30)/70(7.0.15)/71(7.1.1)]:" php_v;
                  php_v_arr=${php_v//,/ };
              fi
          done
          break
      done
  fi
  #swoole
  if [ $php == "y" ];then
      while :
      do
          read -p "install Swoole [y/N]: [N] " php_swoole
          if [ $php_swoole ]; then
              if [ $php_swoole == "y" -o $php_swoole == "N" ];then
                  break
              fi
          else
              php_swoole="N"
              break
          fi
      done
  fi
fi
# nginx
if [ $php -a $php == "N" ];then
    while :
    do
        #Set nginx install flag
        read -p "install Nginx [y/N]: [N] " nginx
        if [ $nginx ]; then
            if [ $nginx == "y" -o $nginx == "N" ];then
                break
            fi
        else
            nginx="N"
            break
        fi
    done
    #swoole
    if [ $nginx == "y" ];then
        while :
        do
            read -p "install Openresty [y/N]: [N] " openresty
            if [ $openresty ]; then
                if [ $openresty == "y" -o $openresty == "N" ];then
                    break
                fi
            else
                openresty="N"
                break
            fi
        done
    fi
fi
# memcached
if [ $nginx -a $nginx == "N" ];then
    while :
    do
        #Set memcached install flag
        read -p "install Memcached [y/N]: [N] " memcached
        if [ $memcached ]; then
            if [ $memcached == "y" -o $memcached == "N" ];then
                break
            fi
        else
            memcached="N"
            break
        fi
    done
fi
# redis
if [ $memcached -a $memcached == "N" ];then
    while :
    do
        #Set redis install flag
        read -p "install Redis [y/N]: [N] " redis
        if [ $redis ]; then
            if [ $redis == "y" -o $redis == "N" ];then
                break
            fi
        else
            redis="N"
        fi
    done
fi
# mode
while :
do
    # Set Env
    read -p "Please choose environment you wanna install Production[1] Development[2]: [1] " mode
    if [ $mode ]; then
        if [ $mode == 1 -o $mode == 2 ];then
            break
        fi
    else
        mode=1
        break
    fi
done
# path
while :
do
    read -p "Please choose install folder: [/home/work] " install_path
    if [ ! $install_path ]; then
        install_path="/home/work"
    fi
    if [ $install_path ]; then
        break
    fi
done
if [ ! -d $install_path ];then
    mkdir -p $install_path;
fi
while :
do
    read -p "Please choose install lib folder: $install_path/[lib] " install_lib_path
    if [ ! $install_lib_path ]; then
        install_lib_path=$install_path"/lib"
    fi
    if [ $install_lib_path ]; then
        break
    fi
done
if [ ! -d $install_lib_path ];then
    mkdir -p $install_lib_path;
fi
while :
do
    read -p "Please choose install bin folder: $install_path/[bin] " install_bin_path
    if [ ! $install_bin_path ]; then
        install_bin_path=$install_path"/bin"
    fi
    if [ $install_bin_path ]; then
        break
    fi
done
if [ ! -d $install_bin_path ];then
    mkdir -p $install_bin_path;
fi
while :
do
    read -p "Please choose install var folder: $install_path/[var] " install_var_path
    if [ ! $install_var_path ]; then
        install_var_path=$install_path"/var"
    fi
    if [ $install_var_path ]; then
        break
    fi
done
if [ ! -d $install_var_path ];then
    mkdir -p $install_var_path;
    chown work:work $install_var_path;
fi
var_log_path=$install_var_path"/log";
var_run_path=$install_var_path"/run";
var_data_path=$install_var_path"/data";
mkdir -p $var_log_path $var_run_path $var_data_path;
chown work:work $var_log_path $var_run_path $var_data_path
if [[ $mysql != "y" && $php != "y" && $nginx != "y" && $memcached != "y" && $redis != "y" ]];then
    exit 0;
fi
#安装依赖库
sudo $PM install -y gcc gcc-c++ cmake autoconf perl wget
#定义文件夹
current_path=$(cd "$(dirname "$0")"; pwd);
source_path=$current_path"/source";
source_lib_path=$source_path"/lib"
source_lib_X11_path=$source_lib_path"/libX11"
source_lib_php_ext_path=$source_lib_path"/php-ext"
mkdir -p $source_lib_path $source_lib_X11_path $source_lib_php_ext_path;

#创建目录

#下载相关源码包
if [ ! -d "$source_lib_path" ]; then
    echo $source_lib_path" not exists";
    exit 1;
fi
cd $source_lib_path
zlib_version='1.2.11'
source_zlib_path=$source_lib_path/zlib-${zlib_version}
install_zlib_path=$install_lib_path/zlib-${zlib_version}
wget -nc http://zlib.net/zlib-${zlib_version}.tar.gz
libxml_version='2.9.3'
source_libxml_path=$source_lib_path/libxml2-${libxml_version}
install_libxml_path=$install_lib_path/libxml2-${libxml_version}
wget -nc ftp://xmlsoft.org/libxml2/libxml2-${libxml_version}.tar.gz
mhash_version='0.9.9.9'
source_mhash_path=$source_lib_path/mhash-${mhash_version}
install_mhash_path=$install_lib_path/mhash-${mhash_version}
wget -nc http://jaist.dl.sourceforge.net/project/mhash/mhash/${mhash_version}/mhash-${mhash_version}.tar.gz
pcre_version='8.40'
source_pcre_path=$source_lib_path/pcre-${pcre_version}
install_pcre_path=$install_lib_path/pcre-${pcre_version}
wget -nc ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${pcre_version}.tar.gz
libmcrypt_version='2.5.7'
source_libmcrypt_path=$source_lib_path/libmcrypt-${libmcrypt_version}
install_libmcrypt_path=$install_lib_path/libmcrypt-${libmcrypt_version}
wget -nc ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-${libmcrypt_version}.tar.gz
#openssl_version='1.0.2k'
#source_openssl_path=$source_lib_path/openssl-OpenSSL_${openssl_version}
#install_openssl_path=$install_lib_path/openssl-${openssl_version}
#wget -nc https://www.openssl.org/source/openssl-${openssl_version}.tar.gz
curl_version='7.45.0'
source_curl_path=$source_lib_path/curl-${curl_version}
install_curl_path=$install_lib_path/curl-${curl_version}
wget -nc http://curl.haxx.se/download/curl-7.45.0.tar.gz
ncurses_version='5.9'
source_ncurses_path=$source_lib_path/ncurses-${ncurses_version}
install_ncurses_path=$install_lib_path/ncurses-${ncurses_version}
wget -nc http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz
gettext_version='0.19.5.1'
source_gettext_path=$source_lib_path/gettext-${gettext_version}
install_gettext_path=$install_lib_path/gettext-${gettext_version}
wget -nc http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.5.1.tar.gz
readline_version='6.3'
source_readline_path=$source_lib_path/readline-${readline_version}
install_readline_path=$install_lib_path/readline-${readline_version}
wget -nc http://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz
libmemcached_version='1.0.18'
source_libmemcached_path=$source_lib_path/libmemcached-${libmemcached_version}
install_libmemcached_path=$install_lib_path/libmemcached-${libmemcached_version}
wget -nc https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
libevent_version='2.0.22'
source_libevent_path=$source_lib_path/libevent-${libevent_version}-stable
install_libevent_path=$install_lib_path/libevent-${libevent_version}
wget -nc https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
#下载GD相关源码包
#libgd_version='2.1.0'
#source_libgd_path=$source_lib_path/libgd-${libgd_version}
#install_libgd_path=$install_lib_path/libgd-${libgd_version}
#wget -nc https://github.com/libgd/libgd/releases/download/gd-${libgd_version}/libgd-${libgd_version}.tar.bz2
freetype_version='2.7.1'
source_freetype_path=$source_lib_path/freetype-${freetype_version}
wget -nc http://downloads.sourceforge.net/freetype/freetype-${freetype_version}.tar.bz2
jpeg_version='9'
source_jpeg_path=$source_lib_path/jpeg-${jpeg_version}
wget -nc http://www.ijg.org/files/jpegsrc.v9.tar.gz
libpng_version='1.6.28'
source_libpng_path=$source_lib_path/libpng-${libpng_version}
wget -nc http://sourceforge.net/projects/libpng/files/libpng16/${libpng_version}/libpng-${libpng_version}.tar.gz
ls *.tar.gz | xargs -n1 tar --no-same-owner -z -x -f
#下载libX11相关源码包
if [ ! -d "$source_lib_X11_path" ]; then
    echo $source_lib_X11_path" not exists";
    exit 1;
fi
cd $source_lib_X11_path;
libX11_version='1.6.2'
install_libX11_path=$install_lib_path/libX11-${libX11_version}
source_libX11_path=$source_lib_X11_path/libX11-${libX11_version}
wget -nc http://ftp.x.org/pub/individual/lib/libX11-1.6.2.tar.gz
xproto_version='7.0.28'
source_xproto_path=$source_lib_X11_path/xproto-${xproto_version}
wget -nc http://xorg.freedesktop.org/archive/individual/proto/xproto-7.0.28.tar.gz
xextproto_version='7.1.1'
source_xextproto_path=$source_lib_X11_path/xextproto-${xextproto_version}
wget -nc http://xorg.freedesktop.org/archive/individual/proto/xextproto-7.1.1.tar.gz
xtrans_version='1.3.5'
source_xtrans_path=$source_lib_X11_path/xtrans-${xtrans_version}
wget -nc http://xorg.freedesktop.org/archive/individual/lib/xtrans-1.3.5.tar.gz
xcb_proto_version='1.11'
source_xcb_proto_path=$source_lib_X11_path/xcb-proto-${xcb_proto_version}
wget -nc http://xcb.freedesktop.org/dist/xcb-proto-1.11.tar.gz
libpthread_stubs_version='0.3'
source_libpthread_stubs_path=$source_lib_X11_path/libpthread-stubs-${libpthread_stubs_version}
wget -nc http://xcb.freedesktop.org/dist/libpthread-stubs-0.3.tar.gz
libXau_version='1.0.6'
source_libXau_path=$source_lib_X11_path/libXau-${libXau_version}
wget -nc http://xorg.freedesktop.org/archive/individual/lib/libXau-1.0.6.tar.gz
libxcb_version='1.10'
source_libxcb_path=$source_lib_X11_path/libxcb-${libxcb_version}
wget -nc http://xcb.freedesktop.org/dist/libxcb-1.10.tar.gz
kbproto_version='1.0.5'
source_kbproto_path=$source_lib_X11_path/kbproto-${kbproto_version}
wget -nc http://xorg.freedesktop.org/archive/individual/proto/kbproto-1.0.5.tar.gz
inputproto_version='2.3.1'
source_inputproto_path=$source_lib_X11_path/inputproto-${inputproto_version}
wget -nc http://xorg.freedesktop.org/archive/individual/proto/inputproto-2.3.1.tar.gz
libXpm_version='3.5.11'
source_libXpm_path=$source_lib_X11_path/libXpm-${libXpm_version}
wget -nc http://xorg.freedesktop.org/archive/individual/lib/libXpm-3.5.11.tar.gz
ls *.tar.gz | xargs -n1 tar --no-same-owner -z -x -f
#先安装libX11依赖
if [ ! -d $install_libX11_path ]; then
    mkdir -p $install_libX11_path
    # install xproto
    cd $source_xproto_path
    make clean
    ./configure --prefix=$install_libX11_path
    make && make install
    export PKG_CONFIG_PATH=$install_libX11_path/lib/pkgconfig:$install_libX11_path/share/pkgconfig
    # install xextproto
    cd $source_xextproto_path
    make clean
    ./configure --prefix=$install_libX11_path
    make install
    # install xtrans
    cd $source_xtrans_path
    make clean
    ./configure --prefix=$install_libX11_path
    make && make install
    # install xcb-proto
    cd $source_xcb_proto_path
    make clean
    ./configure --prefix=$install_libX11_path
    make && make install
    # install libpthread-stubs
    cd $source_libpthread_stubs_path
    make clean
    ./configure --prefix=$install_libX11_path
    make && make install
    # install libXau
    cd $source_libXau_path
    make clean
    ./configure --prefix=$install_libX11_path
    make && make install
    # install libxcb
    cd $source_libxcb_path
    make clean
    ./configure --prefix=$install_libX11_path \
        --enable-xkb=no \
        --enable-xv=no
    make && make install
    # install kbproto
    cd $source_kbproto_path
    make clean
    ./configure --prefix=$install_libX11_path
    make && make install
    # install inputproto
    cd $source_inputproto_path
    make clean
    ./configure --prefix=$install_libX11_path
    make && make install
    # install libX11
    cd $source_libX11_path
    make clean
    ./configure --prefix=$install_libX11_path \
        --enable-shared
    make && make install
    # install libXpm
    cd $source_libXpm_path
    make clean
    ./configure --prefix=$install_libX11_path
    make && make install
fi
# install zlib
if [ ! -d $install_zlib_path ]; then
    cd $source_zlib_path
    make clean
    ./configure --prefix=$install_zlib_path
    make && make install
fi
# install libxml2
if [ ! -d $install_libxml_path ]; then
    cd $source_libxml_path
    ./configure --prefix=$install_libxml_path --with-zlib=$install_zlib_path --with-python=no
    make && make install
fi
# install mhash
if [ ! -d $install_mhash_path ]; then
    cd $source_mhash_path
    make clean
    ./configure --prefix=$install_mhash_path
    make && make install
fi
# install pcre
if [ ! -d $install_pcre_path ]; then
    cd $source_pcre_path
    make clean
    ./configure --prefix=$install_pcre_path --enable-utf8
    make && make install
fi
# install libmcrypt
if [ ! -d $install_libmcrypt_path ]; then
    cd $source_libmcrypt_path
    make clean
    ./configure --prefix=$install_libmcrypt_path
    make && make install
    ldconfig && cd libltdl
    make clean
    ./configure --enable-ltdl-install
    make && make install
fi
# install openssl
# if [ ! -d $install_openssl_path ]; then
#     cd $source_openssl_path
#     make clean
#     ./config --prefix=${install_openssl_path} --openssldir=${install_openssl_path}/.openssl --shared
#     make && make install
# fi
# install curl
if [ ! -d $install_curl_path ]; then
    cd $source_curl_path
    make clean
    ./configure --prefix=$install_curl_path \
        --with-zlib=$install_zlib_path \
        #--with-ssl=$install_openssl_path \
        --enable-shared \
        #LIBS="-lssl -lcrypto -L${install_openssl_path}/lib -I${install_openssl_path}/include -Wl,-rpath,${install_openssl_path}/lib"
    make && make install
    ln -s $install_curl_path/bin/curl $install_bin_path/curl
fi
# install ncurses
if [ ! -d $install_ncurses_path ]; then
    cd $source_ncurses_path
    make clean
    ./configure --prefix=$install_ncurses_path --without-debug --enable-widec --with-shared
    make && make install
fi
# install gettext
if [ ! -d $install_gettext_path ]; then
    cd $source_gettext_path
    make clean
    ./configure --prefix=$install_gettext_path \
        --with-libxml2-prefix=$install_libxml_path \
        --with-libncurses-prefix=$install_ncurses_path
    make && make install
    ln -s $install_gettext_path/bin/gettext $install_bin_path/gettext
    ln -s $install_gettext_path/bin/xgettext $install_bin_path/xgettext
fi
# install readline
if [ ! -d $install_readline_path ]; then
    cd $source_readline_path
    make clean
    ./configure --prefix=$install_readline_path --with-curses=$install_ncurses_path --enable-shared
    make && make install
fi
# install libmemcached
if [ ! -d $install_libmemcached_path ]; then
    cd $source_libmemcached_path
    ./configure --prefix=$install_libmemcached_path
    make && make install
fi
# install libevent
if [ ! -d $install_libevent_path ]; then
    cd $source_libevent_path
    ./configure --prefix=$install_libevent_path
    make && make install
fi
# install libgd
#if [ ! -d $install_libgd_path ]; then
#    mkdir -p $install_libgd_path
#    # install freetype
#    cd $source_freetype_path
#    make clean
#    ./configure --prefix=$install_libgd_path
#    make && make install
#    # install jpeg
#    cd $source_jpeg_path
#    make clean
#    ./configure --prefix=$install_libgd_path
#    make && make install
#    # install libpng
#    cd $source_libpng_path
#    make clean
#    ./configure --prefix=$install_libgd_path \
#        CPPFLAGS="-I${install_zlib_path}/include" \
#        LIBS="-L${install_zlib_path}/lib -Wl,-rpath,${install_zlib_path}/lib"
#    make && make install
#    # install libgd
#    cd $source_libgd_path
#    make clean
#    ./configure --prefix=$install_libgd_path \
#        --with-zlib=$install_zlib_path \
#        #--with-freetype=$install_libgd_path \
#        --with-jpeg=$install_libgd_path \
#        --with-png=$install_libgd_path \
#        --with-xpm=$install_libX11_path \
#        CFLAGS="-I${install_zlib_path}/include -I${install_libX11_path}/include" \
#        LIBS="-L${install_zlib_path}/lib -Wl,-rpath,${install_zlib_path}/lib -L${install_libX11_path}/lib -Wl,-rpath,${install_libX11_path}/lib"
#    make && make install
#fi
# install valgrind
if [ $mode -eq 2 ]; then
    cd $source_path
    wget -nc http://www.valgrind.org/downloads/valgrind-3.11.0.tar.bz2
    tar xjf valgrind-*.tar.bz2
    cd $source_path/valgrind-*
    if [ ! -d $install_lib_path/$(basename $PWD) ]; then
        make clean
        ./configure --prefix=$install_lib_path/$(basename $PWD)
        make && make install
        ln $install_lib_path/$(basename $PWD)/bin/valgrind /usr/local/bin/valgrind
    fi
fi

function compilePhpExtension
{
    extention_name=$1;
    extention_filename=$2;
    mode=$3;
    if [ ! -d "$source_lib_php_ext_path" ]; then
        echo $source_lib_php_ext_path" not exists";
        exit 1;
    fi
    cd $source_lib_php_ext_path;
    wget -nc http://pecl.php.net/get/${extention_filename}.tgz
    tar zxf ${extention_filename}.tgz
    cd $source_lib_php_ext_path/${extention_filename}
    $install_php_path/bin/phpize
    case ${extention_name} in
        apcu)
            #php-apcu
            ./configure --with-php-config=$install_php_path/bin/php-config --enable-apcu
            ;;
        memcached)
            #php-memcached
            ./configure --with-php-config=$install_php_path/bin/php-config \
                --with-libmemcached-dir=$install_libmemcached_path \
                --with-zlib-dir=$install_zlib_path \
                --enable-memcached \
                --disable-memcached-sasl
            ;;
        redis)
            #php-redis
            ./configure --with-php-config=$install_php_path/bin/php-config --enable-redis
            make && make install
            ;;
        stomp)
            #php-stomp
            ./configure --with-php-config=$install_php_path/bin/php-config \
                #--with-openssl-dir=$install_openssl_path \
                --enable-stomp
            ;;
        msgpack)
            #php-msgpack
            ./configure --with-php-config=$install_php_path/bin/php-config --with-msgpack
            ;;
        yaf)
            #php-yaf
            if [ $mode -eq 1 ]; then
                ./configure --with-php-config=$install_php_path/bin/php-config --enable-yaf
            elif [ $mode -eq 2 ]; then
                ./configure --with-php-config=$install_php_path/bin/php-config --enable-yaf --enable-yaf-debug
            fi
            ;;
        yar)
            #php-yar
            ./configure --with-php-config=$install_php_path/bin/php-config \
                --with-curl=$install_curl_path \
                --enable-yar \
                --enable-msgpack
            ;;
        yac)
            #php-yac
            ./configure --with-php-config=$install_php_path/bin/php-config --enable-yac
            ;;
        gd)
            #php-gd
            ./configure --with-gd=$install_libgd_path \
                --with-zlib-dir=$install_zlib_path \
                --with-freetype-dir=$install_libgd_path \
                --with-jpeg-dir=$install_libgd_path \
                --with-png-dir=$install_libgd_path \
                --with-xpm-dir=$install_libX11_path \
                CFLAGS="-I$install_libX11_path/include" \
                LIBS="-L$install_libX11_path/lib -Wl,-rpath,$install_libX11_path/lib"
            ;;
        raphf)
            #php-http-raphf
            ./configure --with-php-config=$install_php_path/bin/php-config
            ;;
        propro)
            #php-http-propro
            ./configure --with-php-config=$install_php_path/bin/php-config
            ;;
        http)
            #php-http
            ./configure --with-php-config=$install_php_path/bin/php-config \
                --with-http-zlib-dir=$install_zlib_path \
                --with-http-libcurl-dir=$install_curl_path \
                --with-http-libevent-dir=$install_libevent_path
            ;;
        vld)
            #php-vld
            ./configure --with-php-config=$install_php_path/bin/php-config --enable-vld
            ;;
        swoole)
            #php-swoole
            ./configure --with-php-config=$install_php_path/bin/php-config
            ;;
    esac
    make && make install
}
# install mysql
if [ $mysql == "y" ];then
    mysql_version="5.7.16"
    $PM -y install bison
    useradd -M -s /sbin/nologin mysql
    mkdir -p $var_data_path/mysql
    chown mysql.mysql -R $var_data_path/mysql
    cd $source_path;
    wget -nc http://fossies.org/linux/misc/mysql-${mysql_version}.tar.gz
    tar zxf mysql-${mysql_version}.tar.gz
    cd $source_path/mysql-${mysql_version}
    install_mysql_path=$install_lib_path/$(basename $PWD)
    mysql_cmake_option="-DCMAKE_INSTALL_PREFIX=$install_mysql_path"
    if [ -d $install_ncurses_path ]; then
        mysql_cmake_option=$mysql_cmake_option" -DCURSES_LIBRARY=${install_ncurses_path}/lib/libncursesw.so -DCURSES_LIBRARY=${install_ncurses_path}/lib/libncursesw.so -DCURSES_INCLUDE_PATH=${install_ncurses_path}/include"
    fi
    mysql_cmake_option=$mysql_cmake_option"
        -DSYSCONFDIR=${install_mysql_path}/etc \
        -DMYSQL_DATADIR=${var_data_path}/mysql  \
        -DMYSQL_UNIX_ADDR=${var_run_path}/mysqld.sock \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DENABLED_LOCAL_INFILE=1 \
        -DMYSQL_TCP_PORT=3306 \
        -DEXTRA_CHARSETS=all \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci \
        -DMYSQL_UNIX_ADDR=${var_run_path}/mysql.sock \
        -DDOWNLOAD_BOOST=1 \
        -DWITH_BOOST=${source_lib_path}/boost
    "
    ###
    # cmake -DCMAKE_INSTALL_PREFIX=$install_mysql_path \
    # -DCURSES_LIBRARY=/home/work/local/ncurses-5.9/lib/libncursesw.so \
    # -DCURSES_INCLUDE_PATH=/home/work/local/ncurses-5.9/include \
    # -DSYSCONFDIR=/home/work/mysql/etc \
    # -DMYSQL_DATADIR=/home/work/var/data/mysql  \
    # -DMYSQL_UNIX_ADDR=/home/work/var/run/mysqld.sock \
    # -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    # -DENABLED_LOCAL_INFILE=1 \
    # -DMYSQL_TCP_PORT=3306 \
    # -DEXTRA_CHARSETS=all \
    # -DDEFAULT_CHARSET=utf8 \
    # -DDEFAULT_COLLATION=utf8_general_ci \
    # -DMYSQL_UNIX_ADDR=/home/work/var/run/mysql.sock \
    # -DDOWNLOAD_BOOST=1 \
    # -DWITH_BOOST=/home/work/boost \
    # -DWITH_DEBUG=0
    ###
    if [ $mode -eq 1 ]; then
        mysql_cmake_option=$mysql_cmake_option" -DWITH_DEBUG=0"
    elif [ $mode -eq 2 ]; then
        mysql_cmake_option=$mysql_cmake_option" -DWITH_DEBUG=1"
    fi
    cmake . $mysql_cmake_option
    make && make install
    \cp -f $install_mysql_path/support-files/my-default.cnf $install_mysql_path/etc/my.cnf
    \cp -f $install_mysql_path/support-files/mysql.server /etc/init.d/mysqld
    chmod 755 /etc/init.d/mysqld
    chkconfig --add mysqld
    chkconfig mysqld on

    # Modify my.cnf
    sed -i "31a " $install_mysql_path/etc/my.cnf
    sed -i "32a ##############" $install_mysql_path/etc/my.cnf
    sed -i "33a skip-name-resolve" $install_mysql_path/etc/my.cnf
    sed -i "34a basedir=${install_mysql_path}" $install_mysql_path/etc/my.cnf
    sed -i "35a datadir=${var_data_path}/mysql" $install_mysql_path/etc/my.cnf
    sed -i "36a user=mysql" $install_mysql_path/etc/my.cnf
    sed -i "37a #lower_case_table_names = 1" $install_mysql_path/etc/my.cnf
    sed -i "38a max_connections=1000" $install_mysql_path/etc/my.cnf
    sed -i "39a ft_min_word_len=1" $install_mysql_path/etc/my.cnf
    sed -i "40a expire_logs_days = 7" $install_mysql_path/etc/my.cnf
    sed -i "41a query_cache_size=64M" $install_mysql_path/etc/my.cnf
    sed -i "42a query_cache_type=1" $install_mysql_path/etc/my.cnf
    sed -i "43a explicit_defaults_for_timestamp=true"  $install_mysql_path/etc/my.cnf
    sed -i "44a ##############" $install_mysql_path/etc/my.cnf

    #if [ `getconf WORD_BIT` == '32' ] && [ `getconf LONG_BIT` == '64' ] ; then
    #    ln -s $install_mysql_path/lib/libmysqlclient.so.18 /lib64/libmysqlclient.so.18
    #else
    #    ln -s $install_mysql_path/lib/libmysqlclient.so.18 /lib/libmysqlclient.so.18
    #fi
    $install_mysql_path/bin/mysqld --initialize --user=mysql --basedir=$install_mysql_path --datadir=$var_data_path/mysql
    chown mysql.mysql -R $var_data_path/mysql
    service mysqld start
    export PATH=$PATH:$install_mysql_path/bin
    echo 'export PATH=$PATH:'$install_mysql_path'/bin' >> /etc/profile
    source /etc/profile
    $install_mysql_path/bin/mysql -e "grant all privileges on *.* to root@'localhost' identified by \"$mysqlrootpwd\" with grant option;"
    $install_mysql_path/bin/mysql -uroot -p$mysqlrootpwd -e "delete from mysql.user where Password='';"
    service mysqld restart
fi

#install php
if [ $php == "y" ];then
    for php_version_id in "${!php_version[@]}"
    do
        cd $source_path
        wget -nc http://cn2.php.net/distributions/php-${php_version[$php_version_id]}.tar.gz
        tar xzf php-${php_version[$php_version_id]}.tar.gz
        cd $source_path/php-${php_version[$php_version_id]}
        install_php_path=$install_lib_path/$(basename $PWD)
        php_configure_option="--prefix=$install_php_path \
            --with-config-file-path=$install_php_path/etc \
            --with-mysqli=mysqlnd \
            --with-pdo-mysql=mysqlnd \
            --with-xmlrpc \
            --with-iconv \
            --without-pear \
            --enable-cgi \
            --enable-cli \
            --enable-fpm \
            --enable-mysqlnd \
            --enable-pcntl \
            --enable-mbstring \
            --enable-sockets \
            --enable-bcmath \
            --enable-shmop \
            --enable-soap \
            --enable-wddx \
            --enable-sysvsem \
            --enable-sysvshm \
            --enable-sysvmsg"
        if [ -d $install_libxml_path ]; then
            php_configure_option=$php_configure_option" --with-libxml-dir=$install_libxml_path"
        fi
        if [ -d $install_zlib_path ]; then
            php_configure_option=$php_configure_option" --with-zlib-dir=$install_zlib_path"
        fi
        if [ -d $install_curl_path ]; then
            php_configure_option=$php_configure_option" --with-curl=$install_curl_path"
        fi
        if [ -d $install_openssl_path ]; then
            php_configure_option=$php_configure_option" --with-openssl=$install_openssl_path"
        fi
        if [ -d $install_mhash_path ]; then
            php_configure_option=$php_configure_option" --with-mhash=$install_mhash_path"
        fi
        if [ -d $install_gettext_path ]; then
            php_configure_option=$php_configure_option" --with-gettext=$install_gettext_path"
        fi
        if [ -d $install_libmcrypt_path ]; then
            php_configure_option=$php_configure_option" --with-mcrypt=$install_libmcrypt_path"
        fi
        if [ -d $install_readline_path ]; then
            php_configure_option=$php_configure_option" --with-readline=$install_readline_path"
        fi
        if [ -d $install_libgd_path ]; then
            php_configure_option=$php_configure_option" --with-freetype-dir=$install_libgd_path"
        fi
        echo $php_version_id;
        if [ $mode -eq 1 ]; then
            php_configure_option=$php_configure_option" --disable-debug"
            case $php_version_id in
                55)
                    echo $install_lib_path > /etc/ld.so.conf.d/local.conf && ldconfig
                    php_configure_option=$php_configure_option" --with-mysql=mysqlnd --enable-opcache"
                    ;;
                56)
                    php_configure_option=$php_configure_option" --with-mysql=mysqlnd --enable-opcache"
                    ;;
                70)
                    php_configure_option=$php_configure_option" --enable-opcache=yes"
                    ;;
                71)
                    php_configure_option=$php_configure_option" --enable-opcache=yes"
                    ;;
            esac
        elif [ $mode -eq 2 ];then
            php_configure_option=$php_configure_option" --enable-debug --enable-maintainer-zts"
            case $php_version_id in
                55)
                    echo $install_lib_path > /etc/ld.so.conf.d/local.conf && ldconfig
                    php_configure_option=$php_configure_option" --with-mysql=mysqlnd --disable-opcache"
                    ;;
                56)
                    php_configure_option=$php_configure_option" --with-mysql=mysqlnd --disable-opcache"
                    ;;
                70)
                    php_configure_option=$php_configure_option" --enable-opcache=no"
                    ;;
                71)
                    php_configure_option=$php_configure_option" --enable-opcache=no"
                    ;;
            esac
        fi
        if [ -d $install_openssl_path ]; then
            php_configure_option=$php_configure_option" LIBS=\"-lssl -lcrypto -L${install_openssl_path}/lib -I${install_openssl_path}/include -Wl,-rpath,${install_openssl_path}/lib\""
        fi
        ##########
        # ./configure --prefix=/home/work/local/php-7.0.12 \
        # --with-config-file-path=/home/work/local/php-7.0.12/etc \
        # --with-mysqli=mysqlnd \
        # --with-pdo-mysql=mysqlnd \
        # --with-libxml-dir=/home/work/local/libxml2-2.9.3 \
        # --with-zlib-dir=/home/work/local/zlib-1.2.8 \
        # --with-curl=/home/work/local/curl-7.45.0 \
        # --with-openssl=/home/work/local/openssl-1_0_2j \
        # --with-mhash=/home/work/local/mhash-0.9.9.9 \
        # --with-gettext=/home/work/local/gettext-0.19.5.1 \
        # --with-mcrypt=/home/work/local/libmcrypt-2.5.7 \
        # --with-readline=/home/work/local/readline-6.3 \
        # --with-freetype-dir=/home/work/local/libgd-2.1.0 \
        # --with-xmlrpc \
        # --with-iconv \
        # --without-pear \
        # --enable-cgi \
        # --enable-cli \
        # --enable-fpm \
        # --enable-mysqlnd \
        # --enable-pcntl \
        # --enable-mbstring \
        # --enable-sockets \
        # --enable-bcmath \
        # --enable-shmop \
        # --enable-soap \
        # --enable-wddx \
        # --enable-sysvsem \
        # --enable-sysvshm \
        # --enable-sysvmsg \
        # --enable-debug \
        # --enable-maintainer-zts \
        # --enable-opcache=no \
        # LIBS="-lssl -lcrypto -L/home/work/local/openssl-1_0_2j/lib -I/home/work/local/openssl-1_0_2j/include -Wl,-rpath,/home/work/local/openssl-1_0_2j/lib"
        ##########
        make clean
        autoconf
        ./configure $php_configure_option
        make && make install
        if [ $mode -eq 1 ]; then
            \cp php.ini-production $install_php_path/etc/php.ini
        elif [ $mode -eq 2 ];then
            \cp php.ini-development $install_php_path/etc/php.ini
        fi
        #php-fpm Init Script
        \cp sapi/fpm/init.d.php-fpm /etc/init.d/php$php_version_id-fpm
        sed -i "s@php_fpm_PID=$\{prefix\}/var/run/php-fpm.pid@php_fpm_PID=${var_run_path}/php-fpm.pid@g" /etc/init.d/php$php_version_id-fpm
        chmod +x /etc/init.d/php$php_version_id-fpm
        if [[ $DISTRO == "CentOS" ]]; then
            chkconfig --add php$php_version_id-fpm
            chkconfig php$php_version_id-fpm on
        fi
        #ln php-fpm
        ln -s /etc/init.d/php$php_version_id-fpm /etc/init.d/php-fpm
        chmod +x /etc/init.d/php-fpm
        if [[ $DISTRO == "CentOS" ]]; then
            chkconfig --add php-fpm
            chkconfig php-fpm on
        fi
        #ln php
        unlink $install_bin_path/php$php_version_id
        ln -s $install_php_path/bin/php $install_bin_path/php$php_version_id
        ln -s $install_bin_path/php$php_version_id $install_bin_path/php
        # Modify php.ini
        case $php_version_id in
            55)
                start_line=898;
                if [ $mode -eq 1 ]; then
                    sed -i "${start_line}a extension_dir = \"$install_php_path/lib/php/extensions/no-debug-non-zts-20121212/\"" $install_php_path/etc/php.ini
                elif [ $mode -eq 2 ]; then
                    sed -i "${start_line}a extension_dir = \"$install_php_path/lib/php/extensions/debug-zts-20121212/\"" $install_php_path/etc/php.ini
                fi
                php_extensions[0]='apcu:apcu-4.0.7'
                php_extensions[1]='memcached:memcached-2.2.0'
                php_extensions[2]='redis:redis-2.2.7'
                php_extensions[3]='stomp:stomp-1.0.8'
                php_extensions[4]='msgpack:msgpack-0.5.7'
                php_extensions[5]='raphf:raphf-1.1.0'
                php_extensions[6]='propro:propro-1.0.0'
                php_extensions[7]='http:pecl_http-2.5.5'
                php_extensions[8]='vld:vld-0.13.0'
                php_extensions[9]='yaf:yaf-2.3.5'
                php_extensions[10]='yar:yar-1.2.4'
                php_extensions[11]='yac:yac-0.9.2'
                for php_extension in ${php_extensions[@]}; do
                    php_extension_info=(${php_extension//:/ })
                    compilePhpExtension ${php_extension_info[0]} ${php_extension_info[1]} $mode
                    start_line=`expr $start_line + 1`
                    sed -i "${start_line}a extension = ${php_extension_info[0]}.so" $install_php_path/etc/php.ini
                done
                sed -i 's@;cgi.fix_pathinfo=1@cgi.fix_pathinfo=0@g' $install_php_path/etc/php.ini
                sed -i 's@expose_php = On@expose_php = Off@g' $install_php_path/etc/php.ini
                sed -i 's@;date.timezone =@date.timezone = Asia/Shanghai@g' $install_php_path/etc/php.ini
                ;;
            56)
                start_line=915;
                if [ $mode -eq 1 ]; then
                    sed -i "${start_line}a extension_dir = \"$install_php_path/lib/php/extensions/no-debug-non-zts-20131226/\"" $install_php_path/etc/php.ini
                elif [ $mode -eq 2 ]; then
                    sed -i "${start_line}a extension_dir = \"$install_php_path/lib/php/extensions/debug-zts-20131226/\"" $install_php_path/etc/php.ini
                fi
                php_extensions[0]='apcu:apcu-4.0.7'
                php_extensions[1]='memcached:memcached-2.2.0'
                php_extensions[2]='redis:redis-2.2.7'
                php_extensions[3]='stomp:stomp-1.0.8'
                php_extensions[4]='msgpack:msgpack-0.5.7'
                php_extensions[5]='raphf:raphf-1.1.0'
                php_extensions[6]='propro:propro-1.0.0'
                php_extensions[7]='http:pecl_http-2.5.5'
                php_extensions[8]='vld:vld-0.13.0'
                php_extensions[9]='yaf:yaf-2.3.5'
                php_extensions[10]='yar:yar-1.2.4'
                php_extensions[11]='yac:yac-0.9.2'
                if [ $php_swoole == 'y' ]; then
                    php_extensions[12]='swoole:swoole-1.7.21'
                fi
                for php_extension in ${php_extensions[@]}; do
                    php_extension_info=(${php_extension//:/ })
                    compilePhpExtension ${php_extension_info[0]} ${php_extension_info[1]} $mode
                    start_line=`expr $start_line + 1`
                    sed -i "${start_line}a extension = ${php_extension_info[0]}.so" $install_php_path/etc/php.ini
                done
                sed -i 's@;cgi.fix_pathinfo=1@cgi.fix_pathinfo=0@g' $install_php_path/etc/php.ini
                sed -i 's@expose_php = On@expose_php = Off@g' $install_php_path/etc/php.ini
                sed -i 's@;date.timezone =@date.timezone = Asia/Shanghai@g' $install_php_path/etc/php.ini
                ;;
            70)
                start_line=900;
                if [ $mode -eq 1 ]; then
                    sed -i "${start_line}a extension_dir = \"$install_php_path/lib/php/extensions/no-debug-non-zts-20151012/\"" $install_php_path/etc/php.ini
                elif [ $mode -eq 2 ]; then
                    sed -i "${start_line}a extension_dir = \"$install_php_path/lib/php/extensions/debug-zts-20151012/\"" $install_php_path/etc/php.ini
                fi
                php_extensions[0]='apcu:apcu-5.1.2'
                php_extensions[1]='yaf:yaf-3.0.1'
                php_extensions[2]='yac:yac-2.0.0'
                if [ $php_swoole == 'y' ]; then
                    php_extensions[3]='swoole:swoole-1.7.21'
                fi
                for php_extension in ${php_extensions[@]}; do
                    php_extension_info=(${php_extension//:/ })
                    compilePhpExtension ${php_extension_info[0]} ${php_extension_info[1]} $mode
                    start_line=`expr $start_line + 1`
                    sed -i "${start_line}a extension = ${php_extension_info[0]}.so" $install_php_path/etc/php.ini
                done
                sed -i 's@;cgi.fix_pathinfo=1@cgi.fix_pathinfo=0@g' $install_php_path/etc/php.ini
                sed -i 's@expose_php = On@expose_php = Off@g' $install_php_path/etc/php.ini
                sed -i 's@;date.timezone =@date.timezone = Asia/Shanghai@g' $install_php_path/etc/php.ini
                ;;
            71)
                start_line=927;
                if [ $mode -eq 1 ]; then
                    sed -i "${start_line}a extension_dir = \"$install_php_path/lib/php/extensions/no-debug-non-zts-20160303/\"" $install_php_path/etc/php.ini
                elif [ $mode -eq 2 ]; then
                    sed -i "${start_line}a extension_dir = \"$install_php_path/lib/php/extensions/debug-zts-20160303/\"" $install_php_path/etc/php.ini
                fi
                php_extensions[0]='apcu:apcu-5.1.2'
                php_extensions[1]='yaf:yaf-3.0.4'
                php_extensions[2]='yac:yac-2.0.1'
                if [ $php_swoole == 'y' ]; then
                    php_extensions[3]='swoole:swoole-1.7.21'
                fi
                for php_extension in ${php_extensions[@]}; do
                    php_extension_info=(${php_extension//:/ })
                    compilePhpExtension ${php_extension_info[0]} ${php_extension_info[1]} $mode
                    start_line=`expr $start_line + 1`
                    sed -i "${start_line}a extension = ${php_extension_info[0]}.so" $install_php_path/etc/php.ini
                done
                sed -i 's@;cgi.fix_pathinfo=1@cgi.fix_pathinfo=0@g' $install_php_path/etc/php.ini
                sed -i 's@expose_php = On@expose_php = Off@g' $install_php_path/etc/php.ini
                sed -i 's@;date.timezone =@date.timezone = Asia/Shanghai@g' $install_php_path/etc/php.ini
                ;;
        esac
        # Build PHP-FPM Configuration
        \cp $current_path/conf/php-fpm.conf $install_php_path/etc/php-fpm.conf
        php_fpm_log=$var_log_path/php-fpm.log
        php_fpm_slow_log=$var_log_path/php-fpm.slow.log
        php_fpm_pid=$var_run_path/php-fpm.pid
        php_fpm_sock=$var_run_path/php.sock
        sed -i 's@::pid::@'$php_fpm_pid'@g' $install_php_path/etc/php-fpm.conf
        sed -i 's@::slow_log::@'$php_fpm_slow_log'@g' $install_php_path/etc/php-fpm.conf
        sed -i 's@::log::@'$php_fpm_log'@g' $install_php_path/etc/php-fpm.conf
        sed -i 's@::sock::@'$php_fpm_sock'@g' $install_php_path/etc/php-fpm.conf
        #php-fpm start
        service php$php_version_id-fpm start
    done
fi

# install Nginx
if [[ $nginx == "y" ]];then
    cd $source_openssl_path
    make clean
    make && make install
    if [[ $openresty == "y" ]];then
        lua_version="5.3.2"
        cd $source_path
        wget -nc http://www.lua.org/ftp/lua-${lua_version}.tar.gz
        tar zxf lua-${lua_version}.tar.gz
        cd lua-${lua_version}
        install_lua_path=$install_lib_path/$(basename $PWD)
        lua_configure_option="--prefix=$install_lua_path \
            "
        ./configure $lua_configure_option
        make && make install

        openresty_version="1.9.3.2"
        openresty_error_log=$var_log_path/openresty.error.log
        openresty_access_log=$var_log_path/openresty.access.log
        openresty_pid=$var_run_path/openresty.pid
        cd $source_path
        wget -nc https://openresty.org/download/ngx_openresty-${openresty_version}.tar.gz
        tar xzf ngx_openresty-${openresty_version}.tar.gz
        cd $source_path/ngx_openresty-${openresty_version}
        install_openresty_path=$install_lib_path"/openresty-${openresty_version}"
        openresty_configure_option="--prefix=$install_openresty_path \
            --user=work \
            --group=work \
            --pid-path=${openresty_pid} \
            --http-log-path=${openresty_access_log} \
            --error-log-path=${openresty_error_log} \
            --with-http_gzip_static_module \
            --with-http_stub_status_module"
        if [ -d $source_pcre_path ]; then
            openresty_configure_option=$openresty_configure_option" --with-pcre=$source_pcre_path --with-pcre-jit"
        fi
        if [ -d $source_zlib_path ]; then
            openresty_configure_option=$openresty_configure_option" --with-zlib=$source_zlib_path"
        fi
        if [ -d $source_openssl_path ]; then
            openresty_configure_option=$openresty_configure_option" --with-openssl=$source_openssl_path --with-http_ssl_module"
        fi
        ./configure $openresty_configure_option
        make && make install
        cd $install_openresty_path
    else
        nginx_version="1.8.0"
        nginx_error_log=$var_log_path/nginx.error.log
        nginx_access_log=$var_log_path/nginx.access.log
        nginx_pid_file=$var_run_path/nginx.pid
        cd $source_path
        wget -nc http://nginx.org/download/nginx-${nginx_version}.tar.gz
        tar xzf nginx-${nginx_version}.tar.gz
        cd $source_path/nginx-${nginx_version}
        install_nginx_path=$install_lib_path"/nginx-${nginx_version}"
        nginx_configure_option="--prefix=$install_nginx_path \
            --user=work \
            --group=work \
            --pid-path=${openresty_pid} \
            --http-log-path=${openresty_access_log} \
            --error-log-path=${openresty_error_log} \
            --with-http_gzip_static_module \
            --with-http_stub_status_module"
        if [ -d $source_pcre_path ]; then
            openresty_configure_option=$openresty_configure_option" --with-pcre=$source_pcre_path --with-pcre-jit"
        fi
        if [ -d $source_zlib_path ]; then
            openresty_configure_option=$openresty_configure_option" --with-zlib=$source_zlib_path"
        fi
        if [ -d $source_openssl_path ]; then
            openresty_configure_option=$openresty_configure_option" --with-openssl=$source_openssl_path --with-http_ssl_module"
        fi
        ./configure $nginx_configure_option
        make && make install
        cd $install_nginx_path
    fi
    #nginx systemd
    \cp $current_path/init.d/nginx /etc/init.d/nginx
    chmod 755 /etc/init.d/nginx
    sed -i 's@::nginx_path::@'$install_nginx_path'@g' /etc/init.d/nginx
    sed -i 's@::pid_file::@'$nginx_pid_file'@g' /etc/init.d/nginx
    chkconfig --add nginx
    chkconfig nginx on
    #nginx conf
    mv conf/nginx.conf conf/nginx.conf_default
    \cp $current_path/conf/nginx.conf conf/nginx.conf
    sed -i 's@::user::@work@g' conf/nginx.conf
    sed -i 's@::group::@work@g' conf/nginx.conf
    sed -i 's@::pid_file::@'$nginx_pid_file'@g' conf/nginx.conf
    sed -i 's@::error_log::@'$nginx_error_log'@g' conf/nginx.conf
    sed -i 's@::access_log::@'$nginx_access_log'@g' conf/nginx.conf
    sed -i 's@::sock::@'$var_run_path'/php.sock@g' conf/nginx.conf
    \cp -R $current_path/conf/vhost conf
    service nginx restart

    #logrotate nginx log
    \cp $current_path/conf/logrotate.d/nginx.conf /etc/logrotate.d/nginx.conf
    sed -i 's@::pid_file::@'$nginx_pid_file'@g' /etc/logrotate.d/nginx.conf
    sed -i 's@::var_log_path::@'$var_log_path'@g' /etc/logrotate.d/nginx.conf
fi

# install Memcached
if [[ $memcached == "y" ]];then
    memcached_version="1.4.24"
    cd $source_path
    wget -nc http://memcached.org/files/memcached-${memcached_version}.tar.gz
    tar zxf memcached-${memcached_version}.tar.gz
    cd $source_path/memcached-${memcached_version}
    install_memcached_path=$install_lib_path/$(basename $PWD)
    memcached_configure_option="--prefix=$install_memcached_path"
    ./configure $memcached_configure_option
    make && make install
    sed -i "s@ExecStart=/usr/bin/memcached@ExecStart=$install_memcached_path@g" scripts/memcached.service
    \cp scripts/memcached.sysv /etc/init.d/memcached
    \cp scripts/memcached.service /etc/systemd/system
    chmod 755 /etc/init.d/memcached
    chkconfig --add memcached
    chkconfig memcached on

    cat $current_path/conf/memcached.conf > /etc/sysconfig/memcached
fi

# install Redis
if [[ $redis == "y" ]];then
    redis_version="3.0.5"
    cd $source_path
    wget -nc http://download.redis.io/releases/redis-${redis_version}.tar.gz
    if [ -e $source_path/redis-${redis_version} ]; then
      tar zxf redis-${redis_version}.tar.gz
    fi
    cd $source_path/redis-${redis_version}
    install_redis_path=$install_lib_path/$(basename $PWD)
    redis_make_option="PREFIX=$install_redis_path"
    make && make $redis_make_option install
    redis_pid_file=$var_run_path/redis.pid
    redis_log_file=$var_log_path/redis.log
    redis_data_path=$var_data_path
    \cp $current_path/conf/redis.conf $install_redis_path/redis.conf
    sed -i 's@::log_file::@"'$redis_log_file'"@g' $install_redis_path/redis.conf
    sed -i 's@::pid_file::@"'$redis_pid_file'"@g' $install_redis_path/redis.conf
    sed -i 's@::data_dir::@'$redis_data_path'@g' $install_redis_path/redis.conf
fi

#install tools
if [ ! -e $install_path"/tools" ]; then
    mkdir -p $install_path/tools
fi
chmod +x $install_path/tools/*

cd ../
echo "################Congratulations####################"
echo "The path of some dirs:"
if [ $nginx -a $nginx == "y" ];then
    if [ $openresty == "y" ]; then
        if [ -d $install_openresty_path ]; then
            echo "Openresty dir: $install_openresty_path"
        else
            echo "Openresty install error...configure option:
            ./configure $openresty_configure_option"
        fi
    else
        if [ -d $install_nginx_path ]; then
            echo "Nginx dir:"$install_nginx_path
        else
            echo "Nginx install error...configure option:
            ./configure $nginx_configure_option"
        fi
    fi
fi
if [ $mysql -a $mysql == "y" ];then
    if [ -d $install_mysql_path ]; then
        echo "MySQL dir: $install_mysql_path"
        echo "MySQL Password: $mysqlrootpwd"
    else
        echo "Mysql install error...cmake option:
        cmake . $mysql_cmake_option"
    fi
fi
if [ $php -a $php == "y" ];then
    if [ -d $install_php_path ]; then
        echo "PHP dir: $install_php_path"
    else
        echo "PHP install error...configure option:
        ./configure $php_configure_option"
    fi
fi
if [ $memcached -a $memcached == "y" ];then
    if [ -d $install_memcached_path ]; then
        echo "Memcached dir: $install_memcached_path"
    else
        echo "Memcached install error...configure option:
        ./configure $memcached_configure_option"
    fi
fi
if [ $redis -a $redis == "y" ];then
    if [ -d $install_redis_path ]; then
        echo "Redis dir: $install_redis_path"
    else
        echo "Redis install error...configure option:
        make && make $redis_make_option install"
    fi
fi
echo "The operation tools dir: $install_path/tools"
echo "###################################################"
