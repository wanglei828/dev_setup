# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    alias ls='ls -G'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias valias='vi ~/.bash_aliases'

# change path

# docker cmd
alias dclean='docker ps -aq -f "status=exited" | xargs --no-run-if-empty docker rm -v -f'
alias iclean='docker images -aq -f "dangling=true" | xargs --no-run-if-empty docker rmi'
alias dps='docker ps'
alias dtag='docker images --format "{{.Repository}}:{{.Tag}}"'
alias di='docker images' 
alias drmi='docker rmi -f'

# source cmd
alias sbrc='source ~/.bashrc'
alias vibrc='vi ~/.bashrc'
alias valias='vi ~/.bash_aliases'

alias kpod='kubectl get pod'
alias knode='kubectl get node'
alias klog='kubectl logs'
alias kns='kubectl get ns'
alias kcur='kubectl config current-context'
alias kspa='kubectl config view --minify | grep namespace'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# lsf
alias bs='bsub -Is bash'

#
alias gw='grep -r -w'

# git
alias gclone='git clone -b master --single-branch'
alias gitc='vi ~/.gitconfig'
