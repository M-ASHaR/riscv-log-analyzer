setup:
	@command -v bash >/dev/null || (echo "Error: bash not found"; exit 1)
	@command -v grep >/dev/null || (echo "Error: grep not found"; exit 1)
	@command -v awk >/dev/null || (echo "Error: awk not found"; exit 1)
	@command -v sed >/dev/null || (echo "Error: sed not found"; exit 1)
	@command -v tr >/dev/null || (echo "Error: tr not found"; exit 1)
	@echo "All required tools are available."

all:
	@mkdir -p output
	@echo "Analyzing all test logs..."
	@./scripts/analyze.sh test_data/sample_sim.log --output output/sample_sim.txt || true
	@./scripts/analyze.sh test_data/sample_pass.log --output output/sample_pass.txt || true
	@./scripts/analyze.sh test_data/sample_fail.log --output output/sample_fail.txt || true
	@echo "Analysis complete. Reports are in output/"


test:
	@echo "Running analyzer tests..."
	@./scripts/analyze.sh test_data/sample_sim.log > /tmp/sample_sim_test.txt || true
	@grep -q "Total tests: 6" /tmp/sample_sim_test.txt
	@grep -q "Passed: 4 (66.7%)" /tmp/sample_sim_test.txt
	@grep -q "Failed: 1 (16.7%)" /tmp/sample_sim_test.txt
	@grep -q "Skipped: 1 (16.7%)" /tmp/sample_sim_test.txt
	@grep -q -- "--- Verdict: FAIL ---" /tmp/sample_sim_test.txt
	@echo "sample_sim.log: PASS"

	@./scripts/analyze.sh test_data/sample_pass.log > /tmp/sample_pass_test.txt
	@grep -q "Total tests: 4" /tmp/sample_pass_test.txt
	@grep -q "Passed: 4 (100.0%)" /tmp/sample_pass_test.txt
	@grep -q -- "--- Verdict: PASS ---" /tmp/sample_pass_test.txt
	@echo "sample_pass.log: PASS"	

clean:
	@rm -f output/*
	@echo "Generated output files removed."

help:
	@echo "RISC-V Log Analyzer - Available Targets"
	@echo
	@echo "  make setup   Check required tools"
	@echo "  make all     Analyze all test logs"
	@echo "  make test    Run automated tests"
	@echo "  make report  Generate summary report"
	@echo "  make clean   Remove generated output files"
	@echo "  make help    Show this help message"

report:
	@./scripts/generate_report.sh				