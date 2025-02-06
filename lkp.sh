#!/bin/bash
STATE_FILE="/lkp-tests/progress.txt"
test_cases=(
)
get_last_completed() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo ""  # No progress made yet
    fi
}

# Function to run tests
run_tests() {
    rm -rf /lkp/result/hackbench/*
    rm -rf /lkp/result/ebizzy/*
    rm -rf /lkp/result/unixbnech/*
    local last_completed=$(get_last_completed)
    local start_index=0

    # Find the index of the last completed test
    for i in "${!test_cases[@]}"; do
        if [[ "${test_cases[$i]}" == "$last_completed" ]]; then
            start_index=$((i + 1))
            break
        fi
    done

    # Run tests starting from where it left off
    for (( i = start_index; i < ${#test_cases[@]}; i++ )); do
        echo "Running: ${test_cases[$i]}"
        ${test_cases[$i]}
        if [ $? -eq 0 ]; then
            echo "${test_cases[$i]}" > "$STATE_FILE"
        else
            echo "Test failed, stopping execution."
            exit 1
        fi
    done

    # Clean up the state file if all tests are completed
    rm -f "$STATE_FILE"
}

run_tests
#!/bin/bash
STATE_FILE="/lkp-tests/progress.txt"
test_cases=(
)
get_last_completed() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo ""  # No progress made yet
    fi
}

# Function to run tests
run_tests() {
    local last_completed=$(get_last_completed)
    local start_index=0

    # Find the index of the last completed test
    for i in "${!test_cases[@]}"; do
        if [[ "${test_cases[$i]}" == "$last_completed" ]]; then
            start_index=$((i + 1))
            break
        fi
    done

    # Run tests starting from where it left off
    for (( i = start_index; i < ${#test_cases[@]}; i++ )); do
        echo "Running: ${test_cases[$i]}"
        ${test_cases[$i]}
        if [ $? -eq 0 ]; then
            echo "${test_cases[$i]}" > "$STATE_FILE"
        else
            echo "Test failed, stopping execution."
            exit 1
        fi
    done

    # Clean up the state file if all tests are completed
    rm -f "$STATE_FILE"
}

run_tests
