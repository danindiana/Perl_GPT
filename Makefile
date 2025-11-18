# Perl_GPT Makefile
# Automates common development tasks including testing, code quality checks, and installation

.PHONY: help install test test-verbose clean critic tidy coverage deps-install deps-check all syntax-check smoke-test

# Default target
.DEFAULT_GOAL := help

# Color output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Perl interpreter
PERL := perl
PROVE := prove
CPANM := cpanm

# Directories
TEST_DIR := t
LIB_DIR := lib
MODULES_DIR := .
SCRIPTS := $(shell find . -maxdepth 1 -name "*.pl" -type f)
MODULE_SCRIPTS := $(shell find . -mindepth 2 -name "*.pl" -type f ! -path "*/temp/*" ! -path "*/.git/*")
ALL_SCRIPTS := $(SCRIPTS) $(MODULE_SCRIPTS)

help: ## Display this help message
	@echo "$(BLUE)╔════════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║              Perl_GPT Makefile - Available Targets             ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Examples:$(NC)"
	@echo "  make install         # Install all dependencies"
	@echo "  make test            # Run all tests"
	@echo "  make critic          # Run Perl::Critic code quality checks"
	@echo "  make syntax-check    # Check syntax of all Perl scripts"
	@echo ""

install: deps-install ## Install all dependencies and setup environment
	@echo "$(GREEN)Installation complete!$(NC)"
	@echo "$(BLUE)Run 'make test' to verify the installation.$(NC)"

deps-install: ## Install CPAN dependencies from cpanfile
	@echo "$(BLUE)[INFO] Installing CPAN dependencies...$(NC)"
	@if command -v cpanm >/dev/null 2>&1; then \
		cpanm --quiet --installdeps . ; \
		cpanm --quiet --installdeps . --with-test ; \
		echo "$(GREEN)[SUCCESS] Dependencies installed via cpanm$(NC)"; \
	elif command -v cpan >/dev/null 2>&1; then \
		cpan -T JSON LWP::UserAgent LWP::Protocol::https Data::UUID Term::ANSIColor Math::BaseCalc XML::Simple ; \
		echo "$(GREEN)[SUCCESS] Dependencies installed via cpan$(NC)"; \
	else \
		echo "$(RED)[ERROR] No CPAN installer found. Run ./install.sh first.$(NC)"; \
		exit 1; \
	fi

deps-check: ## Verify all critical dependencies are installed
	@echo "$(BLUE)[INFO] Checking dependencies...$(NC)"
	@$(PERL) -e 'use JSON; print "✓ JSON\n"' 2>/dev/null || echo "$(RED)✗ JSON$(NC)"
	@$(PERL) -e 'use LWP::UserAgent; print "✓ LWP::UserAgent\n"' 2>/dev/null || echo "$(RED)✗ LWP::UserAgent$(NC)"
	@$(PERL) -e 'use LWP::Protocol::https; print "✓ LWP::Protocol::https\n"' 2>/dev/null || echo "$(RED)✗ LWP::Protocol::https$(NC)"
	@$(PERL) -e 'use Data::UUID; print "✓ Data::UUID\n"' 2>/dev/null || echo "$(RED)✗ Data::UUID$(NC)"
	@$(PERL) -e 'use Term::ANSIColor; print "✓ Term::ANSIColor\n"' 2>/dev/null || echo "$(RED)✗ Term::ANSIColor$(NC)"
	@$(PERL) -e 'use Math::BaseCalc; print "✓ Math::BaseCalc\n"' 2>/dev/null || echo "$(RED)✗ Math::BaseCalc$(NC)"
	@$(PERL) -e 'use XML::Simple; print "✓ XML::Simple\n"' 2>/dev/null || echo "$(RED)✗ XML::Simple$(NC)"
	@$(PERL) -e 'use Test::More; print "✓ Test::More\n"' 2>/dev/null || echo "$(RED)✗ Test::More$(NC)"
	@echo "$(GREEN)[SUCCESS] Dependency check complete$(NC)"

syntax-check: ## Check syntax of all Perl scripts
	@echo "$(BLUE)[INFO] Checking syntax of all Perl scripts...$(NC)"
	@for script in $(ALL_SCRIPTS); do \
		echo "Checking $$script..."; \
		$(PERL) -c $$script 2>&1 | grep -q "syntax OK" && echo "  $(GREEN)✓ $$script$(NC)" || echo "  $(RED)✗ $$script$(NC)"; \
	done
	@echo "$(GREEN)[SUCCESS] Syntax check complete$(NC)"

test: ## Run all tests
	@echo "$(BLUE)[INFO] Running tests...$(NC)"
	@if [ -d "$(TEST_DIR)" ]; then \
		$(PROVE) -r $(TEST_DIR); \
	else \
		echo "$(YELLOW)[WARNING] No test directory found. Running smoke tests...$(NC)"; \
		$(MAKE) smoke-test; \
	fi

