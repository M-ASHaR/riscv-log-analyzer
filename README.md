# RISC-V Simulation Log Analyzer

A Bash-based tool that reads RISC-V simulation log files and shows a summary of the test results.

It can count passed, failed, and skipped tests, calculate pass rates, show failed test names, and calculate execution time statistics.

## Installation

Clone the repository and move into the project directory.

```bash
cd riscv-log-analyzer
```

Make the scripts executable:

```bash
chmod +x scripts/*.sh
```

Check that the required tools are available:

```bash
make setup
```

## Usage

To analyze a log file:

```bash
./scripts/analyze.sh test_data/sample_sim.log
```

By default, the result is displayed in text format.

To use CSV format:

```bash
./scripts/analyze.sh test_data/sample_sim.log --format csv
```

To save the result to a file:

```bash
./scripts/analyze.sh test_data/sample_sim.log --output output/result.txt
```

To use verbose mode:

```bash
./scripts/analyze.sh test_data/sample_sim.log --verbose
```

To see the available options:

```bash
./scripts/analyze.sh --help
```

The Makefile can also be used for common tasks:

```bash
make setup
make all
make test
make report
make clean
make help
```

## Sample Output

Example output for `sample_fail.log`:

```text
=== RISC-V Simulation Log Analysis ===

Log file: test_data/sample_fail.log

--- Results Summary ---

Total tests: 6

Passed: 4 (66.7%)
Failed: 1 (16.7%)
Skipped: 1 (16.7%)

--- Failed Tests ---

rv32i-sll

--- Timing Statistics ---

Min time: 0.58s (rv32i-or)
Max time: 1.02s (rv32i-sll)
Avg time: 0.76s

--- Verdict: FAIL ---
```

The analyzer returns exit code `0` when all tests pass and exit code `1` when one or more tests fail.

Conclusion

The RISC-V Simulation Log Analyzer provides a simple way to convert raw simulation logs into useful test and timing information.

The project combines Bash scripting, Linux command-line tools, Makefile automation, Git version control, automated testing, and technical documentation.

It was developed as the MEDS Lab Module 1 Grand Assignment to demonstrate practical understanding of Linux-based development and automation workflows.
