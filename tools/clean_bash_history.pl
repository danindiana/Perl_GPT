#!/usr/bin/perl
use strict;
use warnings;

# Define the default output directory and file name
my $default_dir = ".";
my $default_output_file = "$default_dir/cleaned_bash_history.txt";

# Function to save the bash history from .bash_history file
sub save_bash_history {
    my $history_file = "$ENV{HOME}/.bash_history";
    return $history_file if -e $history_file;
    die "No history file found at $history_file\n";
}

# Prompt the user to either use the current bash history or specify a file
print "Do you want to use the current Bash history? (y/n): ";
chomp(my $use_bash_history = <STDIN>);

my $input_file;
if ($use_bash_history =~ /^y(es)?$/i) {
    $input_file = save_bash_history();
    print "Using Bash history from $input_file.\n";
} else {
    print "Enter the name of the file to clean: ";
    chomp($input_file = <STDIN>);
    
    # Check if the specified file exists and is readable
    unless (-e $input_file && -r $input_file) {
        die "File does not exist or cannot be read: $input_file\n";
    }
}

# Open the input file for reading
open(my $in, '<', $input_file) or die "Cannot open $input_file: $!";

# Open the output file for writing in the default directory
open(my $out, '>', $default_output_file) or die "Cannot open $default_output_file: $!";

# Process each line to remove leading numbers and spaces
while (my $line = <$in>) {
    $line =~ s/^\s*\d+\s+//;  # Remove line numbers and leading spaces
    print $out $line;
}

# Close filehandles
close($in);
close($out);

print "Cleaned history saved to $default_output_file\n";
