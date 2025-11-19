#!/bin/bash

case=$1
lkp_dir=$2
lkp_cmd=$3
echo "Initiating the hackbench $1 checks"

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

test_hackbench() {
    cd $lkp_dir/splits
    if [[ -f hackbench-pipe-8-process-100%.yaml ]]; then
        sed -i 's/iterations: 8/iterations: 1/g' hackbench-pipe-8-process-100%.yaml
    else
        capture_error "hackbench test case split file not found"
    fi

    loading_animation &
    spinner_pid=$!
    echo "Testing hackbench, please wait..."
    lkp run hackbench-pipe-8-process-100%.yaml &> /dev/null
    test_install_status=$?
    kill "$spinner_pid" > /dev/null 2>&1
    echo -e "\rDone, checking results...     "
    if [[ $test_install_status -ne 0 ]]; then
        sed -i 's/iterations: 1/iterations: 8/g' hackbench-pipe-8-process-100%.yaml
        capture_error "hackbench is not in working state, need manual attention"
    fi
    echo "hackbench test case ran successfully"
    sed -i 's/iterations: 1/iterations: 8/g' hackbench-pipe-8-process-100%.yaml
}

install_hackbench() {
    cd $lkp_dir/splits
    sed -i '73d;74d;83d;85d;86d;87d' $lkp_dir/splits/hackbench-pipe-8-process-100%.yaml
    loading_animation &
    spinner_pid=$!
    echo "Installing hackbench, please wait..."
    $lkp_cmd install $lkp_dir/splits/hackbench-pipe-8-process-100%.yaml &> /dev/null
    install_status=$?
    kill "$spinner_pid" > /dev/null 2>&1
    if [[ $install_status -ne 0 ]]; then
        capture_error "hackbench installation failed, Manual attention needed"
    fi
    echo "hackbench installed successfully"
}

if [[ $case == "test" ]]; then
    test_hackbench
elif [[ $case == "install" ]]; then
    install_hackbench
else
    echo "Invalid argument. Use 'test' or 'install'."

fi