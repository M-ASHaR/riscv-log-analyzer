# Usage Guide

## Basic Usage

Run the analyzer with a log file:

./scripts/analyze.sh test_data/sample_sim.log

## Output Formats

Text output is used by default:

./scripts/analyze.sh test_data/sample_sim.log

CSV output:

./scripts/analyze.sh test_data/sample_sim.log --format csv

## Save Output

Save the analysis to a file:

./scripts/analyze.sh test_data/sample_sim.log --output output/result.txt

## Verbose Mode

Use verbose mode to display additional analysis information:

./scripts/analyze.sh test_data/sample_sim.log --verbose

## Help

Display available options:

./scripts/analyze.sh --help

## Makefile Commands

make setup
make all
make test
make report
make clean
make help