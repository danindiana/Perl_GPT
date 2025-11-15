# Bare Metal Setup Guide

This guide provides step-by-step instructions for setting up the `metadata_extractor.pl` script on a bare metal system (fresh Linux/Unix installation).

## Quick Start

```bash
# Clone the repository
git clone https://github.com/danindiana/Perl_GPT.git
cd Perl_GPT/arxiv_doi_grabber

# Run automated installation
./install_deps.sh

# Run smoke test to verify
./smoke_test.pl

# You're ready to go!
./metadata_extractor.pl --help
```

---

## Detailed Installation Steps

### Prerequisites

#### Required
- **Operating System**: Linux, macOS, or Unix-like system
- **Perl**: Version 5.10 or higher (usually pre-installed on Linux/macOS)
- **Internet Connection**: For installing dependencies and fetching metadata
- **Disk Space**: ~50MB for Perl modules

#### Optional
- `curl` or `wget` - For downloading cpanm
- `git` - For cloning the repository
- `make` - May be required for some CPAN modules

### Step 1: Verify Perl Installation

Check if Perl is installed and meets version requirements:

```bash
perl -v
```

Expected output should show Perl 5.10 or higher:
```
This is perl 5, version 38, subversion 2 (v5.38.2) built for x86_64-linux-gnu-thread-multi
```

If Perl is not installed:

**Debian/Ubuntu:**
```bash
sudo apt-get update
sudo apt-get install perl
```

**RHEL/CentOS/Fedora:**
```bash
sudo yum install perl
# or
sudo dnf install perl
```

**macOS:**
```bash
# Perl comes pre-installed on macOS
# To install a specific version, use perlbrew:
curl -L https://install.perlbrew.pl | bash
perlbrew install perl-5.38.2
perlbrew use perl-5.38.2
```

### Step 2: Clone the Repository

```bash
git clone https://github.com/danindiana/Perl_GPT.git
cd Perl_GPT/arxiv_doi_grabber
```

Or download and extract if git is not available:
```bash
curl -L https://github.com/danindiana/Perl_GPT/archive/refs/heads/main.zip -o perl-gpt.zip
unzip perl-gpt.zip
cd Perl_GPT-main/arxiv_doi_grabber
```

### Step 3: Automated Installation (Recommended)

Run the installation script:

```bash
chmod +x install_deps.sh
./install_deps.sh
```

The script will:
1. ✓ Check Perl version
2. ✓ Install `cpanm` (CPAN minus) if not present
3. ✓ Install required Perl modules
4. ✓ Verify all dependencies
5. ✓ Check script syntax
6. ✓ Display installation summary

**Expected output:**
```
========================================
Checking Perl Installation
========================================

[INFO] Detected Perl version: This is perl 5, version 38...
[SUCCESS] Perl version is sufficient (>= 5.10)

========================================
Checking CPAN Installer (cpanm)
========================================

[SUCCESS] cpanm is already installed

========================================
Installing Perl Dependencies
========================================

[INFO] Installing dependencies from cpanfile...
[SUCCESS] All dependencies installed successfully

========================================
Verifying Installation
========================================

[SUCCESS] LWP::UserAgent - OK
[SUCCESS] JSON - OK
[SUCCESS] File::Find - OK
[SUCCESS] Digest::MD5 - OK
[SUCCESS] Time::HiRes - OK

[SUCCESS] All required modules are installed

========================================
Verifying Script Syntax
========================================

[SUCCESS] Script syntax is valid

========================================
Installation Complete
========================================
```

### Step 4: Manual Installation (Alternative)

If the automated script fails or you prefer manual installation:

#### 4.1 Install cpanm

```bash
curl -L https://cpanmin.us | perl - App::cpanminus
```

Or using system packages:

**Debian/Ubuntu:**
```bash
sudo apt-get install cpanminus
```

**RHEL/CentOS/Fedora:**
```bash
sudo yum install perl-App-cpanminus
```

#### 4.2 Install Dependencies

Using cpanfile (recommended):
```bash
cpanm --installdeps .
```

Or manually:
```bash
cpanm LWP::UserAgent
cpanm LWP::Protocol::https
cpanm JSON
```

Using system packages (Debian/Ubuntu):
```bash
sudo apt-get install libwww-perl libjson-perl
```

Using system packages (RHEL/CentOS/Fedora):
```bash
sudo yum install perl-libwww-perl perl-JSON
```

#### 4.3 Verify Installation

