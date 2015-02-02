#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Modified commands ## 
alias ls='ls --color=auto'
alias diff='colordiff'
alias grep='grep --color=auto'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'

## New commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias ..='cd ..'

# Privileged access
##if [ <UID -ne 0 ]; then
alias sudo='sudo '
alias update='sudo pacman -Syu'
##fi

## ls
alias ls='ls -hF --color=auto'

## Safety
alias cps='cp -i'
alias rms='rm -i'
alias mvs='mv -i'

## Other
alias cd..='cd ..'


PS1='[\u@\h \W]\$ '
