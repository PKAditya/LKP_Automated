#!/bin/bash

STOP_FILE="/tmp/stop_lkp_script"

# Function to check if the stop file exists
check_exit() {
    if [ -f "$STOP_FILE" ]; then
        echo "Stop file detected. Exiting script..."
        exit 0
    fi
}

# Signal handling to allow graceful exit on Ctrl+C
trap "echo 'Caught SIGINT. Exiting...'; exit 0" SIGINT
echo " "

read -p "Do you want to run lkp test-cases automatically? (yes/y/no): " servi < /dev/tty
servi=$(echo "$servi" | tr '[:upper:]' '[:lower:]')
# servi="no"

loc=$(cd ../ && pwd)


echo " "
echo "============================================"
echo "Cloning into the LKP-Tests Directory"
echo "============================================"
echo " "
echo "Removing any directory named lkp-tests in the current directory"
rm -rf $loc/lkp-tests &> /dev/null
check_exit
cd $loc

git clone https://github.com/intel/lkp-tests/
cd $loc/lkp-tests
sudo make install

check_exit
echo " "


wlkp=$(which lkp)
rlkp="/usr/local/bin/lkp"
whack=$(which hackbench)
rhack="/usr/local/bin/hackbench"
if [[ -x "$rlkp" && -x "$rhack" ]]; then
        echo "lkp and hackbench already present skipping the installation of dependencies."
else
        chmod +x $loc/LKP_Automated/centos-deps.sh
        sudo $loc/LKP_Automated/centos-deps.sh
fi

if [[ ! -d "/var/log/lkp-automation-data" ]]; then
	mkdir -p /var/log/lkp-automation-data
	touch /var/log/lkp-automation-data/reboot-log
fi

echo "==========================================================="
echo "Modifying the installation files in the lkp-tests directory"
echo "==========================================================="
echo " "
cd $loc/lkp-tests
echo "Resetting the Repository head to the working version of the lkp"
git reset --hard 0bcdf89

echo "Creating a new file with the distro name for installation in installer directory"
cp $loc/lkp-tests/distro/installer/centos $loc/lkp-tests/distro/installer/opencloudos
cp $loc/lkp-tests/distro/installer/centos $loc/lkp-tests/distro/installer/anolis
cp $loc/lkp-tests/distro/installer/centos $loc/lkp-tests/distro/installer/openeuler

check_exit
> $loc/lkp-tests/distro/installer/opencloudos
> $loc/lkp-tests/distro/installer/anolis
> $loc/lkp-tests/distro/installer/openeuler

check_exit
# Confirm that the file contents were deleted
echo "Contents of '$FILE' deleted."


echo "Creating a new file with the distro name for installation in adaptation-pkg directory"


cp $loc/lkp-tests/distro/adaptation-pkg/centos $loc/lkp-tests/distro/adaptation-pkg/opencloudos
cp $loc/lkp-tests/distro/adaptation-pkg/centos $loc/lkp-tests/distro/adaptation-pkg/anolis
cp $loc/lkp-tests/distro/adaptation-pkg/centos $loc/lkp-tests/distro/adaptation-pkg/openeuler

check_exit
echo "Changing the source repo link for rt-tests to older rt-tests"
filename="$loc/lkp-tests/programs/hackbench/pkg/PKGBUILD"
line_number=10
new_text='source=("https://www.kernel.org/pub/linux/utils/rt-tests/older/rt-tests-${pkgver}.tar.gz")'
sed -i "${line_number}s|.*|${new_text}|" "${filename}"
linu=2
new_line2='pkgver=2.6'
sed -i "${linu}s|.*|${new_line2}|" "${filename}"
check_exit
line_number1=5
new_text1='url="https://www.kernel.org/pub/linux/utils/rt-tests/older"'
sed -i "${line_number1}s|.*|${new_text1}|" "${filename}"
check_exit


fn="$loc/lkp-tests/programs/rt-tests/pkg/PKGBUILD"
ln=8
n_t='source=("https://www.kernel.org/pub/linux/utils/rt-tests/older/rt-tests-$pkgver.tar.gz")'
sed -i "${ln}s|.*|${n_t}|" "${fn}"
linu2=2
new_line2='pkgver=2.6'
sed -i "${linu2}s|.*|${new_line2}|" "${fn}"
lnt=9
nl9="md5sums=('SKIP')"
sed -i "${lnt}s|.*|${nl9}|" "${fn}"
check_exit
echo " "
echo "============================================"
echo "Installing and splitting the LKP tests"
echo "============================================"
echo " "
echo "building lkp to /usr/local/bin"
make install &> /dev/null
echo "Installing lkp with dependencies"
yes | lkp install &> /dev/null
echo "Splitting the test-cases into directory named spilts"
check_exit
hey="$loc/lkp-tests/jobs/hackbench.yaml"

# Uncomment the line "# - 50%" in the specified file
sed -i 's/# - 50%/- 50%/' "$hey"
sed -i 's/- 1600%/# - 1600%/' "$hey"

check_exit

