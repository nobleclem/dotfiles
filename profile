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

# enable ctrl-a/e line cursor move endings
set -o emacs

# add hostname to terminal window
echo -ne "\033]0;`hostname|cut -f1 -d\.`\007"

# change command prompt
PS1='[\u@\h \W]\$ '
export PS1

# update PATH list
unset PATH
for pathDir in $HOME/builds/bin\
               $HOME/builds/packages/go/bin\
               /usr/local/bin\
               /sbin\
               /bin\
               /usr/sbin\
               /usr/bin\
               /usr/local/sbin\
               /usr/local/bin\
               /usr/local/mysql/bin\
               $HOME/bin
do
    if [ -d $pathDir ];then
        if [ "${PATH}" != "" ]; then
            PATH="${PATH}:";
        fi
        PATH="${PATH}$pathDir"
    fi
done
export PATH

function set_alias {
  local aliasName=$1
  local aliasPath=$2

  if [ -x $aliasPath ];  then
      alias $aliasName=$aliasPath
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
alias wget='wget --content-disposition'

BLOCKSIZE=K;	export BLOCKSIZE
EDITOR=vim;   	export EDITOR
PAGER=less;  	export PAGER
COPY_EXTENDED_ATTRIBUTES_DISABLE=1;   export COPY_EXTENDED_ATTRIBUTES_DISABLE

# oracle junk
#if [ -d /u1/app/oracle/OraHome ]; then
#    ORACLE_HOME=/u1/app/oracle/OraHome/; export ORACLE_HOME
#    ORACLE_SID=PROD; export ORACLE_SID
#fi

ULIMIT=unlimited; export ULIMIT

# load bash_completion scripts
#if [ -d /etc/bash_completion.d ]; then
#    for f in /etc/bash_completion.d/*; do source $f; done
#fi

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
    LOCAL=$(git rev-parse @{0})
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
