#!/bin/bash

file=$1


elapsed_time=$(grep "Elapsed" $file | awk '{print $8}')
IFS=':' read -r -a time_parts <<< "$elapsed_time"

if [ ${#time_parts[@]} -eq 3 ]; then
    # If the time format is h:m:s
    hours=${time_parts[0]}
    minutes=${time_parts[1]}
    seconds=${time_parts[2]}
elif [ ${#time_parts[@]} -eq 2 ]; then
    # If the time format is m:s
    hours=0
    minutes=${time_parts[0]}
    seconds=${time_parts[1]}
else
    # If the time format is s
    hours=0
    minutes=0
    seconds=${time_parts[0]}
fi

# Convert to total seconds and round the result
total_seconds=$(echo "$hours * 3600 + $minutes * 60 + $seconds" | bc)
rounded_seconds=$(echo "scale=0; $total_seconds / 1" | bc)

echo $rounded_seconds >> /tmp/lkp.result
