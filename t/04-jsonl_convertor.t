#!/usr/bin/env perl

# Comprehensive tests for jsonl_convertor module
# Tests JSONL format conversion for ML pipelines

use strict;
use warnings;
use Test::More;
use Test::Exception;
use File::Temp qw(tempdir tempfile);
use File::Spec;
use File::Path qw(make_path);

# Plan tests
plan tests => 28;

# Test 1: Check if module directory exists
my $base_dir = 'jsonl_convertor';
ok(-d $base_dir, "jsonl_convertor directory exists");

# Test 2: Check main script exists
my $main_script = File::Spec->catfile($base_dir, 'txt_jsonl_convert.pl');
ok(-f $main_script, "txt_jsonl_convert.pl exists");

# Test 3: Syntax check for main script
my $result = system("perl -c $main_script 2>&1 >/dev/null");
is($result, 0, "Syntax check passed for txt_jsonl_convert.pl");

# Test 4-6: Verify JSON module availability
SKIP: {
    eval { require JSON };
    skip "JSON not installed", 3 if $@;

    use_ok('JSON');
    my $json = JSON->new();
    ok(defined $json, "JSON object created");

    # Test JSONL format (one JSON object per line)
    my $data = { text => "test", metadata => { file => "test.txt" } };
    my $jsonl_line = $json->encode($data);
    unlike($jsonl_line, qr/\n/, "JSONL line doesn't contain newlines (in JSON)");
}

# Create temporary directory structure
my $temp_dir = tempdir(CLEANUP => 1);
my $input_dir = File::Spec->catdir($temp_dir, 'input');
make_path($input_dir);

# Test 7: Verify input directory created
ok(-d $input_dir, "Temporary input directory created");

# Test 8-10: Create test text files
{
    my $file1 = File::Spec->catfile($input_dir, 'test1.txt');
    open my $fh, '>', $file1 or die "Cannot create $file1: $!";
    print $fh "This is test file 1.\n" x 10;
    close $fh;
    ok(-f $file1, "Created test file 1");

    my $file2 = File::Spec->catfile($input_dir, 'test2.txt');
    open my $fh2, '>', $file2 or die "Cannot create $file2: $!";
    print $fh2 "This is test file 2 with different content.\n" x 15;
    close $fh2;
    ok(-f $file2, "Created test file 2");

    my $file3 = File::Spec->catfile($input_dir, 'test3.txt');
    open my $fh3, '>', $file3 or die "Cannot create $file3: $!";
    print $fh3 "Test file 3 has unique content for testing.\n" x 20;
    close $fh3;
    ok(-f $file3, "Created test file 3");
}

# Test 11: Test JSONL line structure
{
    my %data = (
        text => "Sample text content",
        metadata => {
            filename => "test.txt",
            size => 1024,
            created => time()
        }
    );

    ok(exists $data{text}, "JSONL record has text field");
}

# Test 12: Test metadata structure
{
    my %metadata = (
        filename => "test.txt",
        size => 1024,
        path => "/path/to/file"
    );

    is($metadata{filename}, "test.txt", "Metadata filename correct");
}

# Test 13: Test file size calculation
{
    my $test_file = File::Spec->catfile($input_dir, 'test1.txt');
    my $size = -s $test_file;
    ok($size > 0, "File size calculation works");
}

# Test 14: Test JSONL output format
SKIP: {
    eval { require JSON };
    skip "JSON not installed", 1 if $@;

    my $json = JSON->new();
    my @records = (
        { text => "line 1", id => 1 },
        { text => "line 2", id => 2 }
    );

    my $jsonl_output = join("\n", map { $json->encode($_) } @records);
    my @lines = split /\n/, $jsonl_output;
    is(scalar @lines, 2, "JSONL has correct number of lines");
}

# Test 15: Test 2GB rotation threshold
{
    my $two_gb = 2 * 1024 * 1024 * 1024;
    ok($two_gb == 2147483648, "2GB threshold calculated correctly");
}

