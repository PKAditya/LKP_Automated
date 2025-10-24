#!/bin/bash
pip install pyfiglet &> /dev/null
python -m pyfiglet "LKP TESTS"
export HISTIGNORE='*sudo -S*'
# Get the distribution name
distro=$(cat /etc/os-release | grep ^ID= | cut -d'=' -f2)
user=$(echo $USER)
echo " "
# Print the distribution name
#echo "Distribution: $distro"
loc=$(pwd)
echo "Working directory choosen for lkp is: $loc"
echo " "
echo "/////////////=== To stop this current process of creating LKP, use CTRL+C ===//////////////"
echo " "
sleep 2
# Check if the distro is Ubuntu
echo "DISTRO FOUND: $distro"
echo "CURRENT USER: $user"
echo " "
if command -v apt >/dev/null 2>&1; then
	echo "----------------------------"
	echo "Detected Debian based system"
	echo "----------------------------"
	echo ""
	sudo $loc/ubuntu-lkp-automation.sh
elif command -v dnf >/dev/null 2>&1 || command -v yum >/dev/null 2>&1; then
        echo "--------------------------"
        echo "Detected RHEL based system"
        echo "--------------------------"
        echo ""

	sudo $loc/centos-lkp-automation.sh
else
	echo "Unsupported system"
fi


