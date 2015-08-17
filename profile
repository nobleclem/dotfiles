# DOTFILES CONFIG VARIABLES
sourcedotfiles="profile"
dotfiles="profile vimrc gitconfig gitignore"

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
alias grep='grep -s --exclude=\*.svn\*'

# add hostname to terminal window
echo -ne "\033]0;`hostname|cut -f1 -d\.`\007"

# change command prompt
PS1='[\u@\h \W]\$ '
export PS1

# update PATH list
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

# oracle junk
if [ -d /u1/app/oracle/OraHome ]; then
    ORACLE_HOME=/u1/app/oracle/OraHome/; export ORACLE_HOME
    ORACLE_SID=PROD; export ORACLE_SID
fi

ULIMIT=unlimited; export ULIMIT
FTP_PASSIVE=1; export FTP_PASSIVE
PASSIVE_FTP=1; export PASSIVE_FTP



# import custom aliases (here so we can override for dotfiles updates)
if [ -r ~/.profile.local ] ; then
    source ~/.profile.local
fi


### CHECK AND UPDATE DOTFILES ###
# find git repo
dotfilesdir=""
dotfilesbakdir=""
for file in $dotfiles; do
    symfile=$(readlink ~/.$file);
    if [ "$symfile" != "" ]; then
        tmpdirname=$(dirname $symfile);

        if [ "$dotfilesdir" == "" ] && [ "$tmpdirname" != "" ]; then
            dotfilesdir=$tmpdirname;
            dotfilesbakdir="${dotfilesdir}_bak"
        fi
    fi
done
# update dotfiles
if [ `which git` ] && [ "$dotfilesdir" != "" ] && [ -d $dotfilesdir ]; then
    currdir=$(pwd);

    # move to dotfiles git directory
    cd $dotfilesdir

    # update tracking refs
    git remote update &> /dev/null

    # get versions
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    # update required
    if [ $LOCAL != $REMOTE ]; then
        echo "=========================="
        echo "... UPDATING DOTFILES ..."
        echo "--------------------------"

        git pull

        # re-source files
        for file in $sourcedotfiles; do
            source ~/.$file
        done

        echo ""
        echo "=========================="
        echo "DOTFILES HAVE BEEN UPDATED"
        echo "=========================="
        echo ""
    fi

    cd ~

    # check symlinks
    for file in $dotfiles; do
        symfile=$(readlink .$file);

        if [ "$symfile" == "" ] || [ "$symfile" != "$dotfilesdir/$file" ]; then
            if [ -f .$file ]; then
                if [ ! -d ~/$dotfilesbakdir ]; then
                    mkdir -p ~/$dotfilesbakdir;
                fi

                mv .$file $dotfilesbakdir/
            fi

            ln -s $dotfilesdir/$file .$file
        fi
    done

    # go back to previous directory
    cd $currdir
fi
