#!/usr/bin/perl

use strict;
use warnings;

print "Enter the name of the text file containing IP addresses: ";
my $input_file = <>;
chomp($input_file);

print "Enter the desired name for the output file: ";
my $output_file = <>;
chomp($output_file);

open(IN, "<", $input_file) or die "Cannot open input file: $!";
open(OUT, ">", $output_file) or die "Cannot open output file: $!";

while (<IN>) {
  # Extract IP address using regular expression
  if (m/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/) {
    print OUT "$1\n";
  }
}

close(IN);
close(OUT);

print "Extracted IP addresses written to '$output_file'.\n";
