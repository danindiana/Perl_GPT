#!/usr/bin/env perl

# smoke_test.pl - Smoke test suite for metadata_extractor.pl
# This script validates that the environment is correctly configured
# and that basic functionality works as expected

use strict;
use warnings;
use v5.10;
use File::Temp qw(tempdir);
use File::Spec;
use File::Path qw(make_path remove_tree);
use Cwd qw(abs_path getcwd);

# Test result tracking
my $tests_run = 0;
my $tests_passed = 0;
my $tests_failed = 0;
my @failures;

# ANSI color codes
use constant {
    RED => "\033[0;31m",
    GREEN => "\033[0;32m",
    YELLOW => "\033[1;33m",
    BLUE => "\033[0;34m",
    CYAN => "\033[0;36m",
    BOLD => "\033[1m",
    RESET => "\033[0m",
};

# Print functions
sub print_header {
    my ($text) = @_;
    say "\n" . BOLD . CYAN . "=" x 60 . RESET;
    say BOLD . CYAN . $text . RESET;
    say BOLD . CYAN . "=" x 60 . RESET . "\n";
}

sub print_test {
    my ($name) = @_;
    print BLUE . "[TEST] " . RESET . "$name ... ";
}

sub print_pass {
    say GREEN . "PASS" . RESET;
    $tests_passed++;
}

sub print_fail {
    my ($reason) = @_;
    say RED . "FAIL" . RESET;
    say "  " . RED . "Reason: $reason" . RESET if $reason;
    $tests_failed++;
    push @failures, {test => $., reason => $reason};
}

sub print_info {
    my ($msg) = @_;
    say YELLOW . "[INFO] " . RESET . $msg;
}

sub print_error {
    my ($msg) = @_;
    say RED . "[ERROR] " . RESET . $msg;
}

sub print_success {
    my ($msg) = @_;
    say GREEN . "[SUCCESS] " . RESET . $msg;
}

# Test functions
sub test_perl_version {
    print_test("Perl version >= 5.10");
    $tests_run++;

    my $version = $];
    my $required = 5.010001;

    if ($version >= $required) {
        print_pass();
        print_info("Detected version: $version");
        return 1;
    } else {
        print_fail("Perl version $version is too old (need >= 5.10)");
        return 0;
    }
}

sub test_module_available {
    my ($module) = @_;
    print_test("Module available: $module");
    $tests_run++;

    eval "use $module; 1" or do {
        print_fail("Module $module not installed: $@");
        return 0;
    };

    print_pass();
    return 1;
}

sub test_script_syntax {
    print_test("Script syntax validation");
    $tests_run++;

    my $script = 'metadata_extractor.pl';

    unless (-f $script) {
        print_fail("Script not found: $script");
        return 0;
    }

    my $output = `perl -c $script 2>&1`;
    my $exit_code = $? >> 8;

    if ($exit_code == 0) {
        print_pass();
        return 1;
    } else {
        print_fail("Syntax errors detected");
        print_error($output);
        return 0;
    }
}

sub test_script_executable {
    print_test("Script is executable");
    $tests_run++;

    my $script = 'metadata_extractor.pl';

    if (-x $script) {
        print_pass();
        return 1;
    } else {
        print_fail("Script is not executable");
        print_info("Run: chmod +x $script");
        return 0;
    }
}

sub test_help_output {
    print_test("Help output works");
    $tests_run++;

    my $output = `perl metadata_extractor.pl --help 2>&1`;
    my $exit_code = $? >> 8;

    # Help should exit with code 1 (from pod2usage)
    if ($output =~ /metadata_extractor\.pl/ && $output =~ /options/i) {
        print_pass();
        return 1;
    } else {
        print_fail("Help output not as expected");
        return 0;
    }
}

sub test_basic_functionality {
    print_test("Basic functionality with test data");
    $tests_run++;

    # Create temporary directory
    my $temp_dir = tempdir(CLEANUP => 1);

    # Create test input file with DOI and arXiv links
    my $test_file = File::Spec->catfile($temp_dir, 'test_input.txt');
    open my $fh, '>', $test_file or do {
        print_fail("Cannot create test file: $!");
        return 0;
    };

    print $fh "CRAWLING: https://dx.doi.org/10.1038/nature12373\n";
    print $fh "CRAWLING: https://arxiv.org/abs/1706.03762\n";
    close $fh;

    # Run the script (simulating non-interactive mode)
    # We'll use a heredoc to provide input
    my $cmd = qq{echo "0" | perl metadata_extractor.pl --dir="$temp_dir" --output="$temp_dir" 2>&1};
    my $output = `$cmd`;

    # Check if output file was created
    my $expected_output = File::Spec->catfile($temp_dir, 'test_input_extracted.json');

    if (-f $expected_output) {
        # Verify JSON is valid
        open my $json_fh, '<', $expected_output;
        my $json_content = do { local $/; <$json_fh> };
        close $json_fh;

        eval {
            require JSON;
            my $json = JSON->new->utf8;
            my $data = $json->decode($json_content);

            # Check structure
            if (exists $data->{dois} && exists $data->{arxivs}) {
                print_pass();
                print_info("Generated valid JSON output");
                return 1;
            } else {
                print_fail("JSON structure is incorrect");
                return 0;
            }
        } or do {
            print_fail("Generated invalid JSON: $@");
            return 0;
        };
    } else {
        print_fail("Expected output file not created");
        print_info("Command: $cmd");
        print_info("Output: $output");
        return 0;
    }
}

