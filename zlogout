[[ ! -o rcs ]] && return

#gpgconf --kill gpg-agent
#rm -f ${HOME}/.var/S.gpg-agent
#rm -f ${HOME}/.var/S.gpg-agent.ssh
#sudo -K 2>/dev/null || :
clear
[ -x "$(which clear_console 2>/dev/null)" ] && clear_console -q

# vim:ft=zsh
