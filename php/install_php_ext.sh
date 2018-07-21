#!/bin/bash
function help() {
        echo "[help]
-p      set extension source code path
-e      set extension name
-m      enable debug
-f      set test files
-d      set test directories";
}
function input() {
    php_path=$(ls $php_install_path | grep php)
    index=0
    php_version_str=""
    for path in $php_path; do
        tmp_php_version=$(echo $($php_install_path/$path/bin/php -v) | grep -oP "(?<=PHP )[0-9\.]+");
        #php_versions[$index]=$(echo $tmp_php_version | grep -oP "\d+(?=.)\d+" )
        tmp_php_version_arr=$(echo ${tmp_php_version} | tr "." " ")
        tmp_php_version_arr=($tmp_php_version_arr)
        if [ ${tmp_php_version_arr[1]} -eq 0 ]; then
            php_versions=$php_versions" "${tmp_php_version_arr[0]}"|"${tmp_php_version}
            if [ $index = 0 ]; then
                php_version_str=${tmp_php_version_arr[0]}"("${tmp_php_version}")"
            else
                php_version_str=$php_version_str" / "${tmp_php_version_arr[0]}"("${tmp_php_version}")"
            fi
        else
            php_versions=$php_versions" "${tmp_php_version_arr[0]}${tmp_php_version_arr[1]}"|"${tmp_php_version}
            if [ $index = 0 ]; then
                php_version_str=${tmp_php_version_arr[0]}${tmp_php_version_arr[1]}"("${tmp_php_version}")"
            else
                php_version_str=$php_version_str" / "${tmp_php_version_arr[0]}${tmp_php_version_arr[1]}"("${tmp_php_version}")"
            fi
        fi
        index=$index+1;
    done;
    php_v=0
    php_version=""
    while :
    do
        read -p "PHP version to install [$php_version_str]:" php_v
	    # Select php version
        for php_version_item in $php_versions; do
            php_version_item_arr=$(echo ${php_version_item} | tr "|" " ")
            php_version_item_arr=($php_version_item_arr)
            if [[ "${php_version_item_arr[0]}" == "$php_v" ]]; then
                php_v=${php_version_item_arr[0]}
                php_version=${php_version_item_arr[1]}
                break;
            else
                continue;
            fi
        done;
        if [[ $php_version != "" ]]; then
	        break
	    fi
    done
}
function install() {
    php_path=$php_install_path"/php"$php_v
    if [ ! -d "$php_path" ]; then
        echo "$php_path is not an exist folder"
        exit 1;
    fi
    ext_path=$(cd "$(dirname "$0")"; cd ..; pwd)"/init/lnmp/source/php-$php_version/ext/"$2;
    if [ ! -d "$ext_path" ]; then
        mkdir $ext_path
    fi
    \cp -R $1/* $ext_path
    cd $ext_path
    make clean > /dev/null
    $php_path/bin/phpize &&
    ./configure --with-php-config=$php_path/bin/php-config --with-$2 --enable-$2
    make && make install
    export TEST_PHP_EXECUTABLE=$php_path/bin/php &&
	if [ 3 -eq 1 ]; then
        $php_path/bin/php ../../run-tests.php -q -m --show-exp --show-out $4 $5
	else
        $php_path/bin/php ../../run-tests.php -q --show-exp --show-out $4 $5
    fi
}
while getopts "p:e:m:f:d:" arg
do
    case $arg in
        p)
            extpath=$OPTARG
            ;;
        e)
            extname=$OPTARG
            ;;
		m)
		    debug=1
			;;
        f)
            test_files=$OPTARG
            ;;
        d)
            test_directories=$OPTARG
            ;;
        ?)
            help
            exit 1;
            ;;
    esac
done
# debug is too slow
debug=0
php_install_path=/usr/local
input $php_install_path
install $extpath $extname $debug $test_files $test_directories
