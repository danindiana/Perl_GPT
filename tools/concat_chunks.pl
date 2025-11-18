#!/usr/bin/perl
use strict;
use warnings;

print "Enter the directory containing text files: ";
my $dir = <STDIN>;
chomp $dir;
unless (-d $dir) {
    die "The directory '$dir' does not exist or is not a directory.";
}

print "Enter the desired chunk file size in bytes: ";
my $chunk_size = <STDIN>;
chomp $chunk_size;
unless ($chunk_size =~ /^\d+$/ && $chunk_size > 0) {
    die "Chunk size must be a positive integer.";
}

# Open the target directory
opendir (DIR, $dir) or die "Couldn't open directory, $!";

# Read all text files from the directory
my @files = grep(/\.txt$/, readdir(DIR));
closedir(DIR);

if (scalar(@files) == 0) {
    die "There are no text files in the directory '$dir'.";
}

print "Found " . scalar(@files) . " text file(s) in the directory.\nStarting the concatenation process...\n";

my $all_text = ""; # This will hold the concatenated text

# Process each file
foreach my $file (@files) {
    print "Processing file: $file\n";
    open my $fh, '<', "$dir/$file" or die "Cannot open file $file: $!";
    while (my $line = <$fh>) {
        $line =~ s/\s+//g;  # Remove all whitespace
        $all_text .= $line; # Concatenate to the block of text
    }
    close $fh;
    print "File $file has been concatenated.\n";
}

print "All files have been processed. Total length of text: " . length($all_text) . " bytes.\n";
print "Starting to create chunks of size $chunk_size bytes...\n";

# Split the block into chunks and save to files
my $chunk_count = 0;
while (my $chunk = substr($all_text, 0, $chunk_size, '')) {
    $chunk_count++;
    my $chunk_file_name = "$dir/chunk_$chunk_count.txt";
    open my $out_fh, '>', $chunk_file_name or die "Cannot open chunk file: $!";
    print $out_fh $chunk;
    close $out_fh;
    print "Chunk $chunk_count created: $chunk_file_name\n";
}

print "Chunk creation complete. Generated $chunk_count chunk(s).\n";
