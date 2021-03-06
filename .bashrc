# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
export EDITOR=vim

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Virualenvwrapper
for VENV_PATH in /usr/local/bin/virtualenvwrapper.sh /usr/share/virtualenvwrapper/virtualenvwrapper.sh $HOME/.local/bin/virtualenvwrapper.sh $HOME/Library/Python/3.7/bin/virtualenvwrapper.sh; do
  if [ -f "$VENV_PATH" ]; then
    export WORKON_HOME=$HOME/virtenvs
    export VIRTUALENVWRAPPER_PYTHON=$(which python3)
    source $VENV_PATH
    break
  fi;
done

if [ -d /usr/local/cuda/extras/CUPTI/lib64 ]; then
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64
fi;

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

# Disable the "deprecation" notice for bash on MacOS Catalina.
export BASH_SILENCE_DEPRECATION_WARNING=1

# Setup a node version manager for managing node versions.
# First try to setup n. https://github.com/tj/n
# As a backup, check is NVM is installed and if so, initialize it.
if [ -n $(which n) ]; then
  export N_PREFIX=$HOME/.n
  export PATH=$N_PREFIX/bin:$PATH
elif [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
fi

# Setup node env variables.
export NODE_OPTIONS="--experimental-repl-await"

if [ "$(uname -s)" = Darwin ]; then
  # On Mac, add Apple's WiFi utilities to PATH.
  export PATH=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/:$PATH

  # If asdf is installed via homebrew, load it into the environment.
  ASDF_PATH="$(brew --prefix asdf)"
  if [ -d "$ASDF_PATH" ]; then
    . "$ASDF_PATH/asdf.sh"
    . "$ASDF_PATH/etc/bash_completion.d/asdf.bash"
  fi
  export PATH=$HOME/Library/Python/3.7/bin/:$PATH
fi

# Add Android home env variables to make Android development work properly.
export ANDROID_HOME=/usr/local/share/android-sdk
export ANDROID_NDK=/usr/local/share/android-ndk
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
# this is an optional gradle configuration that should make builds faster
export GRADLE_OPTS='-Dorg.gradle.daemon=true -Dorg.gradle.parallel=true -Dorg.gradle.jvmargs="-Xmx4096m -XX:+HeapDumpOnOutOfMemoryError"'
# Add the emulator and Android tools to path
export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$PATH

# Setup jenv for Java version management.
if [ -n "$(which jenv)" ]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# Set PATH so it includes user's private bin if it exists.
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/go" ] ; then
    GOPATH=$HOME/go
    PATH=$PATH:$GOPATH/bin
fi

# Use the go installation in /usr/local/go/bin, if it exists.
if [ -d "/usr/local/go" ] ; then
    GOROOT=/usr/local/go
    PATH=$PATH:$GOROOT/bin
fi

# Set up the cargo bin directory for Rust.
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
    if [ -f "$HOME/.cargo/env" ]; then
      . "$HOME/.cargo/env"
    fi
fi

# Set up git tab completion.
if [ -f "$HOME/.git-completion.bash" ]; then
    . "$HOME/.git-completion.bash" 
fi

# Set up kubectl tab completion.
if [ -n "$(which kubectl)" ]; then
    . <(kubectl completion bash)
fi

# If the SSH agent is not running, start it.
if [ -z "$SSH_AGENT_SOCK" ] && [ -n "$(which ssh-agent)" ]; then
  . <(ssh-agent) > /dev/null
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [[ -s "/home/nate/.sdkman/bin/sdkman-init.sh" ]]; then
    export SDKMAN_DIR="/home/nate/.sdkman"
    source "/home/nate/.sdkman/bin/sdkman-init.sh"
fi

# If tmux is installed attach atomatically and exit bash when it quits
if command -v tmux>/dev/null; then
    if [[ ! $TERM =~ screen ]] && [ -z $TMUX ]; then
        tmux attach -t "^-^" || tmux new-session -s "^-^"
    fi
fi