```bash
perl -MLWP::UserAgent -e 'print "LWP::UserAgent OK\n"'
perl -MJSON -e 'print "JSON OK\n"'
perl -c metadata_extractor.pl
```

### Step 5: Run Smoke Test

Verify everything is working:

```bash
chmod +x smoke_test.pl
./smoke_test.pl
```

**Expected output:**
```
============================================================
Metadata Extractor - Smoke Test Suite
============================================================

[INFO] Starting smoke tests...

============================================================
Environment Tests
============================================================

[TEST] Perl version >= 5.10 ... PASS

============================================================
Dependency Tests
============================================================

[TEST] Module available: LWP::UserAgent ... PASS
[TEST] Module available: JSON ... PASS
...

============================================================
Test Summary
============================================================

Total tests run:    15
Tests passed:       15
Tests failed:       0

SMOKE TEST PASSED

All systems operational! The metadata extractor is ready to use.
```

### Step 6: First Test Run

Make the script executable:
```bash
chmod +x metadata_extractor.pl
```

View help:
```bash
./metadata_extractor.pl --help
```

Run with test fixtures:
```bash
./metadata_extractor.pl --dir=./test/fixtures --output=./temp
```

Follow the prompts to select files for processing.

---

## Troubleshooting

### Issue: "LWP::UserAgent not found"

**Solution:**
```bash
cpanm LWP::UserAgent
cpanm LWP::Protocol::https  # For HTTPS support
```

Or:
```bash
sudo apt-get install libwww-perl libssl-dev  # Debian/Ubuntu
```

### Issue: "Permission denied" when installing modules

**Option 1: Local installation (no root required)**
```bash
cpanm --local-lib=~/perl5 LWP::UserAgent JSON
echo 'eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)' >> ~/.bashrc
source ~/.bashrc
```

**Option 2: Use sudo**
```bash
sudo cpanm LWP::UserAgent JSON
```

### Issue: "SSL certificate verify failed"

**Solution:**
```bash
# Install SSL certificates
sudo apt-get install ca-certificates  # Debian/Ubuntu
sudo yum install ca-certificates      # RHEL/CentOS

# Or install Mozilla::CA
cpanm Mozilla::CA
```

### Issue: "Can't locate JSON.pm"

**Solution:**
```bash
# Ensure module is installed
cpanm JSON

# Check if it's in a local lib
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
```

### Issue: Smoke test fails with network errors

**Cause:** Tests are trying to connect to external services

**Solution:**
- Ensure internet connectivity
- Check firewall settings
- Some tests can fail if DOI/arXiv services are down (this is normal)

### Issue: Script hangs waiting for input

**Cause:** Script expects user input for file selection

**Solution:**
```bash
# Provide input via echo
echo "0" | ./metadata_extractor.pl --dir=./test/fixtures --output=./temp

# Or use Ctrl+D to skip selection
```

---

## Verification Checklist

Use this checklist to verify your installation:

- [ ] Perl version >= 5.10 installed
- [ ] `cpanm` available
- [ ] `LWP::UserAgent` module installed
- [ ] `JSON` module installed
- [ ] `metadata_extractor.pl` has valid syntax (`perl -c`)
- [ ] Script is executable (`chmod +x`)
- [ ] Smoke test passes (`./smoke_test.pl`)
- [ ] Help output works (`./metadata_extractor.pl --help`)
- [ ] Can run with test fixtures

---

## System-Specific Notes

### Ubuntu 22.04 LTS

```bash
# Install prerequisites
sudo apt-get update
sudo apt-get install -y perl cpanminus libwww-perl libjson-perl

# Clone and run
git clone https://github.com/danindiana/Perl_GPT.git
cd Perl_GPT/arxiv_doi_grabber
./smoke_test.pl
```

### Ubuntu 20.04 LTS

```bash
# Same as 22.04, Perl 5.30 is included
sudo apt-get update
sudo apt-get install -y perl cpanminus libwww-perl libjson-perl
```

### RHEL/CentOS 8+

```bash
# Enable PowerTools/CRB repository for some dependencies
sudo dnf install -y epel-release
sudo dnf config-manager --set-enabled powertools  # or crb on newer versions

# Install packages
sudo dnf install -y perl perl-App-cpanminus perl-libwww-perl perl-JSON
```

### macOS (Monterey, Ventura, Sonoma)

```bash
# macOS includes Perl by default
# Install cpanm via curl
curl -L https://cpanmin.us | perl - --sudo App::cpanminus

# Install dependencies
cpanm LWP::UserAgent LWP::Protocol::https JSON
```

