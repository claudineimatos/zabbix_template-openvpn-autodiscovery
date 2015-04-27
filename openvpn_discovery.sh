#/bin/sh

OPENVPN_CONF_DIR=$(echo $2 | grep -o "^/[^\s]+" || echo "/var/etc/openvpn/")

for i in `find ${OPENVPN_CONF_DIR} -iname "$1*.conf" -exec grep management {} \; | awk '{print $2}'`
do
	instances="$instances,"'{"{#'$1'}":"'$i'","{#'$1'_NAME}":"'`basename $i .sock`'"}'
done

echo '{"data":['${instances#,}']}'
