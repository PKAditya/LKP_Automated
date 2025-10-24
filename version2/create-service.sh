#!/bin/bash
# loc is lkp_directory
loc=$1 

# Define the script location
LKP_SCRIPT="/var/lib/auto_lkp.sh"

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


cd /etc/systemd/system/
touch auto_lkp.service
truncate -s 0 auto_lkp.service
check_exit
echo -e "[Unit]" >> auto_lkp.service
echo -e "Description=LKP Tests Service" >> auto_lkp.service
echo -e "After=network.target" >> auto_lkp.service
echo -e "\n" >> auto_lkp.service
echo -e "[Service]" >> auto_lkp.service
echo -e "WorkingDirectory=/var/lib" >> auto_lkp.service
echo -e "ExecStart=/bin/bash /var/lib/auto_lkp.sh" >> auto_lkp.service
echo -e "\n" >> auto_lkp.service
echo -e "[Install]" >> auto_lkp.service
echo -e "WantedBy=multi-user.target" >> auto_lkp.service
