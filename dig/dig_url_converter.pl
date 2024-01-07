#!/usr/bin/perl

use strict;
use warnings;
use Time::Piece;

print "Enter the name of the text file to modify: ";
chomp(my $file_name = <STDIN>);

open(my $file, '<', $file_name) or die "Could not open file: $file_name\n";

my @lines = <$file>;
close($file);

my $new_file_name = "modified_" . localtime->strftime("%Y%m%d_%H%M%S") . ".txt";
open(my $new_file, '>', $new_file_name) or die "Could not create new file: $new_file_name\n";

foreach my $line (@lines) {
  chomp $line;  # Remove newline from the original URL
  $line =~ s/https?:\/\/|www\.//gi;  # Remove https:// or www.
  $line =~ s/\/$//;                  # Remove trailing slash
  $line .= " mx";                    # Add " mx" with a space
  print $new_file $line . "\n";       # Print the modified line with a newline
}

close($new_file);

print "Modified file saved as: $new_file_name\n";
