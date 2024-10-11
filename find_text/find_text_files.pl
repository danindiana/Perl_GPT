#!/usr/bin/perl
use strict;
use warnings;
use File::Find;
use Time::Piece;

# Get user input for target directory
print "Enter the target directory to search: ";
chomp(my $target_dir = <STDIN>);

# Check if the directory exists
unless (-d $target_dir) {
    die "The directory $target_dir does not exist.\n";
}

# Ask if user wants to search recursively
print "Do you want to search recursively? (y/n): ";
chomp(my $recursive = <STDIN>);

# Get current system time and date to generate the output filename
my $time_stamp = localtime->strftime('%Y%m%d_%H%M%S');
my $output_file = "found_text_files_$time_stamp.txt";

# Open the output file for writing
open(my $fh, '>', $output_file) or die "Could not open file '$output_file' $!";

# Define the subroutine to process files
sub process_file {
    # Only list files with .txt extension
    if (-f $_ && $_ =~ /\.txt$/i) {
        my $file_path = $File::Find::name;
        print "$file_path\n";       # Output the file path to console
        print $fh "$file_path\n";   # Write the file path to the output file
    }
}

# Use File::Find to search the directory
if ($recursive eq 'y') {
    find(\&process_file, $target_dir);
} else {
    opendir(my $dh, $target_dir) or die "Could not open directory '$target_dir' $!";
    while (my $file = readdir($dh)) {
        my $full_path = "$target_dir/$file";
        if (-f $full_path && $file =~ /\.txt$/i) {
            print "$full_path\n";        # Output the file path to console
            print $fh "$full_path\n";    # Write the file path to the output file
        }
    }
    closedir($dh);
}

# Close the output file
close($fh);

print "Text files have been listed and written to $output_file.\n";
