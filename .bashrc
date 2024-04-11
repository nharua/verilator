# .bashrc
 
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export TERM=xterm-256color

# Modify bash shell prompt
orange=$(tput setaf 166);
yellow=$(tput setaf 228);
green=$(tput setaf 71);
white=$(tput setaf 15);
bold=$(tput bold);
reset=$(tput sgr0);

PS1="\[${bold}\]\n";
PS1+="\[${orange}\]\u";                 #username
PS1+="\[${white}\]@";
PS1+="\[${yellow}\]\h";                 #host
PS1+="\[${white}\] in ";
PS1+='\[${green}\]\W\[${white}\] $(git branch 2>/dev/null | grep -e ^* | sed -E  "s/\* //") ' #current git branch
PS1+="\n";
PS1+="\[${white}\]\$ \[${reset}\]";
export PS1;