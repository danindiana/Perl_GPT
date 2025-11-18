#!/bin/bash

# Perl_GPT Dependency Installation Script
# Automates the installation of all required CPAN modules
# Supports multiple installation methods with fallback options

set -e  # Exit on error

# Color output for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script information
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Perl_GPT Dependency Installation Script              ║${NC}"
echo -e "${BLUE}║                   Version 1.0.0                                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check Perl version
print_info "Checking Perl version..."
PERL_VERSION=$(perl -e 'print $];')
PERL_VERSION_NUM=$(perl -e 'print sprintf("%.3f", $]);')

if (( $(echo "$PERL_VERSION_NUM < 5.034" | bc -l) )); then
    print_error "Perl version $PERL_VERSION is too old. Requires 5.34 or higher."
    exit 1
else
    print_success "Perl version $PERL_VERSION detected"
fi

# Detect OS and package manager
print_info "Detecting operating system..."
OS=""
PKG_MANAGER=""

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
    PKG_MANAGER="brew"
fi

print_success "Detected OS: $OS"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check for CPAN module installer
print_info "Checking for CPAN module installers..."
INSTALLER=""

if command_exists cpanm; then
    INSTALLER="cpanm"
    print_success "Found cpanm (App::cpanminus)"
elif command_exists cpan; then
    INSTALLER="cpan"
    print_success "Found cpan (CPAN.pm)"
else
    print_warning "No CPAN installer found. Installing cpanminus..."

    # Try to install cpanminus
    if curl -L https://cpanmin.us | perl - --sudo App::cpanminus; then
        INSTALLER="cpanm"
        print_success "Successfully installed cpanminus"
    else
        print_error "Failed to install cpanminus. Please install it manually."
        exit 1
    fi
fi

# Install system dependencies if needed
print_info "Installing system-level dependencies..."

install_system_deps() {
    case $PKG_MANAGER in
        apt)
            print_info "Using apt-get..."
            sudo apt-get update
            sudo apt-get install -y \
                build-essential \
                libssl-dev \
                libexpat1-dev \
                zlib1g-dev \
                libxml2-dev \
                libwww-perl \
                ca-certificates
            ;;
        yum|dnf)
            print_info "Using $PKG_MANAGER..."
            sudo $PKG_MANAGER install -y \
                gcc \
                make \
                openssl-devel \
                expat-devel \
                zlib-devel \
                libxml2-devel \
                perl-CPAN \
                ca-certificates
            ;;
        brew)
            print_info "Using Homebrew..."
            brew install openssl@3 expat libxml2
            ;;
        pacman)
            print_info "Using pacman..."
            sudo pacman -S --noconfirm \
                base-devel \
                openssl \
                expat \
                zlib \
                libxml2 \
                ca-certificates
            ;;
        *)
            print_warning "Unknown package manager. Skipping system dependencies."
            ;;
    esac
}

# Ask user if they want to install system dependencies
read -p "Install system-level dependencies? (y/n) [y]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    install_system_deps
    print_success "System dependencies installed"
else
    print_info "Skipping system dependencies"
fi

# Install CPAN modules
print_info "Installing CPAN modules from cpanfile..."
echo

if [[ "$INSTALLER" == "cpanm" ]]; then
    print_info "Using cpanm with local::lib support..."

    # Install dependencies
    cpanm --installdeps . --verbose

    # Install test dependencies
    read -p "Install test dependencies? (y/n) [y]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        cpanm --installdeps . --with-test --verbose
    fi

    # Install development dependencies
    read -p "Install development dependencies? (y/n) [n]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cpanm --installdeps . --with-develop --verbose
    fi

else
    print_info "Using cpan..."

    # Force automatic configuration
    (echo y; echo o conf prerequisites_policy follow; echo o conf commit) | cpan

    # Install modules from cpanfile manually
    perl -e '
        open my $fh, "<", "cpanfile" or die $!;
        while (<$fh>) {
            if (/requires\s+[\x27\x22]([^\x27\x22]+)[\x27\x22]/) {
                system("cpan", $1);
            }
        }
    '
fi

# Verify installation
print_info "Verifying critical module installation..."
echo

MODULES=(
    "JSON"
    "LWP::UserAgent"
    "LWP::Protocol::https"
    "Data::UUID"
    "Term::ANSIColor"
    "Math::BaseCalc"
    "XML::Simple"
)

FAILED=0
for module in "${MODULES[@]}"; do
    if perl -M"$module" -e 'print "OK\n"' 2>/dev/null; then
        print_success "$module installed"
    else
        print_error "$module NOT installed"
        FAILED=1
    fi
done

echo
if [[ $FAILED -eq 0 ]]; then
    print_success "All critical modules installed successfully!"
    echo
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Installation Complete!                            ║${NC}"
    echo -e "${GREEN}║                                                                ║${NC}"
    echo -e "${GREEN}║  You can now run any Perl script in this repository.          ║${NC}"
    echo -e "${GREEN}║                                                                ║${NC}"
    echo -e "${GREEN}║  Quick start:                                                  ║${NC}"
    echo -e "${GREEN}║    cd arxiv_doi_grabber && perl metadata_extractor.pl         ║${NC}"
    echo -e "${GREEN}║    cd entropy_cleaner && perl clean_by_entropy.pl             ║${NC}"
    echo -e "${GREEN}║                                                                ║${NC}"
    echo -e "${GREEN}║  Run tests with: make test                                    ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
else
    print_warning "Some modules failed to install. Please check the errors above."
    echo
    echo "You can try installing failed modules manually with:"
    echo "  cpanm Module::Name"
    echo
    echo "Or using cpan:"
    echo "  cpan Module::Name"
    exit 1
fi

# Create local::lib directory structure if it doesn't exist
if [[ ! -d "$HOME/perl5" ]]; then
    print_info "Creating local::lib directory structure..."
    mkdir -p "$HOME/perl5/lib/perl5"
fi

# Print environment setup instructions
echo
print_info "For best results, add the following to your ~/.bashrc or ~/.zshrc:"
echo
echo "  # Perl local::lib configuration"
echo "  eval \$(perl -I\$HOME/perl5/lib/perl5 -Mlocal::lib)"
echo

exit 0
