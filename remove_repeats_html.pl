#!/usr/bin/perl
use strict;
use warnings;

print "Enter the path to the target HTML file: ";
my $file_path = <STDIN>;
chomp $file_path;

print "Enter minimum string length for comparison: ";
my $min_length = <STDIN>;
chomp $min_length;

# Open the input file
open(my $in, '<', $file_path) or die "Cannot open file $file_path: $!";

# Read the content of the file
my $content = do { local $/; <$in> };
close($in);

# Use hash data structure to detect and filter out repeating strings
my %seen; # Key: string, Value: boolean indicating whether we've seen the string before
$content =~ s{
    (                   # Start of capture group
        .{$min_length,} # Match strings longer than the minimum length
    )                   # End of capture group
}{
    $seen{$1}++ ? '' : $1  # Replace with empty string if seen, otherwise keep it
}xeg;

# Write to a new file
my $output_file_path = "unique_$file_path";
open(my $out, '>', $output_file_path) or die "Cannot open file $output_file_path: $!";
print $out $content;
close($out);

print "Processing complete. Unique content saved to $output_file_path\n";
