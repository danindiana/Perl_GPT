#!/usr/bin/perl

use strict;
use warnings;
use Math::BaseCalc; # Using standard log for base conversion
use feature 'say';  # Convenient say feature
use File::Find;     # For finding files in directories

# Function to calculate Shannon Entropy
sub calculate_entropy {
    my ($filename) = @_;

    my %char_counts = ();
    my $total_chars = 0;

    open(my $fh, '<', $filename) or die "Can't open file '$filename': $!";
    while (<$fh>) {
        chomp;
        $char_counts{$_}++ for split //;
        $total_chars += length($_);
    }
    close $fh;

    say "Total Characters Processed: $total_chars";

    my $entropy = 0;
    for my $char (keys %char_counts) {
        my $prob = $char_counts{$char} / $total_chars;
        $entropy -= $prob * log2($prob);
    }

    return $entropy;
}

sub log2 {
    my $n = shift;
    return log($n) / log(2);
}

# Kullback-Leibler Divergence
sub kl_divergence {
    my ($p, $q) = @_;

    say "Calculating Kullback-Leibler Divergence...";

    if (scalar @$p != scalar @$q) {
        die "Entropies must have the same length for divergence calculations\n";
    }

    my $kl_div = 0;
    for my $i (0..$#$p) {
        next if $p->[$i] == 0 || $q->[$i] == 0;
        $kl_div += $p->[$i] * log($p->[$i] / $q->[$i]);
    }
    return $kl_div / log(2); # Normalize by log base 2
}

# Jensen-Shannon Divergence
sub jensen_shannon_divergence {
    my ($p, $q) = @_;

    say "Calculating Jensen-Shannon Divergence...";

    if (scalar @$p != scalar @$q) {
        die "Entropies must have the same length for divergence calculations\n";
    }

    my $js_div = 0;
    for my $i (0..$#$p) {
        my $avg = ($p->[$i] + $q->[$i]) / 2;
        $js_div += $avg * log($avg / $p->[$i]) + $avg * log($avg / $q->[$i]);
    }
    return $js_div / (2 * log(2)); # Normalize by log base 2
}

# File selection logic
my $default_dir = '.';  # Set your desired default directory

my @text_files;
find(sub { push @text_files, $File::Find::name if /\.txt$/i }, $default_dir);

if (!@text_files) {
    die "No text files found in the default directory\n";
}

# Display numbered file list
say "Select file(s) by entering numbers (e.g., 1, 3-5, 8):";
for (my $i = 0; $i < @text_files; $i++) {
    say "  ", $i + 1, ". ", $text_files[$i];
}

# Get user input
my $selection_str = <STDIN>;
chomp $selection_str;

# Process user selection
my @selected_indices = parse_selection($selection_str, \@text_files);

# Calculate entropy for selected files and store in an array
my @entropies;
for my $index (@selected_indices) {
    my $selected_file = $text_files[$index];
    if (-e $selected_file) { # Check if the file exists
        my $entropy = calculate_entropy($selected_file);
        say "Shannon Entropy of the file $selected_file: $entropy";
        push @entropies, $entropy;
    } else {
        say "File '$selected_file' does not exist.";
    }
}

# Calculate KL divergence and JS divergence between the entropies
if (@entropies > 1) {
    for my $i (0..$#entropies-1) {
        for my $j ($i+1..$#entropies) {
            my $kl_div = kl_divergence([$entropies[$i]], [$entropies[$j]]);
            say "Kullback-Leibler divergence between entropies of file $text_files[$selected_indices[$i]] and file $text_files[$selected_indices[$j]]: $kl_div";

            my $js_div = jensen_shannon_divergence([$entropies[$i]], [$entropies[$j]]);
            say "Jensen-Shannon divergence between entropies of file $text_files[$selected_indices[$i]] and file $text_files[$selected_indices[$j]]: $js_div";
        }
    }
} else {
    say "Not enough files selected to compare entropies.";
}

# --- Helper function to parse user selection ---
sub parse_selection {
    my ($input, $file_list) = @_;
    my @indices;

    for my $part (split /,/, $input) {
        if ($part =~ /(\d+)-(\d+)/) {  # Range: 1-5
            for my $index ($1 .. $2) {
                if ($index >= 1 && $index <= scalar @$file_list) {
                    push @indices, $index - 1; # Adjust for zero-based indexing
                } else {
                    die "Invalid file index: $index\n";
                }
            }
        } elsif ($part =~ /^\d+$/) {     # Single number
            my $index = $part - 1; # Adjust for zero-based indexing
            if ($index >= 0 && $index < scalar @$file_list) {
                push @indices, $index;
            } else {
                die "Invalid file index: $part\n";
            }
        } else {
            die "Invalid selection format: $part\n";
        }
    }
    return @indices;
}
