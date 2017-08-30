#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
Path=$( cd "$( dirname "\$0" )" && pwd )
banpid='/tmp/ban.pid'
iptpid='/tmp/ipt.pid'

Stop () {
iptables -F
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -A INPUT -i lo -j ACCEPT
ipset flush
## delete chain
ipset -X trueips
ipset -X truenets
ipset -X botipnets
ipset -X badips
ipset -X badnets
ipset -X badipstime
ipset -X badnetstime
iptables -X f2b-sshd
iptables -X ispmgr_allow_ip
iptables -X ispmgr_allow_sub
iptables -X ispmgr_deny_ip
iptables -X ispmgr_deny_sub


if [ -f "$banpid" ] 
then
 {
 kill `cat $banpid`
 rm $banpid
}
fi

rm $iptpid

echo "Stopped"
iptables -S

	}

Start () {


if [ -f "$iptpid" ]
then { 
echo "ipt already running"
}
else {
echo $$ > $iptpid
$Path/ipt.sh
#$Path/ban.sh &
echo "Started"
}
fi
	}



case $1 in
      start)  
      Start
;;
      stop)
      Stop
;;
      restart)
      Stop
      Start
;;
     *)
echo "stop|start|restart"
;;

esac

 exit 0