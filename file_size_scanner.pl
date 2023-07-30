#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

sub get_user_input {
    my $prompt = shift;
    print $prompt;
    chomp(my $input = <STDIN>);
    return $input;
}

sub list_files {
    my $dir = shift;
    my $max_size_mb = shift;

    my $max_size_bytes = $max_size_mb * 1024 * 1024;
    my @files;

    opendir my $dh, $dir or die "Could not open '$dir' for reading: $!\n";
    while (my $file = readdir $dh) {
        next if $file eq '.' or $file eq '..';  # Ignore . and .. directories
        my $file_path = "$dir/$file";  # Get the full file path
        next unless -f $file_path;  # Ignore directories

        my $size_bytes = -s $file_path;
        if ($size_bytes <= $max_size_bytes) {
            push @files, $file_path;
        }
    }
    closedir $dh;

    return @files;
}

sub delete_files {
    my @files = @_;

    return unless @files;

    print "The following files will be deleted:\n";
    foreach my $file (@files) {
        print "$file\n";
    }

    my $confirmation = get_user_input("Do you want to delete these files? (y/n): ");
    if ($confirmation =~ /^y$/i) {
        my $deleted_count = 0;
        foreach my $file (@files) {
            if (unlink $file) {
                $deleted_count++;
            }
        }
        print "$deleted_count files deleted.\n";
    } else {
        print "Deletion canceled.\n";
    }
}

sub main {
    my $directory = get_user_input("Please enter the directory to scan: ");
    my $max_size = get_user_input("Please enter the maximum file size (in MB): ");
    
    my @files = list_files($directory, $max_size);
    if (@files) {
        delete_files(@files);
    } else {
        print "No files found within the specified criteria.\n";
    }
}

main();
