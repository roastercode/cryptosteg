#!/bin/bash
# CryptoSteg
# Encrypt files and steg them to pictures

# Variables
ENCRYPT=$"gpg -c"
DECRYPT=$"gpg"
NOW=$(date +"%m_%d_%Y")

# Clear the terminal
tput clear
# Prevent pinentry trouble with pinentry display
echo pinentry-program /usr/bin/pinentry-curses >> ~/.gnupg/gpg-agent.conf
echo RELOADAGENT | gpg-connect-agent

# Welcome
printf "\033[1;32mWelcome to CryptoSteg\n Stegagnograph and Encrypt data\n Made Simple\033[0m%s\n"

# Request the user to install or not the needed software
while true; do
    read -p "Do you need to install steghide and gpg to run CryptoSteg? Y/n " yn
    case $yn in
	[Yy]* ) # Install needed software for the operating system
	    command_exists () {
		type "$1" &> /dev/null ;
	    }
	    
	    # For Debian / Ubuntu / Trisquel / gNewSense and derivatives
	    if command_exists apt-get ; then
		sudo apt-get install steghid gnupg ;
	    fi

	    # For Archlinux / Parabola and derivatives
	    if command_exists pacman ; then
		sudo pacman -Sy steghide gnupg ;
	    fi

	    # For Android / Cyanogen / Replicant and derivatives
	    if command_exists apt ; then
		sudo apt install steghide gnupg ;
	    fi

	    # For Fedora and derivatives
	    if command_exists dnf ; then
		sudo dnf install -y steghide gnupg ;
	    fi

	    # For RedHat / CentOS and derivatives
	    if command_exists yum ; then
		sudo yum install -y steghide gnupg ;
	    fi

	    if command_exit pkg ; then
		sudo pkg install -y steghide gnupg ;
	    fi
	    break;;
	[Nn]* ) break ;;
	* ) echo "Please answer Yes or no. ";;
    esac
done
		
# Request the user to create an encrypted key
while true; do
    read -p "Do you need to create an encrypted key? Y/n " yn
    case $yn in
	[Yy]* ) # creating a key
	    printf "/!\ If you forget your passphrase, the key cannot be used\n and any data encrypted using that key will be lost.\n"
	    gpg2 --full-gen-key
	    break;;
	[Nn]* ) break;;
	* ) echo "Please answer Yes or no.";;
    esac
done


# Encrypt or Decrypt?
while true; do
    read -p "Do you which to encrypt or decrypt data? Encrypt/Decrypt " ed
    case $ed in
	[Ee]* ) # Encrypt - Request the user where and which file he wish to encrypt
	    printf "Which file do you wish to encrypt?\n"
	    printf "Please provide its place and name like /home/user/file\n"
	    read FILE

	    # Encrypt
	    $ENCRYPT $FILE
	    # Request the user which picture he want to use
	    printf "Which picture do you wish to use?\n"
	    printf "Please provide its place and name like /home/user/picture\n"
	    read PICTURE
	    # Grab and Steg the file
	    steghide embed -cf $PICTURE -ef $FILE.gpg
	    printf "Well done, $PICTURE now contain your secret safe\n"
	    break;;
	[Dd]* ) # Decrypt - Request the user where and which file he wish to decrypt
	    printf "Which picture do you want to extract?\n"
	    printf "Please provide its place and name like /home/user/picture\n"
	    read PICTURE
	    # Encrypt
	    steghide extract -sf $PICTURE
	    $DECRYPT *.gpg
	    printf "Well done, your file is now human readable\n"
	    break;;
	* ) echo "Please answer Encrypt or Decrypt.";;
    esac
done
exit