mkdir $loc/lkp-tests/splits 
cd $loc/lkp-tests/splits
echo " "
echo "Splitting Hackbench"
echo "--------------------"
lkp split-job $loc/lkp-tests/jobs/hackbench.yaml 
check_exit
echo " "
echo "Splitting Ebizzy"
echo "--------------------"
lkp split-job $loc/lkp-tests/jobs/ebizzy.yaml
check_exit
echo " "
echo "Splitting Unixbench"
echo "--------------------"
lkp split-job $loc/lkp-tests/jobs/unixbench.yaml
check_exit
echo " "
echo "Installing test-cases"

if [[ -x "$rlkp" && -x "$rhack" ]]; then
	echo "lkp and hackbench already present skipping the installation"
else
	# Function to display loading animation
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
	
	# Start loading animation in the background
	loading_animation &
	# Save the PID of the loading animation process
	spinner_pid=$!

	# Simulate a long-running process (replace with your actual command)
	echo "---------This might take a while, please wait while the process completes........"
	lkp install $loc/lkp-tests/splits/hackbench-pipe-8-process-100%.yaml &> /dev/null
	lkp install $loc/lkp-tests/splits/ebizzy-10s-100x-200%.yaml &> /dev/null
	lkp install $loc/lkp-tests/splits/unixbench-100%-300s-arithoh.yaml &> /dev/null
	check_exit
	# Stop the loading animation
	kill "$spinner_pid" > /dev/null 2>&1

	# Clean up the line after animation
	echo -e "\rDone!     "
fi

