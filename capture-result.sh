#!/bin/bash

convert_elapsed_time() {
    local file=$1
    local elapsed_time=$(grep "Elapsed" "$file" | awk '{print $8}')
    local IFS=':'
    local time_parts=()
    read -r -a time_parts <<< "$elapsed_time"

    local hours=0
    local minutes=0
    local seconds=0

    if [ ${#time_parts[@]} -eq 3 ]; then
        # If the time format is h:m:s
        hours=${time_parts[0]}
        minutes=${time_parts[1]}
        seconds=${time_parts[2]}
    elif [ ${#time_parts[@]} -eq 2 ]; then
        # If the time format is m:s
        minutes=${time_parts[0]}
        seconds=${time_parts[1]}
    else
        # If the time format is s
        seconds=${time_parts[0]}
    fi

    # Convert to total seconds and round the result
    local total_seconds=$(echo "$hours * 3600 + $minutes * 60 + $seconds" | bc)
    local rounded_seconds=$(echo "scale=0; $total_seconds / 1" | bc)

    echo "$rounded_seconds" >> /tmp/lkp.result
}

extract_test_info() {
    local full_test_case=$1
    
    # Extract the portion after "/splits/"
    local test_case_string=$(echo "$full_test_case" | sed -E 's/.*\/splits\///')
    
    # Extract the test name (before the first hyphen)
    local test=$(echo "$test_case_string" | awk -F'-' '{print $1}')
    
    # Extract the type (everything after the first hyphen and before ".yaml")
    local type=$(echo "$test_case_string" | sed -E 's/^[^-]+-(.*)\.yaml/\1/')
    
    # Change directory and find time files
    cd /lkp/result/$test/$type/
    find ./ -name "*.time" > /tmp/file.name
    cat $(cat /tmp/file.name) > /tmp/lkp.time
    rm -rf /tmp/file.name
    
    # Output the results
    echo "Test Name: $test, Type: $type"
}

extract_test_info ""lkp run /home/amd/lkp-tests/splits/hackbench-pipe-8-threads-50%.yaml
convert_elapsed_time "/tmp/lkp.time"
