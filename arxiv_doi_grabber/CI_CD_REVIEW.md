# CI/CD Pipeline Review: arxiv_doi_grabber

**Date**: 2025-11-15
**Project**: arxiv_doi_grabber
**Focus**: Bare Metal Setup & Smoke Testing

## Executive Summary

The `arxiv_doi_grabber` project currently **lacks any CI/CD infrastructure**. There are no automated build, test, or deployment pipelines. This review provides a comprehensive analysis of the current state and recommendations for implementing a robust CI/CD pipeline with emphasis on bare metal deployment and smoke testing.

---

## Current State Analysis

### 1. Project Structure

```
arxiv_doi_grabber/
├── metadata_extractor.pl    # Main Perl script
├── readme.md                 # Documentation
├── best_practices.md         # Best practices guide
└── temp/                     # Temporary directory
```

### 2. Missing Components

#### CI/CD Infrastructure
- ❌ No GitHub Actions workflows
- ❌ No Travis CI, CircleCI, or other CI/CD configs
- ❌ No automated testing framework
- ❌ No build automation scripts
- ❌ No deployment scripts

#### Dependency Management
- ❌ No `cpanfile` for CPAN dependencies
- ❌ No `Makefile.PL` or `Build.PL`
- ❌ No dependency lock file
- ⚠️  Dependencies only listed in README

#### Testing
- ❌ No unit tests
- ❌ No integration tests
- ❌ No smoke tests
- ❌ No test fixtures or sample data

#### Containerization
- ❌ No Dockerfile
- ❌ No docker-compose.yml
- ❌ No container registry integration

### 3. Dependencies

**Required Perl Modules** (from README):
- `LWP::UserAgent` - HTTP client for fetching metadata
- `JSON` - JSON parsing and encoding
- `File::Find` - Directory traversal (core module)
- `Digest::MD5` - MD5 hashing (core module)
- `Time::HiRes` - High-resolution time (core module)

**Additional Dependencies** (from script):
- `File::Basename` (core module)
- `Getopt::Long` (core module)
- `Pod::Usage` (core module)

**External Dependencies**:
- Internet connectivity (for DOI/arXiv API calls)
- Web services: dx.doi.org, arxiv.org

### 4. Current Installation Process

Manual installation documented in README:
```bash
cpan LWP::UserAgent JSON File::Find Digest::MD5 Time::HiRes
```

---

## Bare Metal Setup Analysis

### Prerequisites
- **Perl**: Version 5.10+ (tested: v5.38.2 ✓)
- **Operating System**: Linux, macOS, or Windows with Perl
- **Network**: Internet access for metadata fetching
- **Privileges**: Write access to output directories

### Installation Challenges

1. **Module Dependencies**
   - Non-core modules require CPAN or system package manager
   - No automated dependency resolution
   - No version pinning (potential compatibility issues)

2. **Environment Variability**
   - Different Perl installations (system vs. perlbrew vs. plenv)
   - Module installation locations vary
   - Potential permissions issues with system Perl

3. **No Validation**
   - No script to verify successful installation
   - No smoke test to confirm functionality
   - Manual testing required

---

## Smoke Test Requirements

A comprehensive smoke test should validate:

### 1. Environment Validation
- ✓ Perl version >= 5.10
- ✓ Required modules installed and loadable
- ✓ Script syntax validation
- ✓ Write permissions to output directory

### 2. Functional Validation
- ✓ Script can parse command-line arguments
- ✓ Can find and read test input files
- ✓ Can extract DOI patterns from test data
- ✓ Can extract arXiv patterns from test data
- ✓ Can write JSON output files
- ✓ JSON output is valid and well-formed

### 3. Network Validation (Optional)
- ✓ Can connect to dx.doi.org
- ✓ Can connect to arxiv.org
- ⚠️  Mock responses for CI environment

### 4. Error Handling
- ✓ Graceful handling of missing dependencies
- ✓ Proper error messages for invalid input
- ✓ Handling of network failures

---

## Recommendations

### Phase 1: Foundation (Immediate)

#### 1.1 Create `cpanfile` for Dependency Management
```perl
requires 'LWP::UserAgent', '>= 6.00';
requires 'JSON', '>= 4.00';

# Core modules (documentation)
# File::Find
# Digest::MD5
# Time::HiRes
# File::Basename
# Getopt::Long
# Pod::Usage
```

#### 1.2 Create Installation Script
`install_deps.sh`:
- Detect Perl version
- Install cpanm if not available
- Install dependencies from cpanfile
- Verify installation
- Report any failures

#### 1.3 Create Smoke Test Script
`smoke_test.pl`:
- Check all prerequisites
- Create test fixtures
- Run script with test data
- Validate output
- Clean up test artifacts
- Exit with appropriate code

