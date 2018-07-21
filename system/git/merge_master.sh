while getopts b: opt 
do 
    case $opt in
	b) branch=$OPTARG ;;
    esac
done
while :
do
    if [ $branch ];then
        break;
    else
        read -p "input yor branch name:" branch
    fi
done
git checkout master
git pull upstream master
git checkout $branch
git rebase master
git push origin $branch
