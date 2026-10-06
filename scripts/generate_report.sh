#!/bin/bash
report_date=$(date '+%Y-%m-%d %H:%M:%S')


mkdir -p output

echo "RISC-V Log Analyzer Summary Report" > output/summary.txt
echo "==================================" >> output/summary.txt
echo "Generated: $report_date" >> output/summary.txt
echo >> output/summary.txt

echo "Sample Simulation Log:" >> output/summary.txt
./scripts/analyze.sh test_data/sample_sim.log >> output/summary.txt || true

echo >> output/summary.txt
echo "Sample Pass Log:" >> output/summary.txt
./scripts/analyze.sh test_data/sample_pass.log >> output/summary.txt

echo >> output/summary.txt
echo "Sample Fail Log:" >> output/summary.txt
./scripts/analyze.sh test_data/sample_fail.log >> output/summary.txt || true

echo "Report generated: output/summary.txt at $report_date"