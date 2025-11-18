# Perl_GPT - Comprehensive Dependency Specification
# This file lists all CPAN modules required across the entire repository
# Install with: cpanm --installdeps .
# Last Updated: November 2025

# Core requirements - tested with latest stable versions
requires 'perl', '>= 5.034';

# Web and HTTP modules - Updated to latest stable versions
requires 'LWP::UserAgent', '>= 6.77';
requires 'LWP::Protocol::https', '>= 6.14';
requires 'HTTP::Request', '>= 6.46';
requires 'HTTP::Status', '>= 6.46';
requires 'HTTP::Headers', '>= 6.46';
requires 'HTTP::Response', '>= 6.46';

# Data serialization and parsing - Updated versions
requires 'JSON', '>= 4.10';
requires 'JSON::XS', '>= 4.03';  # Fast JSON encoding/decoding
requires 'JSON::PP', '>= 4.18';
requires 'XML::Simple', '>= 2.25';
requires 'XML::LibXML', '>= 2.0210';  # Modern XML processing
requires 'YAML::XS', '>= 0.89';  # Fast YAML processing

# Data manipulation and utilities - Updated versions
requires 'Data::UUID', '>= 1.227';
requires 'Data::Random', '>= 0.13';
requires 'Data::Dumper', '>= 2.188';
requires 'List::Util', '>= 1.63';
requires 'List::MoreUtils', '>= 0.430';
requires 'Scalar::Util', '>= 1.63';

# File and path handling - Enhanced versions
requires 'File::Find', '0';
requires 'File::Basename', '0';
requires 'File::Spec', '0';
requires 'File::Path', '>= 2.18';
requires 'File::Copy', '0';
requires 'File::Slurp', '>= 9999.32';
requires 'Path::Tiny', '>= 0.146';
requires 'File::Temp', '>= 0.2311';

# Text processing and terminal output - Updated versions
requires 'Term::ANSIColor', '>= 5.01';
requires 'Term::ReadKey', '>= 2.38';
requires 'Text::CSV', '>= 2.04';  # CSV handling
requires 'Encode', '>= 3.21';  # Character encoding

# Cryptography and hashing - Updated versions
requires 'Digest::MD5', '0';
requires 'Digest::SHA', '>= 6.04';
requires 'Digest::SHA1', '>= 2.13';

# Mathematical and statistical modules - Updated versions
requires 'Math::BaseCalc', '>= 1.019';
requires 'Statistics::Descriptive', '>= 3.0801';  # Statistical analysis

# Date and time handling - Updated versions
requires 'Time::Piece', '0';
requires 'Time::HiRes', '0';
requires 'DateTime', '>= 1.66';
requires 'DateTime::Format::Strptime', '>= 1.79';

# Command-line argument parsing
requires 'Getopt::Long', '>= 2.58';
requires 'Pod::Usage', '>= 2.03';

# Logging and debugging
requires 'Log::Log4perl', '>= 1.57';  # Advanced logging
requires 'Carp', '>= 1.54';

# Testing modules (development and CI/CD) - Updated versions
on 'test' => sub {
    requires 'Test::More', '>= 1.302199';
    requires 'Test::Exception', '>= 0.43';
    requires 'Test::Deep', '>= 1.204';
    requires 'Test::Warnings', '>= 0.033';
    requires 'Test::MockObject', '>= 1.20200122';
    requires 'Test::Output', '>= 1.034';
    requires 'Test::Pod', '>= 1.52';
    requires 'Test::Pod::Coverage', '>= 1.10';
    requires 'Test::Perl::Critic', '>= 1.04';
};

# Development tools - Updated versions
on 'develop' => sub {
    requires 'Perl::Critic', '>= 1.152';
    requires 'Perl::Tidy', '>= 20240511';
    requires 'Devel::Cover', '>= 1.42';
    requires 'Devel::NYTProf', '>= 6.14';
    requires 'Code::TidyAll', '>= 0.84';
    requires 'Perl::LanguageServer', '>= 2.6.2';  # LSP support
};

# Optional but recommended modules - Updated versions
recommends 'IO::Socket::SSL', '>= 2.088';
recommends 'Mozilla::CA', '>= 20240924';
recommends 'Parallel::ForkManager', '>= 2.02';
recommends 'Try::Tiny', '>= 0.31';
recommends 'namespace::clean', '>= 0.27';
recommends 'Moo', '>= 2.005005';  # Modern OO
recommends 'Type::Tiny', '>= 2.004000';  # Type constraints

# Performance optimization
recommends 'JSON::XS', '>= 4.03';  # Fast JSON
recommends 'YAML::XS', '>= 0.89';  # Fast YAML
recommends 'Cpanel::JSON::XS', '>= 4.38';  # Alternative fast JSON

# Platform-specific requirements
on 'linux' => sub {
    recommends 'Linux::Inotify2', '>= 2.3';
    recommends 'Sys::Info', '>= 0.7811';
};

on 'darwin' => sub {
    recommends 'Mac::SystemDirectory', '>= 0.13';
};