#### 1.4 Create Test Fixtures
`test/fixtures/`:
- Sample `.txt` file with DOI links
- Sample `.txt` file with arXiv links
- Expected JSON output files
- Test edge cases

### Phase 2: CI/CD Pipeline (Priority)

#### 2.1 GitHub Actions Workflow
`.github/workflows/ci.yml`:
- **Triggers**: Push, PR to main/develop
- **Matrix Testing**: Multiple Perl versions (5.10, 5.20, 5.30, latest)
- **Operating Systems**: Ubuntu, macOS (Windows optional)
- **Steps**:
  1. Checkout code
  2. Setup Perl
  3. Install dependencies
  4. Run smoke tests
  5. Run unit tests (future)
  6. Generate coverage report (future)
  7. Archive test results

#### 2.2 Automated Checks
- **Linting**: Use `perlcritic` for code quality
- **Syntax Check**: `perl -c metadata_extractor.pl`
- **Security Scanning**: Scan dependencies for vulnerabilities
- **License Compliance**: Verify module licenses

### Phase 3: Testing Framework (Important)

#### 3.1 Unit Tests
- Test metadata extraction functions in isolation
- Test parsing functions
- Test file operations
- Use `Test::More` or `Test2::Suite`

#### 3.2 Integration Tests
- Test end-to-end workflow with mock data
- Test error handling paths
- Test user input validation

#### 3.3 Mock External Services
- Mock HTTP responses from DOI/arXiv
- Test offline operation
- Test rate limiting scenarios

### Phase 4: Containerization (Optional)

#### 4.1 Dockerfile
- Base: `perl:5.38` or `perl:slim`
- Install dependencies
- Copy script
- Set up entry point
- Health check

#### 4.2 Docker Compose
- Define service
- Mount volumes for input/output
- Environment variables
- Network configuration

### Phase 5: Enhanced Deployment

#### 5.1 Release Automation
- Semantic versioning
- Changelog generation
- GitHub releases
- Distribution packaging

#### 5.2 Monitoring & Logging
- Structured logging
- Error tracking
- Performance metrics
- Usage analytics

---

## Implementation Priority Matrix

| Priority | Component | Impact | Effort | Status |
|----------|-----------|--------|--------|--------|
| 🔴 HIGH | Smoke test script | High | Low | Not Started |
| 🔴 HIGH | Installation script | High | Low | Not Started |
| 🔴 HIGH | GitHub Actions CI | High | Medium | Not Started |
| 🟡 MEDIUM | cpanfile | Medium | Low | Not Started |
| 🟡 MEDIUM | Test fixtures | Medium | Low | Not Started |
| 🟡 MEDIUM | Unit tests | High | Medium | Not Started |
| 🟢 LOW | Dockerfile | Low | Low | Not Started |
| 🟢 LOW | Code linting | Medium | Low | Not Started |

---

## Bare Metal Setup Procedure (Proposed)

### Step 1: Prerequisites Check
```bash
# Check Perl version
perl -v

# Check for cpanm (CPAN installer)
which cpanm || curl -L https://cpanmin.us | perl - App::cpanminus
```

### Step 2: Install Dependencies
```bash
# Option A: Using installation script (recommended)
./install_deps.sh

# Option B: Manual installation
cpanm --installdeps .

# Option C: System packages (Debian/Ubuntu)
sudo apt-get install libwww-perl libjson-perl
```

### Step 3: Verify Installation
```bash
# Run smoke test
./smoke_test.pl

# Or manual verification
perl -c metadata_extractor.pl
perl -e 'use LWP::UserAgent; use JSON; print "OK\n"'
```

### Step 4: Quick Test Run
```bash
# Create test directory with sample data
mkdir -p test_run
echo "CRAWLING: https://dx.doi.org/10.1234/example" > test_run/sample.txt

# Run script
./metadata_extractor.pl --dir=test_run --output=test_run

# Verify output
ls test_run/sample_extracted.json
```

---

## Smoke Test Specification

### Test Cases

#### TC1: Environment Validation
```
GIVEN a system with Perl installed
WHEN the smoke test runs
THEN it should verify:
  - Perl version >= 5.10
  - All required modules are loadable
  - Script has valid syntax
```

#### TC2: Basic Functionality
```
GIVEN a test file with one DOI link
WHEN the script processes the file
THEN it should:
  - Extract the DOI link correctly
  - Create a JSON output file
  - JSON contains the DOI in correct format
```

#### TC3: File Operations
```
GIVEN a test directory structure
WHEN the script scans for files
THEN it should:
  - Find all .txt files
  - Ignore non-.txt files
  - Create log file with correct naming
```

