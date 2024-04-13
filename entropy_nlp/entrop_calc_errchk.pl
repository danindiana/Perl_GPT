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

    open(my $fh, '<', $filename) or die "Can't open file: $!";
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
        die "Probability distributions must have the same length\n";
    }

    my $kl_div = 0;
    for my $i (0..$#$p) {
        next if $p->[$i] == 0 || $q->[$i] == 0;
        $kl_div += $p->[$i] * log($p->[$i] / $q->[$i]) / log(2); 
    }
    return $kl_div;
}

# Jensen-Shannon Divergence
sub jensen_shannon_divergence {
    my ($dist1, $dist2) = @_; 
    say "Calculating Jensen-Shannon Divergence...";

    my @jsd_temp_m = map { ($dist1->[$_] + $dist2->[$_]) / 2 } 0 .. $#$dist1;

    return 0.5 * (kl_divergence($dist1, \@jsd_temp_m) + kl_divergence($dist2, \@jsd_temp_m)); 
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
my @selected_indices = parse_selection($selection_str); 

# Calculate entropy for selected files
for my $index (@selected_indices) {
    my $selected_file = $text_files[$index];
    my $entropy = calculate_entropy($selected_file);
    say "Shannon Entropy of the file $selected_file: $entropy";
}

# Example usage - with error handling
my @distribution1 = (0.4, 0.3, 0.3);
my @distribution2 = (0.2, 0.5, 0.3);
say "Initial Distributions: [@distribution1] and [@distribution2]";

# Error Checks before KL and JS Divergence calculation
if (scalar(@distribution1) != scalar(@distribution2)) {
    die "Distributions must have the same length for divergence calculations\n";
}

if (grep { $_ < 0 || $_ > 1 } @distribution1, @distribution2) {
    die "Distribution values must be probabilities (between 0 and 1)\n";
}

my $kl_div = kl_divergence(\@distribution1, \@distribution2); 
say "Kullback-Leibler divergence: $kl_div";

my $js_div = jensen_shannon_divergence(\@distribution1, \@distribution2);
say "Jensen-Shannon divergence: $js_div";

# --- Helper function to parse user selection ---
sub parse_selection {
    # ... (No changes needed in this function)
} 

# --- Helper function to parse user selection ---
sub parse_selection {
    my ($input) = @_;
    my @indices;

    for my $part (split /,/, $input) {
        if ($part =~ /(\d+)-(\d+)/) {  # Range: 1-5
            push @indices, $_ for $1 .. $2;         
        } elsif ($part =~ /^\d+$/) {     # Single number
            push @indices, $part - 1; # Adjust for zero-based indexing
        } else {
            die "Invalid selection format\n";
        }
    }
    return @indices;
} 
