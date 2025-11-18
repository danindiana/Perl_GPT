#!/usr/bin/env perl

# Test that critical dependencies are available

use strict;
use warnings;
use Test::More;

# List of critical modules
my @critical_modules = qw(
    JSON
    LWP::UserAgent
    LWP::Protocol::https
    File::Find
    File::Basename
    Time::Piece
    Getopt::Long
);

# Plan tests
plan tests => scalar @critical_modules;

# Test each module
foreach my $module (@critical_modules) {
    use_ok($module) or diag("Module $module not available");
}

done_testing();
