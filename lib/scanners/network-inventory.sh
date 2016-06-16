# group: Network
# name: Inventory
# description: Inventory only scanner determining external IPv4 IPs, all routes, all nameservers and the number of configured scope global IPv6 addresses

ips=$(
	# FIXME: Extremly cheap private net matching...
	/sbin/ip a |\
	/usr/bin/awk '/scope (global|host)/ && !/inet6/ && !/inet (10\.|192\.168\.|172\.|127\.)/ {printf "%s ", $2}'
)

result_inventory "External IPs" "$ips"

result_inventory "Routes" "$(/sbin/ip route | awk '{printf "%s_%s_%s ", $1, $2, $3}')"

result_inventory "Name Servers" $(awk '/^nameserver/ {print $2}' /etc/resolv.conf)

result_inventory "IPv6 Address" "$(ip a |grep 'inet6 .*scope global' | wc -l)"
