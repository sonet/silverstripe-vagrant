# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions

export PATH="$PATH:/var/www/html/vendor/bin"

if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi
