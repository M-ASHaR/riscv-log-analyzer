#!/bin/bash
set -euo pipefail

# for arg in "$@"; do
#     if [[ "$arg" == "--format" ]]; then
#         echo "Format option found"
#     fi
# done


#for --help
if [[ ${1:-} == "--help" ]]; then 
	echo "--- RISC-V Simulation Log Analyzer ---"
	echo
	echo "Usage:"
	echo
  	echo "./scripts/analyze.sh <log_file> [options]"
	echo "Options:"
	echo "--format [text|csv]   Output format"
  	echo "--output <path>       Write output to a file"
  	echo "--verbose             Show detailed information"
  	echo "--help                Show this help message"
	exit 0
fi

format="text"
output=""
verbose=false
log_file=""
while [[ $# -gt 0 ]]; do

    if [[ "$1" == "--format" ]]; then
        format="$2"
        shift 2

    elif [[ "$1" == "--output" ]]; then
        output="$2"
        shift 2

    elif [[ "$1" == "--verbose" ]]; then
        verbose=true
        shift

    else
        log_file="$1"
        shift
    fi

done
#checking parser working
# echo "Log file: $log_file"
# echo "Format: $format"
# echo "Output: $output"
# echo "Verbose: $verbose"

#checking if log file is provided or not
if [[ -z "$log_file" ]]; then
	echo "Error: No log file provided."
	exit 1
fi

#checking if provided log file exists or not
check_file(){
	if [[ ! -f "$log_file" ]]; then
		echo "Error: File not Found: $log_file"
		exit 1
	fi
}
write_output(){
	# If an output path is provided, redirect all script output to that file
    if [[ -n "$output" ]]; then
		# Make sure the output directory exists before creating the file
        mkdir -p "$(dirname "$output")"
		# Redirect standard output so all following echo commands go to the file
        exec > "$output"
    fi
}

check_file "$log_file"
write_output

#counting the test results and rates of pass, fail and skip
#grep is returning 1 when no match is found so || true is preventing set -e from stoping the execution
passed=$(grep -c "TEST PASS" "$log_file" || true)
failed=$(grep -c "TEST FAIL" "$log_file" || true)
skipped=$(grep -c "TEST SKIP" "$log_file" || true)

total=$((passed + failed + skipped))

pass_rate=$(awk "BEGIN {printf \"%.1f\", ($passed / $total) * 100"})
fail_rate=$(awk "BEGIN {printf \"%.1f\", ($failed / $total) * 100}")
skip_rate=$(awk "BEGIN {printf \"%.1f\", ($skipped / $total) * 100}")

failed_tests=$(grep "TEST FAIL" "$log_file" | awk '{print $5}' || true)
#extracting test names and execution times
timings=$(grep "TEST PASS\|TEST FAIL" "$log_file" | awk '{print $5, $6}' | tr -d '()' | sed 's/s$//')
#echo "$timings"
formatted_timings=$(echo "$timings" | awk '{print $1 ": " $2 "s"}')
timing_stats=$(echo "$timings" | awk '
BEGIN {
    min = 999999
    max = 0
}
{
    if ($2 < min) {
        min = $2
        min_test = $1
    }

    if ($2 > max) {
        max = $2
        max_test = $1
    }

    sum += $2
    count++
}
END {
    printf "Min time: %.2fs (%s)\n", min, min_test
printf "Max time: %.2fs (%s)\n", max, max_test
printf "Avg time: %.2fs\n", sum / count
}')


if [[ "$format" == "text" ]]; then

    echo "=== RISC-V Simulation Log Analysis ==="
    echo
    echo "Log file: $log_file"
    echo
    echo "--- Results Summary ---"
    echo

    echo "Total tests: $total"
    echo
    echo "Passed: $passed (${pass_rate}%)"
    echo "Failed: $failed (${fail_rate}%)"
    echo "Skipped: $skipped (${skip_rate}%)"

    echo
    echo "--- Failed Tests ---"
    echo

    echo "$failed_tests"

    echo
    echo "--- Execution Times ---"
    echo

    echo "$formatted_timings"

    echo
    echo "--- Timing Statistics ---"
    echo

    echo "$timing_stats"

    echo

    if [[ $failed -eq 0 ]]; then
        echo "--- Verdict: PASS ---"
    else
        echo "--- Verdict: FAIL ---"
    fi

elif [[ "$format" == "csv" ]]; then

    echo "Test Results"
    echo "Test Name,Status,Execution Time"

    grep "TEST PASS\|TEST FAIL\|TEST SKIP" "$log_file" | awk '
    {
        test_name = $5
        status = $4
        time = $6

        gsub(/[():]/, "", status)
        gsub(/[()]/, "", time)

        if (status == "SKIP") {
            time = "N/A"
        } else {
            sub(/s$/, "", time)
            time = time "s"
        }

        print test_name "," status "," time
    }'

    echo
    echo "Summary"
    echo "Metric,Value"
    echo "Total Tests,$total"
    echo "Passed,$passed"
    echo "Failed,$failed"
    echo "Skipped,$skipped"
    echo "Pass Rate,${pass_rate}%"
    echo "Fail Rate,${fail_rate}%"
    echo "Skip Rate,${skip_rate}%"

    echo
    echo "Timing Statistics"
    echo "Metric,Value"

    echo "$timing_stats" | awk '
    /Min time/ {
        gsub(/[()]/, "", $4)
        print "Minimum Time," $3
        print "Minimum Time Test," $4
    }
    /Max time/ {
        gsub(/[()]/, "", $4)
        print "Maximum Time," $3
        print "Maximum Time Test," $4
    }
    /Avg time/ {
        print "Average Time," $3
    }'

    echo
    if [[ $failed -eq 0 ]]; then
        echo "Verdict,PASS"
    else
        echo "Verdict,FAIL"
    fi

else
    echo "Error: Invalid format: $format"
    echo "Valid formats are: text, csv"
    exit 1
fi

# Set exit status based on test results
if [[ $failed -eq 0 ]]; then
    exit 0
else
    exit 1
fi