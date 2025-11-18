#!/usr/bin/env perl

=head1 NAME

entropy_analysis.pl - Example of entropy-based text analysis

=head1 SYNOPSIS

    perl examples/entropy_analysis.pl

=head1 DESCRIPTION

This example demonstrates Shannon entropy calculation for text analysis,
showing how to identify low-entropy (repetitive) vs high-entropy (diverse) content.

=cut

use strict;
use warnings;

print "=" x 70, "\n";
print "Shannon Entropy Analysis Example\n";
print "=" x 70, "\n\n";

# Example 1: Calculate Shannon entropy for a string
sub calculate_shannon_entropy {
    my ($text) = @_;

    return 0 unless length($text);

    # Count character frequencies
    my %freq;
    $freq{$_}++ for split //, $text;

    # Calculate total characters
    my $total = length($text);

    # Calculate Shannon entropy: H = -Σ p(x) * log2(p(x))
    my $entropy = 0;
    foreach my $char (keys %freq) {
        my $probability = $freq{$char} / $total;
        $entropy -= $probability * log($probability) / log(2);
    }

    return $entropy;
}

# Example 2: Low entropy text (highly repetitive)
print "Example 1: Low Entropy Text\n";
print "-" x 70, "\n";

my $low_entropy_text = "aaaaaaaaaa" x 10;
my $low_entropy = calculate_shannon_entropy($low_entropy_text);

print "Text: ", substr($low_entropy_text, 0, 50), "...\n";
print "Length: ", length($low_entropy_text), " characters\n";
printf "Shannon Entropy: %.4f bits per character\n", $low_entropy;
print "Analysis: Very low entropy indicates highly repetitive content\n\n";

# Example 3: Medium entropy text
print "Example 2: Medium Entropy Text\n";
print "-" x 70, "\n";

my $medium_entropy_text = "The quick brown fox jumps over the lazy dog. " x 5;
my $medium_entropy = calculate_shannon_entropy($medium_entropy_text);

print "Text: ", substr($medium_entropy_text, 0, 50), "...\n";
print "Length: ", length($medium_entropy_text), " characters\n";
printf "Shannon Entropy: %.4f bits per character\n", $medium_entropy;
print "Analysis: Medium entropy indicates some variety\n\n";

# Example 4: High entropy text (more diverse)
print "Example 3: High Entropy Text\n";
print "-" x 70, "\n";

my $high_entropy_text = join "", map { chr(97 + int(rand(26))) } 1..500;
my $high_entropy = calculate_shannon_entropy($high_entropy_text);

print "Text: ", substr($high_entropy_text, 0, 50), "...\n";
print "Length: ", length($high_entropy_text), " characters\n";
printf "Shannon Entropy: %.4f bits per character\n", $high_entropy;
print "Analysis: Higher entropy indicates more diverse content\n\n";

# Example 5: Comparison
print "=" x 70, "\n";
print "Entropy Comparison\n";
print "=" x 70, "\n\n";

printf "%-20s %10s %15s\n", "Text Type", "Entropy", "Quality";
print "-" x 70, "\n";
printf "%-20s %10.4f %15s\n", "Repetitive", $low_entropy, "Low Quality";
printf "%-20s %10.4f %15s\n", "Medium Variety", $medium_entropy, "Medium Quality";
printf "%-20s %10.4f %15s\n", "High Diversity", $high_entropy, "High Quality";

print "\n";
print "Interpretation:\n";
print "  0.0 - 2.0 bits: Very low entropy (likely spam or corrupted)\n";
print "  2.0 - 3.5 bits: Low entropy (may be low-quality content)\n";
print "  3.5 - 4.5 bits: Medium entropy (typical text)\n";
print "  4.5+    bits: High entropy (diverse, quality content)\n\n";

# Example 6: Character distribution
print "=" x 70, "\n";
print "Character Distribution Analysis\n";
print "=" x 70, "\n\n";

sub analyze_distribution {
    my ($text, $label) = @_;

    my %freq;
    $freq{$_}++ for split //, $text;

    my $total = length($text);
    my $unique = scalar keys %freq;

    print "$label:\n";
    print "  Total characters: $total\n";
    print "  Unique characters: $unique\n";
    printf "  Diversity ratio: %.2f%%\n", ($unique / $total) * 100;

    # Show top 5 most frequent characters
    my @sorted = sort { $freq{$b} <=> $freq{$a} } keys %freq;
    print "  Top 5 characters:\n";
    foreach my $i (0..4) {
        last unless defined $sorted[$i];
        my $char = $sorted[$i];
        my $count = $freq{$char};
        my $pct = ($count / $total) * 100;
        printf "    '%s': %d (%.1f%%)\n",
            $char eq ' ' ? 'SPACE' : $char, $count, $pct;
    }
    print "\n";
}

analyze_distribution($low_entropy_text, "Low Entropy Text");
analyze_distribution($medium_entropy_text, "Medium Entropy Text");
analyze_distribution($high_entropy_text, "High Entropy Text");

# Example 7: Usage with actual files
print "=" x 70, "\n";
print "Using Entropy Analysis with Files\n";
print "=" x 70, "\n\n";

print <<'USAGE';
To analyze actual files with the entropy_cleaner module:

    cd entropy_cleaner
    perl clean_by_entropy.pl

This will:
  1. Scan all files in a directory
  2. Calculate Shannon entropy for each file
  3. Identify files below the threshold (default: 3.5 bits)
  4. Optionally remove low-quality files

To use the advanced entropy_nlp module (includes KL and JS divergence):

    cd entropy_nlp
    perl ShannJensKL_EntropyCalc.pl <file1> <file2>

This calculates:
  - Shannon Entropy for each file
  - Kullback-Leibler Divergence between files
  - Jensen-Shannon Divergence between files

USAGE

print "\nExample completed successfully!\n";

__END__

=head1 FUNCTIONS

=head2 calculate_shannon_entropy($text)

Calculates Shannon entropy for a given text string.

Returns entropy value in bits per character.

=head2 analyze_distribution($text, $label)

Analyzes and displays character distribution statistics.

=head1 AUTHOR

Perl_GPT Examples

=head1 LICENSE

GPL-3.0

=cut