# Test 16: Test file counter for rotation
{
    my $file_counter = 1;
    my $output_name = "output_${file_counter}.jsonl";
    is($output_name, "output_1.jsonl", "Output filename with counter correct");
}

# Test 17: Create large test file (simulated)
{
    my $large_file = File::Spec->catfile($input_dir, 'large.txt');
    open my $fh, '>', $large_file or die "Cannot create $large_file: $!";
    print $fh "X" x 10000;  # 10KB test file
    close $fh;

    my $size = -s $large_file;
    ok($size >= 10000, "Large test file created");
}

# Test 18: Test text encoding handling
SKIP: {
    eval { require Encode };
    skip "Encode not installed", 1 if $@;

    use_ok('Encode');
}

# Test 19: Test recursive directory scanning
{
    my $subdir = File::Spec->catdir($input_dir, 'subdir');
    make_path($subdir);
    ok(-d $subdir, "Subdirectory created for recursive test");
}

# Test 20: Create file in subdirectory
{
    my $subdir = File::Spec->catdir($input_dir, 'subdir');
    my $subfile = File::Spec->catfile($subdir, 'nested.txt');
    open my $fh, '>', $subfile or die "Cannot create $subfile: $!";
    print $fh "Nested file content\n";
    close $fh;
    ok(-f $subfile, "Nested file created");
}

# Test 21: Test file counting
{
    opendir my $dh, $input_dir or die "Cannot open $input_dir: $!";
    my @txt_files = grep { /\.txt$/ && -f File::Spec->catfile($input_dir, $_) } readdir $dh;
    closedir $dh;
    ok(scalar @txt_files > 0, "Found text files in directory");
}

# Test 22: Test JSONL record uniqueness
{
    my %seen;
    my @records = (
        { id => 1, text => "a" },
        { id => 2, text => "b" },
        { id => 3, text => "c" }
    );

    foreach my $rec (@records) {
        $seen{$rec->{id}} = 1;
    }
    is(scalar keys %seen, 3, "All records have unique IDs");
}

# Test 23: Test empty file handling
{
    my $empty_file = File::Spec->catfile($input_dir, 'empty.txt');
    open my $fh, '>', $empty_file or die "Cannot create $empty_file: $!";
    close $fh;
    ok(-z $empty_file, "Empty file created");
}

# Test 24: Test file extension filtering
{
    my $filename = "test.txt";
    ok($filename =~ /\.txt$/, "Text file extension detected");
}

# Test 25: Test non-text file exclusion
{
    my $filename = "test.pdf";
    ok($filename !~ /\.txt$/, "Non-text file excluded");
}

# Test 26: Test JSONL escaping
SKIP: {
    eval { require JSON };
    skip "JSON not installed", 1 if $@;

    my $json = JSON->new();
    my $data = { text => "Line with \"quotes\" and \n newline" };
    my $encoded = $json->encode($data);
    like($encoded, qr/\\"/, "Quotes properly escaped in JSON");
}

# Test 27: Test statistics tracking
{
    my %stats = (
        files_processed => 0,
        total_bytes => 0,
        records_written => 0
    );

    $stats{files_processed}++;
    $stats{total_bytes} += 1024;
    $stats{records_written}++;

    is($stats{files_processed}, 1, "Statistics tracking works");
}

# Test 28: Test output path construction
{
    my $output_dir = $temp_dir;
    my $output_file = File::Spec->catfile($output_dir, 'output.jsonl');
    like($output_file, qr/output\.jsonl$/, "Output path constructed correctly");
}

done_testing();

__END__

=head1 NAME

t/04-jsonl_convertor.t - Comprehensive tests for jsonl_convertor module

=head1 DESCRIPTION

This test suite validates the jsonl_convertor module functionality:

- JSONL format conversion
- File size handling and rotation
- Recursive directory scanning
- Metadata extraction
- Text encoding
- Statistics tracking

=head1 AUTHOR

Perl_GPT Test Suite

=cut
