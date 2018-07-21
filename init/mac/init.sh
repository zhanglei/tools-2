#!/bin/bash
function storage_work
{
  host=$1
  port=22
  if [ "$2" != "" ]; then
    port=$2
  fi
  tmux new -s init -d # 后台创建一个名称为init的会话

  tmux new-window -c "storage" -t init
  # 默认上下分屏
  tmux split-window -c "storage" -t init
  tmux split-window -c "storage" -t init
  tmux setw synchronize-panes
  tmux send -t init "ssh -p $port work@$host" Enter
}
function media_work
{
  host=$1
  port=22
  if [ "$2" != "" ]; then
    port=$2
  fi
  tmux new -s init -d # 后台创建一个名称为init的会话

  tmux new-window -c "media" -t init
  # 默认上下分屏
  tmux split-window -c "media" -t init
  tmux split-window -c "media" -t init
  tmux setw synchronize-panes
  tmux send -t init "ssh -p $port work@$host" Enter
}
case $1 in
  media)
    media_work
    ;;
  storage)
    storage_work
    ;;
  *)
    echo "usage: source $0 media|storage"
    exit 1
    ;;
esac

function mount_disk
{
  sudo mount -t nfs 192.168.50.121:/video ~/Documents/Diskstation/video
  sudo mount -t nfs 192.168.50.121:/private ~/Documents/Diskstation/private
  sudo mount -t nfs 192.168.50.121:/music ~/Documents/Diskstation/music
  sudo mount -t nfs 192.168.50.121:/software ~/Documents/Diskstation/software
  sudo mount -t nfs 192.168.50.121:/photo ~/Documents/Diskstation/photo
  sudo mount -t nfs 192.168.50.121:/backup ~/Documents/Diskstation/backup
  sudo mount -t nfs 192.168.50.121:/project ~/Documents/Diskstation/project
}
