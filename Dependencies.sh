#!/bin/bash

#ANSI COLORS (FG & BG)
R="$(printf '\033[1;31m')" 
E="$(printf '\033[0m\e[0m')" 
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')" 
B="$(printf '\033[1;34m')" 
M="$(printf '\033[1;35m')" 
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

banner_racons() {
    clear
    echo ${W}
    echo -e "\n\n\n\n\n\n\n" | while IFS= read -r line; do printf "%*s
" $((($(tput cols) + ${#line}) / 2)) "$line"; done
    jp2a --term-width .banner.jpeg | while IFS= read -r line; do printf "%*s
" $((($(tput cols) + ${#line}) / 2)) "$line"; done

    figlet -f slant "Zumo" | while IFS= read -r line; do printf "%*s
" $((($(tput cols) + ${#line}) / 2)) "$line"; done
 echo -e "\n\n\n\n\n\n\n" | while IFS= read -r line; do printf "%*s
" $((($(tput cols) + ${#line}) / 2)) "$line"; done
    sleep 1
    clear
}


install_package() { 
    if [[ -d /data/data/com.termux/files/home ]]; then  
        pkg install ${missing_packages} -y 
    fi
}


verify_dependencies(){
    missing_packages=""
    for package in git lsd tmux neofetch curl neovim bat build-essential; do
        dpkg -s $package > /dev/null 2>&1
        if [ $? != 0 ]; then
            missing_packages="$missing_packages $package"
        fi
    done

    if [ -z "$missing_packages" ]; then
        clear 
        echo "${M}[${W}+${M}]${G} All Dependencies Installed${E}"
        sleep 1 
        bash install.sh
        exit
    ##
        exit
    else 
        clear 
        echo -e "${M}[${W}+${M}]${R} Missing Dependencies:${missing_packages}${E}\n"
        sleep 1
    fi
}

if [[ $(command -v pkg) ]]; then 
  if  ! [ -d ~/storage ] 
  then 
    termux-setup-storage
  fi
fi
clear
pkg install -y jp2a figlet ncurses-utils
banner_racons
clear
verify_dependencies
install_package
clear
verify_dependencies
exit

exit
