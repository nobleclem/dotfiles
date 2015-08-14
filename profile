alias la='clear && ls -lh'
alias grep='grep -s --exclude=\*.svn\*'

case "`uname`" in
    SunOS)
        TERM="dtterm";
        # setup grep as ggrep if it exists
        if [ `which ggrep` ] ; then
          alias grep='ggrep -s --exclude=\*.svn\*'
        fi
        ;;
    Darwin)
        TERM="xterm-color";
        ;;
    FreeBSD)
        TERM="xterm-color";
        ;;
    Linux)
        TERM="xterm-color";
        alias ls='ls --color=none'
        ;;
    *)
        TERM="vt102";
        ;;
esac
export TERM;

stty erase ^?


function set_alias {
  local alias_name=$1
  local alias_path=$2

  if [ -x $alias_path ];  then
      alias $alias_name=$alias_path
  fi
}

#set program aliases
set_alias tar /usr/sfw/bin/gtar
set_alias vi  /opt/local/bin/vim
set_alias vi  /usr/local/bin/vim
set_alias vi  /usr/bin/vim
set_alias vi  `which vim`

#set command defaults
alias getprofile="scp nobleclem@fatalexception.us:.profile ~/.profile && source ~/.profile"

# add hostname to terminal window
echo -ne "\033]0;`hostname|cut -f1 -d\.`\007"

PS1='[\u@\h \W]\$ '
export PS1


unset PATH
for path_dir in $HOME/builds/bin\
                /usr/local/bin\
                /sbin\
                /bin\
                /usr/sbin\
                /usr/bin\
                /usr/ucb\
                /usr/ccs/bin\
                /usr/games\
                /usr/sfw/bin\
                /opt/local/sbin\
                /opt/local/bin\
                /usr/local/sbin\
                /usr/local/bin\
                /usr/X11R6/bin\
                /usr/openwin/bin\
                /home/oracle/9.2/bin\
                /usr/local/mysql/bin\
                /usr/dt/bin\
                /opt/VRTS/bin\
                /opt/CA/SharedComponents/bin\
                $HOME/bin\
                $HOME/perl
do
   if [ -d $path_dir ];then
      PATH="${PATH}:$path_dir"
   fi
done
export PATH

BLOCKSIZE=K;    export BLOCKSIZE
EDITOR=vim;     export EDITOR
PAGER=less;     export PAGER
COPY_EXTENDED_ATTRIBUTES_DISABLE=1 ;   export COPY_EXTENDED_ATTRIBUTES_DISABLE

ENV=$HOME/.bashrc; export ENV
if [ -d /u1/app/oracle/OraHome ];then
    ORACLE_HOME=/u1/app/oracle/OraHome/; export ORACLE_HOME                       
    ORACLE_SID=PROD; export ORACLE_SID
fi
ULIMIT=unlimited; export ULIMIT
FTP_PASSIVE=1; export FTP_PASSIVE
PASSIVE_FTP=1; export PASSIVE_FTP

# load bash_completion scripts
if [ -d /etc/bash_completion.d ]; then
    for f in /etc/bash_completion.d/*; do source $f; done
fi

# import custom aliases
if [ -r ~/.profile.local ] ; then
  source ~/.profile.local
fi
