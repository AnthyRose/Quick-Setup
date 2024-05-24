#!/bin/bash

debian_sources_list_conf() {
    if whiptail --title "Debian Sources List" --yesno "Would you like to configure Debian sources list?" 8 78; then
        # Backup the sources list.
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
        # Write new sources list.
        sudo tee "/etc/apt/sources.list" > /dev/null << EOF
# Main repository
deb http://ftp.uk.debian.org/debian/ bookworm main
deb-src http://ftp.uk.debian.org/debian/ bookworm main

# Security updates
deb http://security.debian.org/debian-security bookworm-security main
deb-src http://security.debian.org/debian-security bookworm-security main

# bookworm-updates, previously known as 'volatile'
deb http://ftp.uk.debian.org/debian/ bookworm-updates main
deb-src http://ftp.uk.debian.org/debian/ bookworm-updates main

# bookworm-backports
deb http://ftp.uk.debian.org/debian/ bookworm-backports main
deb-src http://ftp.uk.debian.org/debian/ bookworm-backports main

# Non-free and contrib repositories (if you need them)
deb http://ftp.uk.debian.org/debian/ bookworm main contrib non-free
deb-src http://ftp.uk.debian.org/debian/ bookworm main contrib non-free
EOF
    fi    
}


package_manager_check() {
    case $1 in
        "debian" | "ubuntu" | "devuan")
            echo "apt"
            ;;
        "arch" | "manjaro" | "artix")
            echo "pacman"
            ;;
        "fedora")
            echo "dnf"
            ;;
        *)
            echo "Unknown package manager"
            ;;
    esac
}

snap_store_select() {
    if whiptail --title "Snap Store" --yesno "Should the Snap Store be installed?" 8 78; then
        echo 1
    else
        echo 0
    fi
}   

flatpak_select() {
    if whiptail --title "Flatpak" --yesno "Should Flatpak be installed?" 8 78; then
        echo 1
    else
        echo 0
    fi
}

snap_select() {
    if whiptail --title "Snap" --yesno "Should Snap be installed?" 8 78; then
        whiptail --title "Snap Warning" --msgbox "Snap packages are known to have issues compared to flatpak packages. Debian runs an outdated snap that can encounter issues with some packages. Snaps are also known to be most campatible with Gnome. With other Desktop Environments having issues with Snaps which flatpaks don't." 12 78
        echo 1
    else
        echo 0
    fi
}

choosen_de() {
    selection=$(whiptail --title "Desktop Environment" --radiolist \
    "Which desktop environment is being used?" 20 78 4 \
    "Gnome" "Allow connections to other hosts" ON \
    "XFCE" "Allow connections from other hosts" OFF \
    3>&1 1>&2 2>&3)
    echo "$selection"
}

check_distro() {
    if [ -f /etc/os-release ]; then
        grep "^ID=" /etc/os-release | cut -d'=' -f2 | tr -d '"'
    else
        echo "Distro information not found."
    fi
}

# Calling the function
distro=$(check_distro)
#echo "Your current distro is $distro."
package_manager=$(package_manager_check "$distro")


whiptail --title "About" --msgbox "This program is used to quickly configure a default Linux install on my computers. Other people can use this program, However, it will be developed with my computer specifications in mind. You are welcome to fork this script and alter it for your own use." 10 78

debian_sources_list_conf
desktop=$(choosen_de)
Flatpak=$(flatpak_select)
Snap=$(snap_select)

echo "You have selected $alternative_package_manager as your alternative package manager."
