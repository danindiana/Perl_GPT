#!/usr/bin/env perl

# Basic load and syntax tests for Perl_GPT scripts

use strict;
use warnings;
use Test::More;
use File::Find;
use File::Spec;

# Find all Perl scripts in the repository
my @scripts;
find(
    sub {
        return unless -f $_ && /\.pl$/;
        return if $File::Find::dir =~ m{/\.git/};  # Skip .git directory
        push @scripts, $File::Find::name;
    },
    '.'
);

# Plan tests - one for each script
plan tests => scalar @scripts;

# Test each script for syntax errors
foreach my $script (sort @scripts) {
    my $result = system("perl -c $script 2>&1 >/dev/null");
    ok($result == 0, "Syntax check: $script");
}

done_testing();
