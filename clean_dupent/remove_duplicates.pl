#!/usr/bin/perl

use strict;
use warnings;

sub get_input {
    print $_[0];
    return <STDIN>;
}

sub select_file {
    my $pattern = $_[0];
    my @files = glob($pattern);
    
    print "Select the file to process:\n";
    for my $i (0..$#files) {
        print "$i) $files[$i]\n";
    }
    
    my $selection = -1;
    while ($selection < 0 || $selection > $#files) {
        $selection = get_input("Enter the number of the file: ");
        chomp($selection);
    }
    
    return $files[$selection];
}

sub remove_duplicates {
    my ($input_file, $output_file) = @_;
    my %seen;
    
    open(my $in_fh, '<', $input_file) or die "Can't open input file: $!";
    open(my $out_fh, '>', $output_file) or die "Can't create output file: $!";
    
    while (my $line = <$in_fh>) {
        next if $seen{$line};
        $seen{$line} = 1;
        print $out_fh $line;
    }
    
    close($in_fh);
    close($out_fh);
}

sub suggest_filename {
    my $input_file = shift;
    my $suggested = "unique_" . $input_file;
    return $suggested;
}

sub main {
    print "Duplicate Entry Removal Program\n";
    
    my $input_file = select_file("*");
    my $output_file = get_input("Enter the name of the output file: ");
    chomp($output_file);
    
    if (-e $output_file) {
        print "The file '$output_file' already exists. Please choose a different name.\n";
        exit;
    }
    
    remove_duplicates($input_file, $output_file);
    print "Duplicates removed. Output saved to '$output_file'.\n";
    
    my $suggested_name = suggest_filename($input_file);
    print "Suggested filename for the next run: '$suggested_name'\n";
}

main();