### Minimal/Containerized Environments

If running in Docker or minimal environments:

```dockerfile
FROM perl:5.38-slim

WORKDIR /app
COPY . .

# Install dependencies
RUN cpanm --notest LWP::UserAgent LWP::Protocol::https JSON

# Run smoke test
RUN perl smoke_test.pl

ENTRYPOINT ["perl", "metadata_extractor.pl"]
```

---

## Offline Installation

For systems without internet access:

### 1. Download Dependencies on Connected System

```bash
# Create a local CPAN mirror with required modules
mkdir -p perl-deps
cd perl-deps
cpanm --save-dists=. LWP::UserAgent JSON
```

### 2. Transfer to Offline System

```bash
# Copy perl-deps directory to offline system
scp -r perl-deps user@offline-system:/path/to/
```

### 3. Install on Offline System

```bash
cd /path/to/perl-deps
cpanm --from . LWP::UserAgent JSON
```

---

## Performance Tuning

### For Large-Scale Deployments

If processing many files:

1. **Increase timeout** in metadata_extractor.pl:
   ```perl
   $ua->timeout(30);  # Increase from 10 to 30 seconds
   ```

2. **Enable parallel processing** (future enhancement)

3. **Use local caching** to avoid repeated API calls

### For Slow Networks

Adjust LWP timeout and retry logic:
```perl
$ua->timeout(60);
$ua->max_redirect(3);
```

---

## Security Considerations

### Permissions

Run with minimal privileges:
```bash
# Create dedicated user
sudo useradd -m -s /bin/bash metadata-extractor

# Install modules in user's home
sudo -u metadata-extractor cpanm --local-lib=~/perl5 LWP::UserAgent JSON
```

### Network Security

Ensure HTTPS is working:
```bash
perl -MLWP::Protocol::https -e 'print "HTTPS support OK\n"'
```

### File Permissions

Set appropriate permissions:
```bash
chmod 755 metadata_extractor.pl
chmod 644 cpanfile readme.md
```

---

## Next Steps

After successful installation:

1. **Read the documentation**: `less readme.md`
2. **Understand the workflow**: `perldoc metadata_extractor.pl`
3. **Test with your data**: Place `.txt` files in a directory and run
4. **Configure for production**: Set up appropriate directories and permissions
5. **Monitor performance**: Track API response times and errors
6. **Set up backups**: Back up generated JSON files regularly

---

## Getting Help

If you encounter issues:

1. **Check this guide** - Most common issues are covered
2. **Run smoke test** - `./smoke_test.pl` will identify problems
3. **Check logs** - Error messages usually indicate the issue
4. **Review CI/CD documentation** - `CI_CD_REVIEW.md` has detailed info
5. **Open an issue** - https://github.com/danindiana/Perl_GPT/issues

---

## Appendix: Environment Variables

Optional environment variables you can set:

```bash
# Perl module path (if using local::lib)
export PERL5LIB=~/perl5/lib/perl5

# CPAN mirror (for faster downloads)
export PERL_CPANM_OPT="--mirror https://cpan.metacpan.org"

# Disable SSL verification (NOT recommended for production)
export PERL_LWP_SSL_VERIFY_HOSTNAME=0
```

Add to `~/.bashrc` or `~/.profile` for persistence.

---

## Appendix: Minimal System Requirements

**Hardware:**
- CPU: 1 core (2+ recommended for parallel processing)
- RAM: 256MB minimum (512MB recommended)
- Disk: 100MB (for Perl + modules)

**Software:**
- Perl 5.10+
- 10MB for CPAN modules
- Internet connection for initial setup and metadata fetching

**Tested Platforms:**
- ✓ Ubuntu 20.04, 22.04, 24.04
- ✓ Debian 10, 11, 12
- ✓ RHEL/CentOS 8, 9
- ✓ macOS 12 (Monterey), 13 (Ventura), 14 (Sonoma)
- ✓ Alpine Linux 3.18+ (with perl package)

---

## Success Criteria

Your installation is successful if:

1. ✓ `perl -v` shows version >= 5.10
2. ✓ `./smoke_test.pl` exits with code 0 (all tests pass)
3. ✓ `./metadata_extractor.pl --help` displays usage information
4. ✓ Can process test fixtures without errors
5. ✓ Generated JSON files are valid and contain expected data

**Congratulations! Your bare metal setup is complete.**
