#!/bin/bash

# install_deps.sh - Dependency installation script for metadata_extractor.pl
# This script automates the installation of Perl dependencies for bare metal setups

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

print_header() {
    echo ""
    echo "========================================"
    echo "$1"
    echo "========================================"
    echo ""
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Perl version
check_perl_version() {
    print_header "Checking Perl Installation"

    if ! command_exists perl; then
        print_error "Perl is not installed. Please install Perl 5.10 or higher."
        exit 1
    fi

    local perl_version=$(perl -e 'print $]')
    local required_version=5.010001

    print_info "Detected Perl version: $(perl -v | head -2 | tail -1)"

    if perl -e "exit($perl_version < $required_version ? 1 : 0)"; then
        print_success "Perl version is sufficient (>= 5.10)"
    else
        print_error "Perl version $perl_version is too old. Please upgrade to 5.10 or higher."
        exit 1
    fi
}

# Function to check/install cpanm
install_cpanm() {
    print_header "Checking CPAN Installer (cpanm)"

    if command_exists cpanm; then
        print_success "cpanm is already installed"
        cpanm --version
        return 0
    fi

    print_warning "cpanm not found. Installing cpanm..."

    # Try to install cpanm
    if curl -L https://cpanmin.us | perl - App::cpanminus; then
        print_success "cpanm installed successfully"
    else
        print_error "Failed to install cpanm. Please install it manually."
        print_info "Visit: https://metacpan.org/pod/App::cpanminus"
        exit 1
    fi
}

# Function to install dependencies using cpanfile
install_dependencies() {
    print_header "Installing Perl Dependencies"

    # Check if cpanfile exists
    if [ ! -f "cpanfile" ]; then
        print_warning "cpanfile not found. Installing dependencies manually..."
        install_manual_dependencies
        return
    fi

    print_info "Installing dependencies from cpanfile..."

    # Install with cpanm
    if cpanm --installdeps . --notest; then
        print_success "All dependencies installed successfully"
    else
        print_error "Some dependencies failed to install"
        print_info "Trying to install dependencies individually..."
        install_manual_dependencies
    fi
}

# Function to manually install core dependencies
install_manual_dependencies() {
    local modules=(
        "LWP::UserAgent"
        "LWP::Protocol::https"
        "JSON"
    )

    for module in "${modules[@]}"; do
        print_info "Installing $module..."
        if cpanm --notest "$module"; then
            print_success "$module installed"
        else
            print_error "Failed to install $module"
        fi
    done
}

# Function to verify installation
verify_installation() {
    print_header "Verifying Installation"

    local modules=(
        "LWP::UserAgent"
        "JSON"
        "File::Find"
        "Digest::MD5"
        "Time::HiRes"
    )

    local all_ok=true

    for module in "${modules[@]}"; do
        if perl -M"$module" -e 1 2>/dev/null; then
            print_success "$module - OK"
        else
            print_error "$module - MISSING"
            all_ok=false
        fi
    done

    if [ "$all_ok" = true ]; then
        print_success "All required modules are installed"
        return 0
    else
        print_error "Some modules are missing. Installation incomplete."
        return 1
    fi
}

# Function to verify script syntax
verify_script_syntax() {
    print_header "Verifying Script Syntax"

    if [ ! -f "metadata_extractor.pl" ]; then
        print_warning "metadata_extractor.pl not found in current directory"
        return 1
    fi

    if perl -c metadata_extractor.pl 2>/dev/null; then
        print_success "Script syntax is valid"
        return 0
    else
        print_error "Script has syntax errors"
        perl -c metadata_extractor.pl
        return 1
    fi
}

# Function to display post-installation instructions
show_post_install_info() {
    print_header "Installation Complete"

    echo "Next steps:"
    echo ""
    echo "1. Run the smoke test to verify functionality:"
    echo "   ${GREEN}./smoke_test.pl${NC}"
    echo ""
    echo "2. View the help documentation:"
    echo "   ${GREEN}./metadata_extractor.pl --help${NC}"
    echo ""
    echo "3. Run a test extraction:"
    echo "   ${GREEN}./metadata_extractor.pl --dir=./test/fixtures --output=./temp${NC}"
    echo ""
    echo "For more information, see: readme.md"
    echo ""
}

# Main installation flow
main() {
    print_header "Metadata Extractor - Dependency Installation"
    print_info "This script will install all required Perl dependencies"
    echo ""

    # Check if we're in the right directory
    if [ ! -f "metadata_extractor.pl" ]; then
        print_warning "metadata_extractor.pl not found in current directory"
        print_info "Please run this script from the arxiv_doi_grabber directory"
    fi

    # Perform installation steps
    check_perl_version
    install_cpanm
    install_dependencies

    echo ""

    # Verify everything is working
    if verify_installation && verify_script_syntax; then
        show_post_install_info
        exit 0
    else
        print_error "Installation completed with errors"
        print_info "Please check the error messages above and try installing missing modules manually"
        exit 1
    fi
}

# Run main function
main "$@"
