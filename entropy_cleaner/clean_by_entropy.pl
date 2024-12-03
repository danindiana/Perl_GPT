#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use List::Util qw(sum);
use File::Find;

my $entropy_threshold = 3.5;  # Adjust this threshold based on your needs

sub calculate_entropy {
    my ($file) = @_;
    open my $fh, '<', $file or die "Could not open $file: $!";
    my %freq;
    my $total_chars = 0;

    while (my $char = getc($fh)) {
        $freq{$char}++;
        $total_chars++;
    }
    close $fh;

    my $entropy = 0;
    foreach my $count (values %freq) {
        my $p = $count / $total_chars;
        $entropy -= $p * log($p) / log(2);
    }

    return $entropy;
}

# Prompt for target directory
print "Enter the target directory: ";
my $target_dir = <STDIN>;
chomp $target_dir;

# Prompt for recursive search
print "Do you wish to search recursively through all subfolders? (y/n): ";
my $recursive = <STDIN>;
chomp $recursive;

# Collect files to remove
my @files_to_remove;
my $total_size_to_remove = 0;

if ($recursive =~ /^y(es)?$/i) {
    find(\&process_file, $target_dir);
} else {
    opendir(my $dh, $target_dir) or die "Could not open directory $target_dir: $!";
    while (my $file = readdir($dh)) {
        next if $file =~ /^\.\.?$/;  # Skip . and ..
        process_file("$target_dir/$file");
    }
    closedir($dh);
}

sub process_file {
    my $file = $File::Find::name;
    return unless defined $file;  # Ensure $file is defined
    return unless -f $file && $file =~ /\.txt$/;  # Ensure it's a file and a .txt file

    my $entropy = calculate_entropy($file);
    if ($entropy < $entropy_threshold) {
        my $size = -s $file;
        push @files_to_remove, { file => $file, entropy => $entropy, size => $size };
        $total_size_to_remove += $size;
    }
}

# Display files to be removed and total size
if (@files_to_remove) {
    print "Files to be removed:\n";
    foreach my $file_info (@files_to_remove) {
        printf "File: %-30s Entropy: %-10s Size: %s bytes\n", $file_info->{file}, $file_info->{entropy}, $file_info->{size};
    }
    printf "Total size to be removed: %d bytes\n", $total_size_to_remove;

    # Prompt for confirmation before removing files
    print "Do you want to proceed with the removal? (y/n): ";
    my $response = <STDIN>;
    chomp $response;

    if ($response =~ /^y(es)?$/i) {
        foreach my $file_info (@files_to_remove) {
            unlink $file_info->{file} or warn "Could not unlink $file_info->{file}: $!";
        }
        print "Files have been removed.\n";
    } else {
        print "Removal aborted.\n";
    }
} else {
    print "No files to remove.\n";
}
