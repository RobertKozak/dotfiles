PATH=$HOME/.local/bin:$PATH

export TERM=xterm-256color
#[ -n "$TMUX" ] && export TERM=screen-256color

export LS_COLORS='ow=01;36;40'

export EDITOR=nano

if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

_commit () {
  if [ "$1" != "" ]
  then
    git pull
    git add .
    git commit -m "$1"
    git push origin master
  else
    echo "[GIT] commit message is required"
  fi
}

alias commit=_commit

if [ -t 1 ]
then
  # set ssh agent
  [[ $- == *i* ]] && echo "Checking for ssh key passphrase"

  env=~/.ssh/agent.env

  agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

  agent_start () {
      (umask 077; ssh-agent >| "$env")
      . "$env" >| /dev/null ; }

  agent_load_env

  # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
  agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

  if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
      agent_start
      ssh-add -t 3600
  elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
      ssh-add -t 3600
  fi

  unset env

  [[ $- == *i* ]] && echo "Passphrase accepted"
fi

cd ~
