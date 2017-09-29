
env2conf () {
    if [ ! -f "/tmp/vars.yml" ]; then
        touch "/tmp/vars.yml"
    fi
    # Essentially: expand to set of all env vars beginning with 'cfg_'
    # -> loop through varnames, printing a yml entry with the varname
    # sans 'cfg_' prefix defined as the value of the env-var
    # (http://wiki.bash-hackers.org/syntax/pe)
    for cfg in ${!cfg_*}; do
        echo "${cfg/cfg_/}: ${!cfg}" >> "/tmp/vars.yml"
    done
}
