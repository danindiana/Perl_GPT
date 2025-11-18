#!/usr/bin/env perl

=head1 NAME

basic_file_search.pl - Example of using the file scanner utility

=head1 SYNOPSIS

    perl examples/basic_file_search.pl

=head1 DESCRIPTION

This example demonstrates how to search for files matching specific keywords
using the file_scanner.pl utility. It shows both recursive and non-recursive
search patterns.

=cut

use strict;
use warnings;
use File::Find;
use File::Spec;

print "=" x 60, "\n";
print "File Scanner Example\n";
print "=" x 60, "\n\n";

# Example 1: Define keywords to search for
my @keywords = qw(example test demo sample);

print "Searching for files containing keywords: @keywords\n\n";

# Example 2: Simple file search in current directory
print "Example 1: Non-recursive search in current directory\n";
print "-" x 60, "\n";

my @matched_files;

opendir(my $dh, '.') or die "Cannot open current directory: $!";
while (my $file = readdir $dh) {
    next if $file =~ /^\./;  # Skip hidden files
    next unless -f $file;     # Only process files

    foreach my $keyword (@keywords) {
        if ($file =~ /\Q$keyword\E/i) {
            push @matched_files, $file;
            print "  Found: $file (matched: $keyword)\n";
            last;
        }
    }
}
closedir $dh;

print "\nTotal matches in current directory: ", scalar @matched_files, "\n\n";

# Example 3: Recursive search
print "Example 2: Recursive search starting from examples/\n";
print "-" x 60, "\n";

my @recursive_matches;

if (-d 'examples') {
    find(
        sub {
            return unless -f $_;  # Only files
            my $filename = $_;

            foreach my $keyword (@keywords) {
                if ($filename =~ /\Q$keyword\E/i) {
                    push @recursive_matches, $File::Find::name;
                    print "  Found: $File::Find::name\n";
                    last;
                }
            }
        },
        'examples'
    );

    print "\nTotal matches (recursive): ", scalar @recursive_matches, "\n\n";
}

# Example 4: Search with custom pattern
print "Example 3: Search for Perl scripts only\n";
print "-" x 60, "\n";

my @perl_scripts;

if (-d 'tools') {
    opendir(my $tools_dh, 'tools') or die "Cannot open tools directory: $!";
    while (my $file = readdir $tools_dh) {
        next unless $file =~ /\.pl$/;  # Only .pl files
        push @perl_scripts, "tools/$file";
        print "  Found: tools/$file\n";
    }
    closedir $tools_dh;

    print "\nTotal Perl scripts found: ", scalar @perl_scripts, "\n\n";
}

# Example 5: Display usage information
print "=" x 60, "\n";
print "Usage Tips:\n";
print "=" x 60, "\n";
print <<'USAGE';

To use the actual file_scanner.pl utility:

    cd tools
    perl file_scanner.pl

You'll be prompted for:
  1. Target directory to search
  2. Whether to search recursively
  3. Whether to list matched files
  4. Whether to delete matched files (with confirmation)

For safe testing, always:
  - Start with non-recursive searches
  - Review the list before confirming deletion
  - Test on sample directories first

USAGE

print "\nExample completed successfully!\n";

__END__

=head1 AUTHOR

Perl_GPT Examples

=head1 LICENSE

GPL-3.0

=cut
