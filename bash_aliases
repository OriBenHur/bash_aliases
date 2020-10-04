alias cls='printf "\033c"'

function valid_ip() {
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        ip=("${(@s/./)ip}")
        [[ ${ip[1]} -le 255 && ${ip[2]} -le 255 \
            && ${ip[3]} -le 255 && ${ip[4]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

function cssh() {
	local count=0
	local input=${1}
        echo ""
	ADDR=("${(@s/@/)input}") 
        if valid_ip ${ADDR[2]}; then
                ip=${ADDR[2]}
                user=${ADDR[1]}
        else
                ip=${ADDR[1]}
                user=$(whoami)
        fi
        while ! nc -z -w 1 ${ip} 22; do
                tput cuu 1 && tput el
                echo "Waiting"
                sleep 0.5
                tput cuu 1 && tput el
                echo "Waiting."
                sleep 0.5
                tput cuu 1 && tput el
                echo "Waiting.."
                sleep 0.5
                tput cuu 1 && tput el
                echo "Waiting..."
		if [[ count=$((count+1)) -gt 51 ]]; then
			echo "Too many retries aborting!"
			return 1 
		fi	
        done
        shift
        command ssh ${user}@${ip} "$@"

}

function fssh() {
	local IP="$1"
	ssh-keygen -R "~/.ssh/known_hosts" -R "${IP}"
}

