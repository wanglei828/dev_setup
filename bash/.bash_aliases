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
alias valias='vi ~/.bash_aliases'

# change path
alias ap='cd ~/github/apollo'
alias ai='cd ~/github/apollo-internal'
alias as='cd ~/github/apollo-simulator'
alias eng='cd ~/github/replay-engine'
alias dset='cd ~/github/dev_setup'

# docker cmd
alias bstart='~/github/apollo-internal/docker/scripts/dev_start.sh'
alias binto='~/github/apollo-internal/docker/scripts/dev_into.sh'
alias rstart='~/github/apollo-internal/docker/scripts/release_start.sh'
alias rinto='~/github/apollo-internal/docker/scripts/release_into.sh'
alias dclean='docker ps -aq -f "status=exited" | xargs --no-run-if-empty docker rm -v -f'
alias iclean='docker images -aq -f "dangling=true" | xargs --no-run-if-empty docker rmi'
alias dps='docker ps'
alias dtag='docker images --format "{{.Repository}}:{{.Tag}}"'
alias di='docker images' 
alias drmi='docker rmi -f'

# source cmd
alias sbrc='source ~/.bashrc'
alias vibrc='vi ~/.bashrc'

# k8s
alias az_list='az aks list --output table'
alias az_east='az aks get-credentials -g prod -n apollo-dl-prod-eastus'
alias az_staging='az aks get-credentials -g test -n apollo-dl-staging-centralus'
alias 2staging='cp ~/.kube/az_staging.conf ~/.kube/config'
alias 2prod='cp ~/.kube/az_prod.conf ~/.kube/config'
alias 2bce='cp ~/.kube/bce.conf ~/.kube/config'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ssh
alias sdev='ssh wanglei@172.19.61.250'
alias sidg='ssh idgsim@172.19.61.250'
alias slei='ssh leiwang@172.19.40.63'
alias sre='ssh wanglei63@relay.baidu-int.com'
alias svm='ssh apollo@52.224.64.156'
alias sbce='ssh wanglei@180.76.109.108'


# sftp
alias flei='sftp leiwang@172.19.40.63'

#
alias mgrep='grep -R --exclude-dir={node_modules,bazel-bin,bazel-genfiles,bazel-out,gazel-testlogs,bazel-apollo}'
alias mfind='find . -path "*node_modules*" -prune -o -name'