sub test_file_discovery {
    print_test("File discovery functionality");
    $tests_run++;

    my $temp_dir = tempdir(CLEANUP => 1);

    # Create multiple test files
    for my $i (1..3) {
        my $file = File::Spec->catfile($temp_dir, "test$i.txt");
        open my $fh, '>', $file or next;
        print $fh "Test file $i\n";
        close $fh;
    }

    # Create a non-.txt file (should be ignored)
    my $ignore_file = File::Spec->catfile($temp_dir, "ignore.log");
    open my $fh, '>', $ignore_file;
    print $fh "Should be ignored\n";
    close $fh;

    # Run script and check if it finds exactly 3 .txt files
    my $cmd = qq{echo "" | perl metadata_extractor.pl --dir="$temp_dir" --output="$temp_dir" 2>&1};
    my $output = `$cmd`;

    if ($output =~ /Found 3 text files/) {
        print_pass();
        return 1;
    } else {
        print_fail("Did not find expected number of files");
        print_info("Output: $output");
        return 0;
    }
}

sub test_output_directory {
    print_test("Output directory creation");
    $tests_run++;

    my $temp_dir = tempdir(CLEANUP => 1);
    my $output_dir = File::Spec->catdir($temp_dir, 'output');

    # Create test file
    my $test_file = File::Spec->catfile($temp_dir, 'test.txt');
    open my $fh, '>', $test_file;
    print $fh "CRAWLING: https://dx.doi.org/10.1000/test\n";
    close $fh;

    # Create output directory
    make_path($output_dir);

    # Run script with explicit output directory
    my $cmd = qq{echo "0" | perl metadata_extractor.pl --dir="$temp_dir" --output="$output_dir" 2>&1};
    my $output = `$cmd`;

    # Check if log file was created in output directory
    opendir my $dh, $output_dir or do {
        print_fail("Cannot read output directory: $!");
        return 0;
    };

    my @files = grep { /\.txt$/ && -f File::Spec->catfile($output_dir, $_) } readdir($dh);
    closedir $dh;

    if (@files > 0) {
        print_pass();
        print_info("Found log file: $files[0]");
        return 1;
    } else {
        print_fail("No log file created in output directory");
        return 0;
    }
}

# Test suite for fixtures (if they exist)
sub test_fixtures {
    my $fixtures_dir = 'test/fixtures';

    unless (-d $fixtures_dir) {
        print_info("Skipping fixture tests (fixtures directory not found)");
        return 1;
    }

    print_test("Test fixtures validation");
    $tests_run++;

    opendir my $dh, $fixtures_dir or do {
        print_fail("Cannot read fixtures directory: $!");
        return 0;
    };

    my @fixture_files = grep { /\.txt$/ && -f File::Spec->catfile($fixtures_dir, $_) } readdir($dh);
    closedir $dh;

    if (@fixture_files > 0) {
        print_pass();
        print_info("Found " . scalar(@fixture_files) . " fixture file(s)");
        return 1;
    } else {
        print_fail("No fixture files found in $fixtures_dir");
        return 0;
    }
}

# Summary and results
sub print_summary {
    print_header("Test Summary");

    say "Total tests run:    $tests_run";
    say GREEN . "Tests passed:       $tests_passed" . RESET;
    say RED . "Tests failed:       $tests_failed" . RESET if $tests_failed > 0;

    if ($tests_failed > 0) {
        say "\n" . RED . BOLD . "SMOKE TEST FAILED" . RESET;
        say "\nFailed tests:";
        for my $failure (@failures) {
            say "  - Test #$failure->{test}: $failure->{reason}";
        }
        say "\nPlease fix the issues above and run the smoke test again.";
        return 0;
    } else {
        say "\n" . GREEN . BOLD . "SMOKE TEST PASSED" . RESET;
        say "\nAll systems operational! The metadata extractor is ready to use.";
        return 1;
    }
}

# Main test execution
sub main {
    print_header("Metadata Extractor - Smoke Test Suite");

    print_info("Starting smoke tests...");
    print_info("Current directory: " . getcwd());

    # Environment tests
    print_header("Environment Tests");
    test_perl_version();

    # Module availability tests
    print_header("Dependency Tests");
    my @required_modules = qw(
        LWP::UserAgent
        JSON
        File::Find
        File::Basename
        Getopt::Long
        Pod::Usage
        Digest::MD5
        Time::HiRes
    );

    for my $module (@required_modules) {
        test_module_available($module);
    }

    # Script validation tests
    print_header("Script Validation Tests");
    test_script_syntax();
    test_script_executable();
    test_help_output();

    # Functional tests
    print_header("Functional Tests");
    test_file_discovery();
    test_output_directory();
    test_basic_functionality();

    # Fixture tests (optional)
    print_header("Fixture Tests");
    test_fixtures();

    # Print summary
    my $success = print_summary();

    exit($success ? 0 : 1);
}

# Run main
main();

__END__

=head1 NAME

smoke_test.pl - Smoke test suite for metadata_extractor.pl

=head1 SYNOPSIS

    ./smoke_test.pl

=head1 DESCRIPTION

This script performs smoke tests to validate that the metadata_extractor.pl
script is properly installed and functional. It checks:

- Perl version compatibility
- Required module availability
- Script syntax validity
- Basic functionality
- File operations

Exit code 0 indicates all tests passed.
Exit code 1 indicates one or more tests failed.

=head1 AUTHOR

Metadata Extractor Team

=cut
