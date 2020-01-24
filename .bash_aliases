# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Common utility aliases.
alias g="git "
alias py2="python "
alias py="python3 "
alias ipy="ipython3 "
alias ipy2="ipython "
alias ovs="ovs-vsctl "
alias kc="kubectl "

s(){
    command sudo "$@"
}
export -f s

dk() {
    case "$1" in
        purge)
            shift
            command sudo docker rm -f $(sudo docker ps -qa) "$@"
            ;;
        *)
            command sudo docker "$@"
            ;;
    esac
}
export -f dk

dkc() {
    case "$1" in
        kick)
            shift
            command sudo docker-compose up -d --force-recreate $@
            ;;
        watch)
            while /bin/true; do
                shift
                sudo docker-compose logs -f $@
                sleep 2
                clear
            done
            ;;
        *)
            command sudo docker-compose $@
            ;;
    esac
}
export -f dkc

bell() {
    tput bel
}
export -f bell

ttime() {
    sleep $(bc -l <<< "${1:-5}*60")
    echo 'TEA TIME!' && bell
}
export -f ttime

randstring() {
    python3 -c "import os; import base64; print(base64.b32encode(os.urandom(${1:-32})).decode('utf-8').strip('='))"
}
export -f randstring

randhex() {
    python3 -c "import os; import base64; print(base64.b16encode(os.urandom(${1:-32})).decode('utf-8').lower())"
}
export -f randhex

dkenter() {
    if [ -z "$1" ]; then
        echo "container name must be specified" && return 1
    fi
    container=$1
    shift
    sudo nsenter -t $(sudo docker inspect "$container" -f '{{ .State.Pid }}') $@
}
export -f dkenter

dkln() {
    if [ -z "$1" ]; then
        echo "container name must be specified" && return 1
    fi

    id=$(sudo docker inspect -f '{{.Id}}' $1)
    if [ -z "$id" ]; then
        echo "container $1 not found" && return 1
    fi
    shift

    root=$(sudo cat /var/run/docker/runtime-runc/moby/$id/state.json | python3 -c 'import sys, json; sys.stdout.write(json.load(sys.stdin)["config"]["rootfs"])')
    if [ -z "$root" ]; then
        echo "failed to identify rootfs for $id" && return 1
    fi

    sudo ln -s $root $@
}
export -f dkln


# Kill all but the most recent mosh session.
mosh_highlander() {
    zombies=$(ps h -C mosh-server -o pid --sort start_time | head -n -1)
    if [ -z "$zombies" ]; then
        echo "There is only one!";
    else
        echo "There can only be one!"
        kill $zombies
    fi
}
export -f mosh_highlander

# Quickly create an ssh tunnel
sshtun() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "usage (see man ssh -L option): sshtun [bind_address:]port:host:hostport remote" && return 1
    fi
    ssh -N -L "$1" "$2"
}
export -f sshtun

# Add some modifications to Node.js REPL
nod() {
    if [ $(command -v rlwrap) ]; then
        NODE_NO_READLINE=1 rlwrap node --experimental-repl-await
    else
        node --experimental-repl-await
    fi
}
export -f nod

cdtmp() {
  cd $(mktemp -d)
}
export -f cdtmp
