#!/usr/bin/perl

use strict;
use warnings;

# Get directory names from the user
print "Enter the source directory name: ";
my $source_dir = <STDIN>;
chomp $source_dir;

print "Enter the destination directory name: ";
my $destination_dir = <STDIN>;
chomp $destination_dir;

# Ensure directories exist
die "Source directory '$source_dir' does not exist" unless -d $source_dir;
die "Destination directory '$destination_dir' does not exist" unless -d $destination_dir;

# Initialize counters
my $moved_files = 0;
my $total_data_transferred = 0;

# Process files
opendir(my $source_dh, $source_dir) or die "Failed to open source directory: $!";
while (my $filename = readdir($source_dh)) {
  # Skip current and parent directories
  next if $filename eq '.' or $filename eq '..';

  my $source_file = "$source_dir/$filename";
  my $destination_file = "$destination_dir/$filename";

  # Skip existing files with the same name
  next if -f $destination_file;

  # Check if it's a symbolic link
  if (-l $source_file) {
    print "Skipping symbolic link: $source_file\n";
  } else {
    # Move the file and count data transferred
    my $file_size = -s $source_file;
    rename($source_file, $destination_file) or die "Failed to move file: $!";
    $moved_files++;
    $total_data_transferred += $file_size;
    print "Moved '$source_file' to '$destination_file' ($file_size bytes)\n";
  }
}
closedir($source_dh);

# Print telemetry
print "----------------------------------------\n";
print "Merged files: $moved_files\n";
print "Total data transferred: $total_data_transferred bytes\n";
print "----------------------------------------\n";

# Remove the empty source directory if desired
# uncomment the following line to enable directory removal
# rmdir($source_dir) or die "Failed to remove empty source directory: $!";

print "Directory merging completed.\n";
