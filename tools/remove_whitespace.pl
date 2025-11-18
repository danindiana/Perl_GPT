#!/usr/bin/perl
use strict;
use warnings;

print "Enter the path to the target file: ";
my $file_path = <STDIN>;
chomp $file_path;

# Open the input file
open(my $in, '<', $file_path) or die "Cannot open file $file_path: $!";

# Open the output file
my $output_file_path = "processed_$file_path";
open(my $out, '>', $output_file_path) or die "Cannot open file $output_file_path: $!";

# Process the file
while (my $line = <$in>) {
    $line =~ s/\s+//g; # Remove all whitespace from the line
    print $out $line;
}

# Close file handles
close($in);
close($out);

print "Processing complete. Output file is $output_file_path\n";
