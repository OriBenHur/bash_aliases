# /etc/bash_alias

alias cls='printf "\033c"'

function valid_ip() {
    local shell="$(ps -hp $$ | awk '{print $5}')"
    local index=0
    local  ip=${1}
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        if [[ "${shell}" == *"zsh"* ]]; then
            ip=("${(@s/./)ip}")
            index=$((index+1))
        elif [[ ${shell} == *"bash"* ]]; then
            ip=(${ip//./ })
        fi
        [[ ${ip[${index}]} -le 255 && ${ip[$((index+1))]} -le 255 \
            && ${ip[$((index+2))]} -le 255 && ${ip[$((index+3))]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

function cssh() {
    local shell="$(ps -hp $$ | awk '{print $5}')"
    local index=0
	local count=0
	local input=${1}
    echo ""
    if [[ "${shell}" == *"zsh"* ]]; then
	    ADDR=("${(@s/@/)input}")
        index=$((index+1))
    elif [[ "${shell}" == *"bash"* ]]; then
        ADDR=(${input//@/ })
    fi
        if valid_ip ${ADDR[$((index+1))]}; then
                ip=${ADDR[$((index+1))]}
                user=${ADDR[${index}]}
        else
                ip=${ADDR[${index}]}
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