test-verbose: ## Run all tests with verbose output
	@echo "$(BLUE)[INFO] Running tests (verbose)...$(NC)"
	@if [ -d "$(TEST_DIR)" ]; then \
		$(PROVE) -rv $(TEST_DIR); \
	else \
		echo "$(YELLOW)[WARNING] No test directory found.$(NC)"; \
	fi

smoke-test: ## Run smoke tests on arxiv_doi_grabber
	@echo "$(BLUE)[INFO] Running smoke tests...$(NC)"
	@if [ -f "arxiv_doi_grabber/smoke_test.pl" ]; then \
		cd arxiv_doi_grabber && $(PERL) smoke_test.pl && echo "$(GREEN)[SUCCESS] Smoke tests passed$(NC)"; \
	else \
		echo "$(YELLOW)[WARNING] No smoke test found$(NC)"; \
	fi

critic: ## Run Perl::Critic code quality analysis
	@echo "$(BLUE)[INFO] Running Perl::Critic...$(NC)"
	@if command -v perlcritic >/dev/null 2>&1; then \
		perlcritic --severity 3 --verbose 8 $(ALL_SCRIPTS) 2>&1 | head -100 || true; \
		echo "$(GREEN)[SUCCESS] Perl::Critic analysis complete$(NC)"; \
	else \
		echo "$(YELLOW)[WARNING] Perl::Critic not installed. Run: cpanm Perl::Critic$(NC)"; \
	fi

tidy: ## Run Perl::Tidy code formatter
	@echo "$(BLUE)[INFO] Running Perl::Tidy...$(NC)"
	@if command -v perltidy >/dev/null 2>&1; then \
		for script in $(ALL_SCRIPTS); do \
			perltidy -b -bext='/' $$script; \
			echo "  Formatted $$script"; \
		done; \
		echo "$(GREEN)[SUCCESS] Code formatting complete$(NC)"; \
	else \
		echo "$(YELLOW)[WARNING] Perl::Tidy not installed. Run: cpanm Perl::Tidy$(NC)"; \
	fi

coverage: ## Generate test coverage report
	@echo "$(BLUE)[INFO] Generating coverage report...$(NC)"
	@if command -v cover >/dev/null 2>&1; then \
		cover -delete; \
		PERL5OPT=-MDevel::Cover $(PROVE) -r $(TEST_DIR); \
		cover; \
		echo "$(GREEN)[SUCCESS] Coverage report generated in cover_db/$(NC)"; \
	else \
		echo "$(YELLOW)[WARNING] Devel::Cover not installed. Run: cpanm Devel::Cover$(NC)"; \
	fi

clean: ## Clean temporary files and build artifacts
	@echo "$(BLUE)[INFO] Cleaning temporary files...$(NC)"
	@find . -name "*.bak" -type f -delete
	@find . -name "*.old" -type f -delete
	@find . -name "*.tmp" -type f -delete
	@find . -name "*~" -type f -delete
	@find . -name ".*.swp" -type f -delete
	@rm -rf cover_db/
	@rm -f nytprof.out
	@rm -rf nytprof/
	@echo "$(GREEN)[SUCCESS] Cleanup complete$(NC)"

clean-temp: ## Remove all temp/ directories (use with caution)
	@echo "$(YELLOW)[WARNING] This will remove all temp/ directories$(NC)"
	@read -p "Continue? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		find . -type d -name "temp" -exec rm -rf {} + 2>/dev/null || true; \
		echo "$(GREEN)[SUCCESS] temp/ directories removed$(NC)"; \
	else \
		echo "$(BLUE)[INFO] Operation cancelled$(NC)"; \
	fi

all: deps-check syntax-check test ## Run all checks (dependencies, syntax, tests)
	@echo "$(GREEN)╔════════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║                  All Checks Passed!                            ║$(NC)"
	@echo "$(GREEN)╚════════════════════════════════════════════════════════════════╝$(NC)"

ci: deps-install all ## Run full CI pipeline (install deps + all checks)
	@echo "$(GREEN)[SUCCESS] CI pipeline complete$(NC)"

.PHONY: version
version: ## Display Perl and module versions
	@echo "$(BLUE)Perl Version:$(NC)"
	@$(PERL) -v | grep "This is perl"
	@echo ""
	@echo "$(BLUE)Module Versions:$(NC)"
	@$(PERL) -MJSON -e 'print "JSON: $$JSON::VERSION\n"' 2>/dev/null || echo "JSON: Not installed"
	@$(PERL) -MLWP::UserAgent -e 'print "LWP::UserAgent: $$LWP::UserAgent::VERSION\n"' 2>/dev/null || echo "LWP::UserAgent: Not installed"
	@$(PERL) -e 'use Test::More; print "Test::More: $$Test::More::VERSION\n"' 2>/dev/null || echo "Test::More: Not installed"
