#!/bin/bash

case=$1
lkp_dir=$2
lkp_cmd=$3
echo "Initiating the ebizzy $1 checks"

check_exit() {
    if [ -f "$STOP_FILE" ]; then
        echo "Stop file detected. Exiting script..."
        exit 0
    fi
}

# Signal handling to allow graceful exit on Ctrl+C
trap "echo 'Caught SIGINT. Exiting...'; exit 0" SIGINT

capture_error() {
    echo "------------------------------------------------------------"
    echo "LKP AUTOMATED TEST SUITE - ERROR LOG"
    echo "------------------------------------------------------------"
    echo "ERROR: $1"
	# skip printing of first argument as already printed above(using shift command)
	shift
        for arg in "$@"; do
                echo "$arg"
        done
        exit 1
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

test_ebizzy() {
    cd $lkp_dir/splits
    if [[ -f ebizzy-10s-100x-200%.yaml ]]; then
        sed -i 's/iterations: 100x/iterations: 1x/g' ebizzy-10s-100x-200%.yaml
        
    else
        capture_error "ebizzy test case split file not found"
    fi

    loading_animation &
    spinner_pid=$!
    echo "Testing ebizzy, please wait..."
    lkp run ebizzy-10s-100x-200%.yaml &> /dev/null
    test_install_status=$?
    kill "$spinner_pid" > /dev/null 2>&1
    echo -e "\rDone, checking results...     "
    if [[ $test_install_status -ne 0 ]]; then
        sed -i 's/iterations: 1x/iterations: 100x/g' ebizzy-10s-100x-200%.yaml
        capture_error "ebizzy is not in working state, need manual attention"
    fi
    echo "ebizzy test case ran successfully"
    sed -i 's/iterations: 1x/iterations: 100x/g' ebizzy-10s-100x-200%.yaml
}

install_ebizzy() {
    cd $lkp_dir/splits
    sed -i '72d;73d;82d;84d;85d;86d' $lkp_dir/splits/ebizzy-10s-100x-200%.yaml
    loading_animation &
    spinner_pid=$!
    echo "Installing ebizzy, please wait..."
    $lkp_cmd install $lkp_dir/splits/ebizzy-10s-100x-200%.yaml &> /dev/null
    install_status=$?
    kill "$spinner_pid" > /dev/null 2>&1
    if [[ $install_status -ne 0 ]]; then
        capture_error "ebizzy installation failed, Manual attention needed"
    fi
    echo "ebizzy installed successfully"
}

if [[ $case == "test" ]]; then
    test_ebizzy
elif [[ $case == "install" ]]; then
    install_ebizzy
else
    echo "Invalid argument. Use 'test' or 'install'."

fi