#/bin/sh

#Change this variable if your OpenVPN config directory is in a different place
OPENVPN_CONF_DIR="/etc/openvpn/"

for i in `find ${OPENVPN_CONF_DIR} -iname "*.conf" | awk '{print $1}'`
do
        CLIENT_NAME=`basename $i`
        CLIENT_NAME=$(echo "${CLIENT_NAME%.*}")
        instances="$instances,"'{"{#'$1'}":"'$i'","{#'$1'_NAME}":"'$CLIENT_NAME'"}'
done

echo '{"data":['${instances#,}']}'
