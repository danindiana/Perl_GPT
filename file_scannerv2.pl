#!/usr/bin/perl

use strict;
use warnings;
use File::Spec;

# Predefined array of keywords
my @keywords = ("covid", "sustainability", "employment", "sexual", "slavery", "trafficking"); # Replace with your desired keywords

# Subroutine to get user input
sub get_input {
    my ($prompt) = @_;
    print "$prompt: ";
    chomp(my $input = <STDIN>);
    return $input;
}

# Get target directory
my $dir = get_input("Enter the target directory");
print "Target directory: $dir\n";

# Open the directory
opendir(my $dh, $dir) or die "Cannot open directory $dir: $!";
print "Scanning directory...\n";

# Process files in the directory
my @matched_files;
print "Using keywords for matching: @keywords\n"; # Display the keywords being used
foreach my $file (readdir $dh) {
    print "Processing file: $file\n";
    next if -d File::Spec->catfile($dir, $file); # Skip directories
    foreach my $keyword (@keywords) {
        if ($file =~ /\Q$keyword\E/i) { # Case-insensitive match
            push @matched_files, $file;
            print "Match found: $file\n";
            last;
        }
    }
}

closedir $dh;

# Ask user to list matched files
if (@matched_files) {
    my $list_files = get_input("Do you want to list the matched files? (yes/no)");
    if (lc($list_files) eq 'yes') {
        print "Matched Files:\n";
        print "$_\n" foreach @matched_files;
    }

    # Ask user if they want to delete the files
    my $delete_files = get_input("Do you want to delete these files? (yes/no)");
    if (lc($delete_files) eq 'yes') {
        foreach my $file (@matched_files) {
            unlink File::Spec->catfile($dir, $file) or warn "Could not delete $file: $!";
            print "Deleted file: $file\n";
        }
    } else {
        print "No deletion performed.\n";
    }
} else {
    print "No files matched your criteria.\n";
}

# Finished
print "Program completed.\n";
