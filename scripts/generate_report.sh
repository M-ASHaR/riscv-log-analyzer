#!/bin/bash
report_date=$(date '+%Y-%m-%d %H:%M:%S')


mkdir -p output

echo "RISC-V Log Analyzer Summary Report" > output/summary.txt
echo "==================================" >> output/summary.txt
echo "Generated: $report_date" >> output/summary.txt
echo >> output/summary.txt

echo "Sample Simulation Log:" >> output/summary.txt
./scripts/analyze.sh test_data/sample_sim.log 2>/dev/null | sed $'s/\033\\[[0-9;]*m//g' || true

echo >> output/summary.txt
echo "Sample Pass Log:" >> output/summary.txt
./scripts/analyze.sh test_data/sample_pass.log 2>/dev/null | sed $'s/\033\\[[0-9;]*m//g'

echo >> output/summary.txt
echo "Sample Fail Log:" >> output/summary.txt
./scripts/analyze.sh test_data/sample_fail.log 2>/dev/null | sed $'s/\033\\[[0-9;]*m//g' || true


echo "Report generated: output/summary.txt at $report_date"


echo "Creating HTML report..."

cat > output/summary.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>RISC-V Log Analyzer Report</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background: #f4f4f4;
            color: #222;
        }

        .report {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 30px;
        }

        h1 {
            border-bottom: 2px solid #333;
            padding-bottom: 10px;
        }

        h2 {
            margin-top: 30px;
        }

        pre {
            background: #f0f0f0;
            padding: 15px;
            overflow-x: auto;
        }
    </style>
</head>


<body>

<div class="report">

<h1>RISC-V Log Analyzer Summary Report</h1>

<p>Generated: $report_date</p>

<h2>Sample Simulation Log</h2>

<pre>
$(./scripts/analyze.sh test_data/sample_sim.log 2>/dev/null | sed $'s/\033\\[[0-9;]*m//g' || true)
</pre>

<h2>Sample Pass Log</h2>

<pre>
$(./scripts/analyze.sh test_data/sample_pass.log 2>/dev/null | sed $'s/\033\\[[0-9;]*m//g')
</pre>

<h2>Sample Fail Log</h2>

<pre>
$(./scripts/analyze.sh test_data/sample_fail.log 2>/dev/null | sed $'s/\033\\[[0-9;]*m//g' || true)
</pre>

</div>

</body>
</html>
EOF

echo "HTML report generated: output/summary.html at $report_date"
