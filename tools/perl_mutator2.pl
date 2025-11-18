#!/usr/bin/perl

use strict;
use warnings;
use Data::Random qw(:all);

sub convert_urls_to_random_strings {
    my ($text) = @_;
    $text =~ s{(https?://\S+)}{_generate_random_string()}eg;
    return $text;
}

sub _generate_random_string {
    my $random_string = rand_chars(size => 20, set => 'alphanumeric');
    return $random_string;
}

sub main {
    print "URL to Random String Converter\n";

    print "Enter the name of the text file to convert: ";
    my $input_file = <STDIN>;
    chomp($input_file);

    # Convert Windows path separator to Unix-like
    $input_file =~ s/\\/\//g;

    # Check if the input file exists
    unless (-e $input_file) {
        print "Error: The specified file does not exist.\n";
        return;
    }

    # Read the content of the input file
    open(my $fh_in, '<', $input_file) or die "Error: Cannot open file '$input_file': $!";
    my $data = do { local $/; <$fh_in> };
    close($fh_in);

    # Convert URLs to random strings with more entropy
    my $converted_data = convert_urls_to_random_strings($data);

    # Suggest the output file name
    my $output_file = "converted_output.txt";

    # Convert Windows path separator to Unix-like
    $output_file =~ s/\\/\//g;

    # Write the converted data to the output file
    open(my $fh_out, '>', $output_file) or die "Error: Cannot open file '$output_file' for writing: $!";
    print $fh_out $converted_data;
    close($fh_out);

    print "Conversion completed. The converted data has been saved to '$output_file'.\n";
}

main();
