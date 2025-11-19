#!/bin/bash

STOP_FILE="/tmp/stop_lkp_script"

check_exit() {
    if [ -f "$STOP_FILE" ]; then
        echo "Stop file detected. Exiting script..."
        exit 0
    fi
}

trap "echo 'Caught SIGINT. Exiting...'; exit 0" SIGINT

#Checking the distro name
distro_type=$(cat /etc/os-release | grep -i pretty | sed 's/PRETTY_NAME=//')
echo "--------------------------------------------"
echo "Detected Distro: $distro_type"
echo "--------------------------------------------"

capture_error() {
	echo "ERROR: $1"
	# skip the first argument printing as its already printed in echo(using shift command)
	shift
	for arg in "$@"; do
		echo "$arg"
	done
	exit 1
}

capture_warn() {
	echo "Warning: $1"
        for arg in "$@"; do
                echo "$arg"
        done
}

loading_animation() {
    local delay=0.1
    local spinstr='|/-\'
    while :; do
	    for ((i=0; i<${#spinstr}; i++)); do
	        printf "\r%s" "${spinstr:$i:1}"
	        sleep $delay
	    done
	done
}

#finding the package manager available on the system
installer=""
check_package_manager() {
    if command -v apt &> /dev/null; then
        installer="apt"
    elif command -v apt-get &> /dev/null; then
        installer="apt-get"
    elif command -v dnf &> /dev/null; then
        installer="dnf"
    elif command -v yum &> /dev/null; then
        installer="yum"
    elif command -v pacman &> /dev/null; then
        installer="pacman"
    elif command -v zypper &> /dev/null; then
        installer="zypper"
    elif command -v apk &> /dev/null; then
        installer="apk"
    else
        echo "Package Manager couldn't be recognized. Please contact the maintainer for support."
        exit 1
    fi
}
check_package_manager
echo "Detected Package Manager: $installer"
echo "--------------------------------------------"

pkgs_list=(git wget make gcc time perf* tar rubygems-devel ruby-devel rubygem-psych gcc-c++ cmake automake autoconf bsdtar glibc-static turbojpeg slang-devel libunwind-devel libcap-devel libbabeltrace numactl-devel flex libbabeltrace-devel python3-devel libcap-devel libcurl-minimal java-17-openjdk fakeroot openssl-devel openssl libcurl libcurl-devel patch bison elfutils-libelf-devel elfutils-devel libX11-devel systemtap-sdt-devel perl-ExtUtils-Embed perl-core perl-FindBin mesa-libGL-devel libXext-devel libcapstone-devel capstone-devel libdw-dev systemtap-sdt-dev libperl-dev clang clang-devel libpfm libpfm-devel perl-IPC-Run libxslt-devel llvm-devel)

gems_list=(text-table "activesupport -v 6.0.0" ruby bigdecimal json racc parser tins term-ansicolor rubocop-ast rubocop flex "bundler -v 2.5.19" git)

failed_pkgs=()
failed_gems=()

is_installed() {
    local pkg="$1"
    case "$installer" in
        apt|apt-get)
            dpkg -s "$pkg" &> /dev/null
            ;;
        dnf|yum)
            rpm -q "$pkg" &> /dev/null
            ;;
        pacman)
            pacman -Qi "$pkg" &> /dev/null
            ;;
        zypper)
            rpm -q "$pkg" &> /dev/null
            ;;
        apk)
            apk info "$pkg" &> /dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

print_status() {
    echo "-----------------------------------------"
    echo "Package Installation Status"
    echo "-----------------------------------------"
    printf "%-30s : %s\n" "Package" "Status"
    echo "-----------------------------------------"

    for pkg in "${pkgs_list[@]}"; do
        if is_installed	 "$pkg"; then
            printf "%-30s : %s\n" "$pkg" "Success"
        else
            printf "%-30s : %s\n" "$pkg" "Failed"
        fi
    done

    echo " "
    echo "-----------------------------------------"    
    echo "Gems Installation Status"
    echo "-----------------------------------------"
    for gem in "${gems_list[@]}"; do
	if ! gem list -i $(echo "$gem" | awk '{print $1}') &> /dev/null; then
	    printf "%-30s : %s\n" "$gem" "Failed"
	else
	    printf "%-30s : %s\n" "$gem" "Success"
	fi
    done
    echo " "
}

# for pkg in "${pkgs_list[@]}"; do
# 	if ! is_installed "$pkg"; then
# 		if ! "$installer" install -y "$pkg"; then
# 			failed_pkgs+=("$pkg")
# 		else
# 			echo "Successfully installed the $pkg"
# 		fi
# 	else
# 		echo "$pkg already installed on the system, skipping......"
# 	fi
# done

# for gem in "${gems_list[@]}"; do
#     if ! gem list -i $(echo "$gem" | awk '{print $1}') &> /dev/null; then
#         if ! gem install $gem; then
#             failed_gems+=("$gem")
#         else
#             echo "Successfully installed $gem"
#         fi
#     else
#         echo "Gem $gem already installed, skipping..."
#     fi
# done


for pkg in "${pkgs_list[@]}"; do
	if ! is_installed "$pkg"; then
        loading_animation &
        spinner_pid=$!
	    echo "Installing $pkg, please wait..."
	    "$installer" install -y "$pkg" &> /dev/null
	    install_status=$?
	    kill "$spinner_pid" > /dev/null 2>&1
        if [[ $install_status -ne 0 ]]; then
            failed_pkgs+=("$pkg")
            echo "Failed to install $pkg"
        else
            echo "Successfully installed the $pkg"
        fi
	else
		echo "$pkg already installed on the system, skipping......"
	fi
done

for gem in "${gems_list[@]}"; do
    if ! gem list -i $(echo "$gem" | awk '{print $1}') &> /dev/null; then
        loading_animation &
        spinner_pid=$!
	    echo "Installing $pkg, please wait..."
	    gem install "$gem" &> /dev/null
	    install_status=$?
	    kill "$spinner_pid" > /dev/null 2>&1
        if [[ $install_status -ne 0 ]]; then
            failed_gems+=("$gem")
            echo "Failed to install $gem"
        else
            echo "Successfully installed $gem"
        fi
    else
        echo "Gem $gem already installed, skipping..."
    fi
done

print_status

if [ ${#failed_pkgs[@]} -eq 0 ]; then
	echo "All required packages are present in the system"
	echo " "

else
	echo " "
	capture_warn "Failed to find packages required for lkp installation" "Packages failed to install: ${failed_pkgs[@]}"
fi


if grep -q -i "euler" /etc/os-release; then
		sudo $installer remove -y rubygem-bundler
        sudo gem install bundler -v 2.3.26
fi
