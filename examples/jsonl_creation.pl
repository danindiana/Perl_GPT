#!/usr/bin/env perl

=head1 NAME

jsonl_creation.pl - Example of creating JSONL format for ML pipelines

=head1 SYNOPSIS

    perl examples/jsonl_creation.pl

=head1 DESCRIPTION

This example demonstrates how to create JSONL (JSON Lines) format files
for machine learning pipelines, with proper metadata and structure.

=cut

use strict;
use warnings;
use JSON;
use File::Temp qw(tempdir);
use File::Spec;

print "=" x 70, "\n";
print "JSONL Format Creation Example\n";
print "=" x 70, "\n\n";

# Example 1: Basic JSONL record
print "Example 1: Creating a Basic JSONL Record\n";
print "-" x 70, "\n";

my $json = JSON->new->utf8->canonical;

my $record1 = {
    text => "This is a sample text for machine learning.",
    metadata => {
        source => "example",
        length => 44,
        language => "en"
    }
};

my $jsonl_line = $json->encode($record1);
print "JSONL Record:\n$jsonl_line\n\n";

# Example 2: Multiple records
print "Example 2: Creating Multiple JSONL Records\n";
print "-" x 70, "\n";

my @texts = (
    "The quick brown fox jumps over the lazy dog.",
    "Pack my box with five dozen liquor jugs.",
    "How vexingly quick daft zebras jump!"
);

my @records;
foreach my $i (0..$#texts) {
    my $record = {
        id => $i + 1,
        text => $texts[$i],
        metadata => {
            length => length($texts[$i]),
            index => $i,
            created => time()
        }
    };
    push @records, $record;
}

print "Generated ", scalar(@records), " records:\n";
foreach my $record (@records) {
    print $json->encode($record), "\n";
}
print "\n";

# Example 3: JSONL file creation
print "Example 3: Writing JSONL to File\n";
print "-" x 70, "\n";

my $temp_dir = tempdir(CLEANUP => 1);
my $output_file = File::Spec->catfile($temp_dir, 'output.jsonl');

open my $fh, '>', $output_file or die "Cannot create $output_file: $!";

my @sample_data = (
    { text => "First training example", label => 1 },
    { text => "Second training example", label => 0 },
    { text => "Third training example", label => 1 }
);

foreach my $data (@sample_data) {
    print $fh $json->encode($data), "\n";
}
close $fh;

print "Created JSONL file: $output_file\n";
print "File size: ", -s $output_file, " bytes\n";

# Read it back to verify
open my $read_fh, '<', $output_file or die "Cannot read $output_file: $!";
my $line_count = 0;
while (my $line = <$read_fh>) {
    $line_count++;
}
close $read_fh;
print "Lines in file: $line_count\n\n";

# Example 4: JSONL with rich metadata
print "Example 4: JSONL with Rich Metadata\n";
print "-" x 70, "\n";

my $rich_record = {
    text => "Sample document for NLP processing",
    metadata => {
        filename => "sample.txt",
        file_size => 1024,
        created_at => time(),
        checksum => "abc123def456",
        language => "en",
        encoding => "utf-8",
        tags => ["sample", "nlp", "training"],
        statistics => {
            word_count => 5,
            char_count => 35,
            line_count => 1
        }
    },
    features => {
        has_punctuation => 0,
        has_numbers => 0,
        has_special_chars => 0
    }
};

print "Rich JSONL Record:\n";
print $json->pretty->encode($rich_record), "\n";

# Example 5: Batch processing simulation
print "Example 5: Batch Processing to JSONL\n";
print "-" x 70, "\n";

my $batch_output = File::Spec->catfile($temp_dir, 'batch_output.jsonl');
open my $batch_fh, '>', $batch_output or die "Cannot create $batch_output: $!";

# Reset JSON to compact format
$json = JSON->new->utf8->canonical;

# Simulate processing multiple documents
my $batch_size = 10;
for my $i (1..$batch_size) {
    my $doc_record = {
        doc_id => sprintf("DOC_%04d", $i),
        text => "This is document number $i in the batch.",
        metadata => {
            batch_id => 1,
            position => $i,
            processed_at => time()
        }
    };

    print $batch_fh $json->encode($doc_record), "\n";
}
close $batch_fh;

print "Processed $batch_size documents\n";
print "Output file: $batch_output\n";
print "File size: ", -s $batch_output, " bytes\n\n";

# Example 6: JSONL file rotation (2GB threshold)
print "Example 6: Understanding File Rotation\n";
print "-" x 70, "\n";

my $max_size = 2 * 1024 * 1024 * 1024;  # 2GB
my $current_size = 0;
my $file_counter = 1;

print "File rotation occurs at: 2GB\n";
print "Current implementation would create:\n";
print "  output_1.jsonl\n";
print "  output_2.jsonl (when output_1.jsonl reaches 2GB)\n";
print "  output_3.jsonl (when output_2.jsonl reaches 2GB)\n";
print "  ... and so on\n\n";

# Example 7: Usage tips
print "=" x 70, "\n";
print "Usage Tips for JSONL Conversion\n";
print "=" x 70, "\n\n";

print <<'USAGE';
To convert text files to JSONL format using the jsonl_convertor module:

    cd jsonl_convertor
    perl txt_jsonl_convert.pl

Features:
  - Automatic 2GB file rotation for large datasets
  - Metadata extraction (filename, size, timestamps)
  - Recursive directory scanning option
  - Progress statistics
  - UTF-8 encoding support

Best Practices:
  1. One JSON object per line (no newlines in JSON)
  2. Include meaningful metadata
  3. Use consistent field names
  4. Validate JSON structure before using
  5. Consider file size for rotation
  6. Add unique IDs for tracking

Common Use Cases:
  - Training data for language models
  - Text classification datasets
  - Document embedding pipelines
  - Information retrieval systems
  - Data augmentation workflows

USAGE

# Example 8: Validation
print "Example 7: Validating JSONL Format\n";
print "-" x 70, "\n";

# Read back and validate
open my $validate_fh, '<', $batch_output or die "Cannot read $batch_output: $!";
my $valid_lines = 0;
my $invalid_lines = 0;

while (my $line = <$validate_fh>) {
    chomp $line;
    eval {
        my $decoded = $json->decode($line);
        $valid_lines++;
    };
    if ($@) {
        $invalid_lines++;
    }
}
close $validate_fh;

print "Validation Results:\n";
print "  Valid JSONL lines: $valid_lines\n";
print "  Invalid JSONL lines: $invalid_lines\n";
print "  Validation: ", $invalid_lines == 0 ? "PASSED ✓" : "FAILED ✗", "\n\n";

print "Example completed successfully!\n";

__END__

=head1 JSONL FORMAT

JSONL (JSON Lines) format specifications:

- One JSON object per line
- Each line is valid JSON
- Lines separated by newline characters
- No commas between objects
- Each line can be parsed independently

=head1 AUTHOR

Perl_GPT Examples

=head1 LICENSE

GPL-3.0

=cut
