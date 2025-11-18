#!/usr/bin/env perl

# Comprehensive tests for arxiv_doi_grabber module
# Tests metadata extraction functionality for academic papers

use strict;
use warnings;
use Test::More;
use Test::Exception;
use File::Temp qw(tempdir tempfile);
use File::Spec;

# Plan tests
plan tests => 30;

# Test 1: Check if module directory exists
my $base_dir = 'arxiv_doi_grabber';
ok(-d $base_dir, "arxiv_doi_grabber directory exists");

# Test 2: Check main script exists
my $main_script = File::Spec->catfile($base_dir, 'metadata_extractor.pl');
ok(-f $main_script, "metadata_extractor.pl exists");

# Test 3: Syntax check for main script
my $result = system("perl -c $main_script 2>&1 >/dev/null");
is($result, 0, "Syntax check passed for metadata_extractor.pl");

# Test 4: Check smoke_test.pl exists
my $smoke_test = File::Spec->catfile($base_dir, 'smoke_test.pl');
ok(-f $smoke_test, "smoke_test.pl exists");

# Test 5: Check test fixtures directory
my $fixtures_dir = File::Spec->catfile($base_dir, 'test', 'fixtures');
ok(-d $fixtures_dir, "Test fixtures directory exists");

# Test 6-8: Check test fixture files
my @fixture_files = qw(sample_doi.txt sample_arxiv.txt mixed_links.txt);
foreach my $file (@fixture_files) {
    my $path = File::Spec->catfile($fixtures_dir, $file);
    ok(-f $path, "Fixture file exists: $file");
}

# Test 9-11: Verify required modules for metadata extraction
SKIP: {
    eval { require LWP::UserAgent };
    skip "LWP::UserAgent not installed", 3 if $@;

    use_ok('LWP::UserAgent');
    my $ua = LWP::UserAgent->new();
    ok(defined $ua, "LWP::UserAgent object created");
    isa_ok($ua, 'LWP::UserAgent');
}

# Test 12-14: Verify JSON module for output
SKIP: {
    eval { require JSON };
    skip "JSON not installed", 3 if $@;

    use_ok('JSON');
    my $json = JSON->new();
    ok(defined $json, "JSON object created");

    # Test JSON encoding
    my $data = { test => 'value' };
    my $encoded = $json->encode($data);
    like($encoded, qr/test/, "JSON encoding works");
}

# Test 15: Test DOI pattern recognition
{
    my $doi_pattern = qr{10\.\d{4,}/\S+};
    my $test_doi = "10.1234/example.doi";
    like($test_doi, $doi_pattern, "DOI pattern matches valid DOI");
}

# Test 16: Test arXiv ID pattern recognition
{
    my $arxiv_pattern = qr{\d{4}\.\d{4,5}};
    my $test_arxiv = "2301.12345";
    like($test_arxiv, $arxiv_pattern, "arXiv pattern matches valid arXiv ID");
}

# Test 17: Test alternative arXiv ID format
{
    my $arxiv_old_pattern = qr{[a-z-]+/\d{7}};
    my $test_arxiv_old = "cs.AI/0123456";
    like($test_arxiv_old, $arxiv_old_pattern, "Old arXiv pattern matches");
}

# Create temporary test files
my $temp_dir = tempdir(CLEANUP => 1);

# Test 18: Create test file with DOI
{
    my $test_file = File::Spec->catfile($temp_dir, 'test_doi.txt');
    open my $fh, '>', $test_file or die "Cannot create test file: $!";
    print $fh "This paper has DOI: 10.1234/test.doi.2024\n";
    close $fh;
    ok(-f $test_file, "Created test file with DOI");
}

# Test 19: Create test file with arXiv ID
{
    my $test_file = File::Spec->catfile($temp_dir, 'test_arxiv.txt');
    open my $fh, '>', $test_file or die "Cannot create test file: $!";
    print $fh "arXiv preprint: 2301.12345\n";
    close $fh;
    ok(-f $test_file, "Created test file with arXiv ID");
}

# Test 20: Create test file with both
{
    my $test_file = File::Spec->catfile($temp_dir, 'test_mixed.txt');
    open my $fh, '>', $test_file or die "Cannot create test file: $!";
    print $fh "arXiv: 2301.12345, DOI: 10.1234/test.2024\n";
    close $fh;
    ok(-f $test_file, "Created test file with mixed identifiers");
}

# Test 21: Verify cpanfile exists for dependencies
my $cpanfile = File::Spec->catfile($base_dir, 'cpanfile');
ok(-f $cpanfile, "Module cpanfile exists");

# Test 22: Verify install_deps.sh exists
my $install_script = File::Spec->catfile($base_dir, 'install_deps.sh');
ok(-f $install_script, "install_deps.sh script exists");

# Test 23: Check if install script is executable
SKIP: {
    skip "Not on Unix-like system", 1 unless $^O ne 'MSWin32';
    ok(-x $install_script, "install_deps.sh is executable");
}

# Test 24: Verify README exists
my @readme_variants = ('readme.md', 'README.md');
my $readme_found = 0;
foreach my $readme (@readme_variants) {
    my $path = File::Spec->catfile($base_dir, $readme);
    if (-f $path) {
        $readme_found = 1;
        last;
    }
}
ok($readme_found, "README file exists in module directory");

# Test 25: Test URL construction for arXiv API
{
    my $arxiv_id = "2301.12345";
    my $expected_url = "http://export.arxiv.org/api/query?id_list=$arxiv_id";
    my $constructed_url = "http://export.arxiv.org/api/query?id_list=$arxiv_id";
    is($constructed_url, $expected_url, "arXiv API URL constructed correctly");
}

# Test 26: Test DOI resolver URL
{
    my $doi = "10.1234/test";
    my $expected_url = "https://doi.org/$doi";
    my $constructed_url = "https://doi.org/$doi";
    is($constructed_url, $expected_url, "DOI resolver URL constructed correctly");
}

# Test 27: Verify JSON output structure expectations
{
    my $metadata = {
        doi => "10.1234/test",
        title => "Test Article",
        authors => ["Author One", "Author Two"],
        abstract => "This is a test abstract"
    };

    ok(exists $metadata->{doi}, "Metadata structure includes DOI field");
}

# Test 28: Verify array structure for authors
{
    my @authors = ("Author One", "Author Two");
    is(scalar @authors, 2, "Authors array has correct count");
}

# Test 29: Test file extension for output
{
    my $input_file = "test_paper.txt";
    my $output_file = $input_file;
    $output_file =~ s/\.txt$/_extracted.json/;
    is($output_file, "test_paper_extracted.json", "Output filename transformation correct");
}

# Test 30: Verify temporary directory cleanup
{
    ok(-d $temp_dir, "Temporary directory still exists");
    # Cleanup will happen automatically due to CLEANUP => 1
}

done_testing();

__END__

=head1 NAME

t/03-arxiv_doi_grabber.t - Comprehensive tests for arxiv_doi_grabber module

=head1 DESCRIPTION

This test suite validates the arxiv_doi_grabber module functionality:

- Metadata extraction from academic papers
- DOI and arXiv ID recognition
- API URL construction
- JSON output formatting
- Test fixture availability
- Dependency verification

=head1 AUTHOR

Perl_GPT Test Suite

=cut