echo " "
echo "=========================="
echo "Clearing the older results"
echo "=========================="
echo " "
rm -rf /lkp/result/hackbench/*
rm -rf /lkp/result/ebizzy/*
rm -rf /lkp/result/unixbench/*
echo " "
echo "============================================"
echo "Creating a service file for running LKP"
echo "============================================"
echo " "
check_exit
cd $loc/lkp-tests/

touch $loc/lkp-tests/lkp.sh

echo "Creating a script file to run all the required test-cases, in this case they are:"
echo "Hackbench"
echo "Ebizzy"
echo "Unixbench"
echo " "
echo "Writing into lkp.sh"

# Define the script location
LKP_SCRIPT="/var/lib/lkprun.sh"

# Create the script file and add the shebang
echo "#!/bin/bash" > "$LKP_SCRIPT"

# Add error handling
echo "set -euo pipefail" >> "$LKP_SCRIPT"

# Define constants
cat <<'EOF' >> "$LKP_SCRIPT"
readonly STATE_FILE="/var/local/lkp-progress.txt"
readonly RESULT_DIR="/lkp/result"

# Verify required directories exist
for dir in "${RESULT_DIR}" "/var/local" "/tmp"; do
    if [[ ! -d "$dir" ]]; then
        echo "Error: Required directory $dir does not exist" >&2
        exit 1
    fi
done

# Verify lkp command exists
if ! command -v lkp >/dev/null 2>&1; then
    echo "Error: 'lkp' command not found" >&2
    exit 1
fi
EOF

# Start the test cases array
echo "test_cases=(" >> "$LKP_SCRIPT"

# Collect test case files
files=$(ls "$loc/lkp-tests/splits/")
file_array=($files)

# Append test cases starting with 'h' first
for test_case in "${file_array[@]}"
do
    if [[ $test_case == h* ]]; then
        echo "    \"lkp run $loc/lkp-tests/splits/$test_case\"" >> "$LKP_SCRIPT"
    fi
done

# Append test cases starting with 'e' second
for test_case in "${file_array[@]}"
do
    if [[ $test_case == e* ]]; then
        echo "    \"lkp run $loc/lkp-tests/splits/$test_case\"" >> "$LKP_SCRIPT"
    fi
done

# Append all remaining test cases last
for test_case in "${file_array[@]}"
do
    if [[ $test_case != h* && $test_case != e* ]]; then
        echo "    \"lkp run $loc/lkp-tests/splits/$test_case\"" >> "$LKP_SCRIPT"
    fi
done

echo ")" >> "$LKP_SCRIPT"

# Add all the functions
cat <<'EOF' >> "$LKP_SCRIPT"
get_last_completed() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE" || echo ""
    else
        echo ""
    fi
}

convert_elapsed_time() {
    local file=$1
    local elapsed_time=$(grep "Elapsed" "$file" | awk '{print $8}')
    local IFS=':'
    local time_parts=()
    read -r -a time_parts <<< "$elapsed_time"

    local hours=0
    local minutes=0
    local seconds=0

    # Parse time parts based on format (h:m:s or m:s or s)
    if [ ${#time_parts[@]} -eq 3 ]; then
        hours=${time_parts[0]}
        minutes=${time_parts[1]}
        seconds=${time_parts[2]}
    elif [ ${#time_parts[@]} -eq 2 ]; then
        minutes=${time_parts[0]}
        seconds=${time_parts[1]}
    else
        seconds=${time_parts[0]}
    fi

    # Convert everything to seconds using bc for decimal handling
    local total_seconds=$(echo "$hours * 3600 + $minutes * 60 + $seconds" | bc)

    # Round the decimal part if present
    if [[ $total_seconds == *"."* ]]; then
        # Extract decimal part
        local decimal_part=$(echo "$total_seconds" | awk -F. '{print $2}')
        local integer_part=$(echo "$total_seconds" | awk -F. '{print $1}')

        # If decimal >= 5, round up, else round down
        if [ ${decimal_part:0:1} -ge 5 ]; then
            total_seconds=$((integer_part + 1))
        else
            total_seconds=$integer_part
        fi
    fi

    echo "$total_seconds" > /tmp/lkp.result
}

extract_test_info() {
    local full_test_case=$1
    local test_case_string=$(echo "$full_test_case" | sed -E 's/.*\/splits\///')
    local test=$(echo "$test_case_string" | awk -F'-' '{print $1}')
    local type=$(echo "$test_case_string" | sed -E 's/^[^-]+-(.*)\.yaml/\1/')

    find /lkp/result/$test/$type/ -name "*.time" > /tmp/file.name
    cat $(cat /tmp/file.name) > /tmp/lkp.time
    rm -rf /tmp/file.name

    echo "$type" > /tmp/lkp-type
}

cleanup_test_results() {
    local test=$1
    local result_dir="${RESULT_DIR}/${test}"
    
    if [[ -d "$result_dir" ]]; then
        rm -rf "$result_dir"/* || {
            echo "Warning: Failed to clean up $result_dir" >&2
            return 1
        }
    fi
}

run_tests() {
    local last_completed
    local start_index=0
    local test_result_file="${RESULT_DIR}/test.result"
    
    last_completed=$(get_last_completed)
    
    # Find starting point if there was a previous run
    if [[ -n "$last_completed" ]]; then
        for i in "${!test_cases[@]}"; do
            if [[ "${test_cases[$i]}" == "$last_completed" ]]; then
                start_index=$((i + 1))
                break
            fi
        done
    fi
    
    # Only delete test.result file if we're starting from the beginning
    if [ "$start_index" -eq 0 ]; then
        rm -f "$test_result_file"
    fi
    
    for (( i = start_index; i < ${#test_cases[@]}; i++ )); do
        local current_test="${test_cases[$i]}"
        echo "Running: $current_test"
        
        ${current_test}
        extract_test_info "$current_test"
        touch /lkp/result/test.result
        convert_elapsed_time "/tmp/lkp.time"
        y=$(cat /tmp/lkp-type)
        echo "$(cat /tmp/lkp.result)" >> /lkp/result/test.result
        
        # Cleanup test directories
        rm -rf /lkp/result/hackbench/*
        rm -rf /lkp/result/ebizzy/*
        rm -rf /lkp/result/unixbench/*
        
        if [ $? -eq 0 ]; then
            echo "$current_test" > "$STATE_FILE"
        else
            echo "Error: Test execution failed for $current_test" >&2
            exit 1
        fi
    done
    
    # Cleanup state file after successful completion
    rm -f "$STATE_FILE"
}

# Main execution
run_tests

# Update reboot log
{
    echo ''
    echo '2'
} >> /var/log/lkp-automation-data/reboot-log
EOF

# Make the script executable
chmod 777 "$LKP_SCRIPT"



temp_state=$(cat /var/lib/lkp-automation-data/state-files/main-state)
state_value=$((temp_state + 1))
echo "echo '$state_value' >> /var/log/lkp-automation-data/reboot-log" >> lkp.sh

if [[ "$servi" == "yes" || "$servi" == "y" ]]; then
	echo "Creating a service to run lkp"
	cd /etc/systemd/system/
	touch lkprun.service
	truncate -s 0 lkprun.service
	check_exit
	echo -e "[Unit]" >> lkprun.service
	echo -e "Description=LKP Tests Service" >> lkprun.service
	echo -e "After=network.target" >> lkprun.service
	echo -e "\n" >> lkprun.service
	echo -e "[Service]" >> lkprun.service
	echo -e "WorkingDirectory=/var/lib" >> lkprun.service
	echo -e "ExecStart=/bin/bash /var/lib/lkprun.sh" >> lkprun.service
	echo -e "\n" >> lkprun.service
	echo -e "[Install]" >> lkprun.service
	echo -e "WantedBy=multi-user.target" >> lkprun.service
	echo "Reloading daemon"
	systemctl daemon-reload
	echo "Enabling lkp service"
	systemctl enable lkprun.service
	echo "Starting lkp service"
	systemctl start lkprun.service
	check_exit
	echo " "
	echo "===================================="
	echo "------------------------------------"
	echo " "
	echo "-----To find the results run the file /lkp/result/result.sh you will get the sorted results.-----"
	echo " "
	echo "use the below to stop the service or to stop running the lkp test-cases"
	echo "          sudo systemctl stop lkp.service"
	echo "use the below to disable the service"
	echo "          sudo systemctl disable lkp.service"
	echo " "
	
	echo "///////Note: The service created will auto-matically run when the system is started, to disable it use the above command mentioned /////////"
	echo " "
	echo "------------------------------------"
	echo "===================================="
else
	echo "============================"
	echo "Service file is not created "
	echo "============================"
fi

sleep 5

mkdir -p /lkp/result/

cp $loc/LKP_Automated/result.sh /lkp/result/

