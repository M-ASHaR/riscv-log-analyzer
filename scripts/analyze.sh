#!/bin/bash
set -euo pipefail

#checking if log file is provided or not
if [[ $# -eq 0 ]]; then
	echo "Error: No log file provided."
	exit 11
fi

#checking if provided log file exists or not
check_file(){
	if [[ ! -f "$1" ]]; then
		echo "Error: File not Found: $1"
		exit 1
	fi
}

check_file "$1"

#counting the test results and rates of pass, fail and skip
passed=$(grep -c "TEST PASS" "$1")
failed=$(grep -c "TEST FAIL" "$1")
skipped=$(grep -c "TEST SKIP" "$1")

total=$((passed + failed + skipped))

pass_rate=$(awk "BEGIN {printf \"%.1f\", ($passed / $total) * 100"})
fail_rate=$(awk "BEGIN {printf \"%.1f\", ($failed / $total) * 100}")
skip_rate=$(awk "BEGIN {printf \"%.1f\", ($skipped / $total) * 100}")

failed_tests=$(grep "TEST FAIL" "$1" | awk '{print $5}')

echo "Passed: $passed (${pass_rate}%)"
echo "Failed: $failed (${fail_rate}%)"
echo "Skipped: $skipped (${skip_rate}%)"
echo "Total: $total"
#echo "Pass Rate: ${pass_rate}%"
echo "Failed Tests: "
echo "$failed_tests"

#extracting test names and execution times
timings=$(grep "TEST PASS\|TEST FAIL" "$1" | awk '{print $5, $6}' | tr -d '()' | sed 's/s$//')
#echo "$timings"
formatted_timings=$(echo "$timings" | awk '{print $1 ": " $2 "s"}')
echo "Execution Times:"
echo "$formatted_timings"

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
    printf "Min: %.2fs (%s)\n", min, min_test
    printf "Max: %.2fs (%s)\n", max, max_test
    printf "Avg: %.2fs\n", sum / count
}')

echo "$timing_stats"