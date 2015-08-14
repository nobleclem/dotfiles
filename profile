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
        # i hates colors
        alias ls='ls --color=none'
        ;;
    *)
        TERM="vt102";
        ;;
esac
export TERM;

stty erase 


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
alias la='clear && ls -lh'

# add hostname to terminal window
echo -ne "\033]0;`hostname|cut -f1 -d\.`\007"

PS1='[\u@\h \W]\$ '
export PS1


unset PATH
for path_dir in $HOME/builds/bin\
                $HOME/builds/packages/go/bin\
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

BLOCKSIZE=K;	export BLOCKSIZE
EDITOR=vim;   	export EDITOR
PAGER=less;  	export PAGER
COPY_EXTENDED_ATTRIBUTES_DISABLE=1;   export COPY_EXTENDED_ATTRIBUTES_DISABLE

#ENV=$HOME/.bashrc; export ENV
if [ -d /u1/app/oracle/OraHome ]; then
    ORACLE_HOME=/u1/app/oracle/OraHome/; export ORACLE_HOME
    ORACLE_SID=PROD; export ORACLE_SID
fi
ULIMIT=unlimited; export ULIMIT
FTP_PASSIVE=1; export FTP_PASSIVE
PASSIVE_FTP=1; export PASSIVE_FTP

dotfiles="profile.git vimrc"
dotfilesdir=""
for file in $dotfiles; do
    symfile=$(readlink ~/.$file);
#    echo "$file : $symfile";
    if [ "$symfile" != "" ]; then
        tmpdirname=$(dirname $symfile);

#        echo "$dotfilesdir : $tmpdirname";
        if [ "$dotfilesdir" == "" ] && [ "$tmpdirname" != "" ]; then
            dotfilesdir=$tmpdirname;
        fi
    fi
done
if [ `which git` ] && [ "$dotfilesdir" != "" ] && [ -d $dotfilesdir ]; then
    currdir=$(pwd);
    cd $dotfilesdir

    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})
    BASE=$(git merge-base @ @{u})

    echo "$LOCAL : $REMOTE : $BASE"

    cd $currdir
fi

# import custom aliases
if [ -r ~/.profile.local ] ; then
    source ~/.profile.local
fi
