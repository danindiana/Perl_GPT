# Perl_GPT - Comprehensive Dependency Specification
# This file lists all CPAN modules required across the entire repository
# Install with: cpanm --installdeps .

# Core requirements - tested with latest stable versions
requires 'perl', '>= 5.034';

# Web and HTTP modules
requires 'LWP::UserAgent', '>= 6.72';
requires 'LWP::Protocol::https', '>= 6.14';
requires 'HTTP::Request', '>= 6.44';
requires 'HTTP::Status', '>= 6.44';

# Data serialization and parsing
requires 'JSON', '>= 4.10';
requires 'JSON::PP', '>= 4.16';
requires 'XML::Simple', '>= 2.25';

# Data manipulation and utilities
requires 'Data::UUID', '>= 1.226';
requires 'Data::Random', '>= 0.13';
requires 'Data::Dumper', '>= 2.188';
requires 'List::Util', '>= 1.63';
requires 'List::MoreUtils', '>= 0.430';

# File and path handling (enhanced versions)
requires 'File::Find', '0';
requires 'File::Basename', '0';
requires 'File::Spec', '0';
requires 'File::Path', '>= 2.18';
requires 'File::Copy', '0';
requires 'File::Slurp', '>= 9999.32';
requires 'Path::Tiny', '>= 0.144';

# Text processing and terminal output
requires 'Term::ANSIColor', '>= 5.01';
requires 'Term::ReadKey', '>= 2.38';

# Cryptography and hashing
requires 'Digest::MD5', '0';
requires 'Digest::SHA', '>= 6.04';

# Mathematical and statistical modules
requires 'Math::BaseCalc', '>= 1.019';

# Date and time handling
requires 'Time::Piece', '0';
requires 'Time::HiRes', '0';
requires 'DateTime', '>= 1.65';

# Command-line argument parsing
requires 'Getopt::Long', '0';
requires 'Pod::Usage', '0';

# Testing modules (development and CI/CD)
on 'test' => sub {
    requires 'Test::More', '>= 1.302198';
    requires 'Test::Exception', '>= 0.43';
    requires 'Test::Deep', '>= 1.204';
    requires 'Test::Warnings', '>= 0.032';
    requires 'Test::MockObject', '>= 1.20200122';
    requires 'Test::Output', '>= 1.034';
};

# Development tools
on 'develop' => sub {
    requires 'Perl::Critic', '>= 1.150';
    requires 'Perl::Tidy', '>= 20240903';
    requires 'Devel::Cover', '>= 1.40';
    requires 'Devel::NYTProf', '>= 6.14';
};

# Optional but recommended modules
recommends 'IO::Socket::SSL', '>= 2.085';
recommends 'Mozilla::CA', '>= 20240730';
recommends 'Parallel::ForkManager', '>= 2.02';
recommends 'Try::Tiny', '>= 0.31';
recommends 'namespace::clean', '>= 0.27';

# Platform-specific requirements
on 'linux' => sub {
    recommends 'Linux::Inotify2', '>= 2.3';
};