#### TC4: Error Handling
```
GIVEN invalid input or network errors
WHEN the script encounters errors
THEN it should:
  - Display appropriate error messages
  - Not crash or hang
  - Continue processing other files
```

---

## Security Considerations

### Current Security Posture

**Risks Identified**:
1. **Network Calls**: Unvalidated external HTTP requests
2. **File Operations**: Potential path traversal if input not sanitized
3. **Dependency Chain**: No vulnerability scanning of modules
4. **Input Validation**: Limited validation of user selection input

**Recommendations**:
1. Add URL validation before HTTP requests
2. Sanitize file paths (use File::Spec::canonpath)
3. Implement dependency scanning in CI
4. Add input sanitization for file selection
5. Consider HTTPS enforcement
6. Add rate limiting for API calls

---

## Performance Considerations

### Current Implementation
- Sequential processing of files
- Blocking HTTP requests
- No caching of metadata
- No parallel processing

### Optimization Opportunities
1. **Parallel Processing**: Process multiple files concurrently
2. **Async HTTP**: Non-blocking requests (AnyEvent::HTTP)
3. **Caching**: Cache metadata responses (CHI)
4. **Batch Processing**: Group API requests
5. **Connection Pooling**: Reuse HTTP connections

---

## Compliance & Licensing

### API Terms of Service
- **DOI (dx.doi.org)**: Check CrossRef API terms
- **arXiv.org**: Verify compliance with arXiv API policy
- **Rate Limiting**: Implement respectful request rates
- **User Agent**: Include contact information in UA string

### Code Licensing
- Current: Not specified in repository
- Recommendation: Add LICENSE file (MIT suggested in README template)

---

## Next Steps

### Immediate Actions (This Week)
1. ✅ Create this review document
2. ⏳ Create smoke test script
3. ⏳ Create installation script
4. ⏳ Add test fixtures
5. ⏳ Create cpanfile

### Short-term (Next 2 Weeks)
1. Implement GitHub Actions CI workflow
2. Add basic unit tests
3. Add code linting with perlcritic
4. Document bare metal setup procedure
5. Create sample test data

### Medium-term (Next Month)
1. Implement comprehensive test suite
2. Add Dockerfile for containerized testing
3. Set up automated releases
4. Add performance benchmarks
5. Security scanning integration

### Long-term (Next Quarter)
1. Performance optimizations
2. Enhanced error handling
3. Monitoring and observability
4. API rate limiting
5. Caching layer

---

## Conclusion

The `arxiv_doi_grabber` project currently has **no CI/CD infrastructure**, which presents risks for:
- **Reliability**: No automated testing to catch regressions
- **Portability**: Manual setup prone to errors
- **Maintainability**: No automated quality checks
- **Scalability**: No automated deployment process

**Critical Gaps**:
1. No smoke test to validate installation
2. No automated dependency management
3. No CI pipeline for quality assurance
4. No containerization for consistent environments

**Recommended First Steps**:
1. Create smoke test script (immediate value, low effort)
2. Create installation script (reduces setup friction)
3. Implement GitHub Actions CI (enables continuous validation)
4. Add test fixtures (enables smoke testing)

**Estimated Effort**:
- Smoke test + installation script: **4-6 hours**
- Basic GitHub Actions CI: **2-4 hours**
- Test fixtures: **2-3 hours**
- **Total for Phase 1**: ~10-15 hours

**ROI**: High - These improvements will:
- Reduce setup time from ~30min to ~5min
- Catch issues before deployment
- Enable confident refactoring
- Improve developer onboarding

---

## Appendix A: Reference CI/CD Tools

### For Perl Projects
- **CI Systems**: GitHub Actions, Travis CI, CircleCI
- **Test Frameworks**: Test::More, Test2::Suite, Prove
- **Code Quality**: Perl::Critic, Perl::Tidy
- **Coverage**: Devel::Cover
- **Dependency Management**: cpanm, carton, cpm
- **Containers**: Docker, Podman
- **Security**: CPAN::Audit, Safety checks

### Useful Perl GitHub Actions
- `shogo82148/actions-setup-perl@v1` - Setup Perl environment
- `perl-actions/install-with-cpanm@v1` - Install dependencies

---

## Appendix B: Sample Commands

### Manual Testing Commands
```bash
# Syntax check
perl -c metadata_extractor.pl

# Module check
perl -MLWP::UserAgent -e 1
perl -MJSON -e 1

# Help text
./metadata_extractor.pl --help

# Test run
./metadata_extractor.pl --dir=./temp --output=./temp
```

### Development Commands
```bash
# Run with verbose
perl -w metadata_extractor.pl

# Check for common issues
perlcritic metadata_extractor.pl

# Format code
perltidy metadata_extractor.pl

# Generate documentation
perldoc metadata_extractor.pl
```
