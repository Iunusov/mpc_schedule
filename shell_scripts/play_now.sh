#!/bin/bash 

function get_current_name {
  echo $(mpc current);
}

function get_current_num {
  echo $(mpc| sed -n 2p| awk -F'#' '{print $2}'|awk -F'/' '{print $1}');
}

function get_last_num {
  echo $(mpc| sed -n 2p| awk -F'#' '{print $2}'| awk -F'/' '{print $2}'| awk -F' ' '{print $1}');
}

function get_last_name {
  echo $(mpc playlist | tail -1);
}

function get_pos_num {
  echo $(($(get_current_num)+1));
}

prev_count=$(get_last_num)

mpc update
sleep 3
mpc random 0
mpc add "$1"

track_name=$(get_last_name)

if [ "$prev_count" -eq "$(get_last_num)" ];then
exit
fi

pos=$(get_pos_num);
if [ $pos -gt $(get_last_num) ]; then
pos=1
fi

mpc move $(get_last_num) $pos

track_played=false;
while true;
do
  if [ "$track_name" = "$(get_current_name)" ];then
    track_played=true;
  fi
  if [ "$track_played" = "true" ];then
    if [ "$track_name" != "$(get_current_name)" ]; then
	  mpc del $(mpc playlist | grep -n "$track_name"|cut -f1 -d:)
	  break
	fi
  fi
sleep 10
done

