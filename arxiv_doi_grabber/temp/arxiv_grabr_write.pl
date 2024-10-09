#!/usr/bin/env perl

use strict;
use warnings;
use LWP::UserAgent;
use JSON;
use File::Find;
use File::Basename;
use Getopt::Long;
use Pod::Usage;
use Time::HiRes qw(gettimeofday);
use Digest::MD5 qw(md5_hex);

# Initialize LWP::UserAgent for HTTP requests
my $ua = LWP::UserAgent->new;
$ua->timeout(10);

# Initialize JSON parser
my $json = JSON->new->utf8;

# Function to extract and store metadata
sub extract_and_store_metadata {
    my ($file_content) = @_;
    my %extracted_data = (dois => [], arxivs => []);

    # Regular expressions to match DOI and arXiv links
    my $doi_regex = qr/CRAWLING: (https:\/\/dx\.doi\.org\/.*)/;
    my $arxiv_regex = qr/CRAWLING: (https:\/\/arxiv\.org\/abs\/.*)/;

    # Extract DOI links
    while ($file_content =~ /$doi_regex/g) {
        my $doi_link = $1;
        print "Fetching DOI metadata for: $doi_link\n";
        my $response = $ua->get($doi_link, 'Accept' => 'application/citeproc+json');
        if ($response->is_success) {
            my $json_data = $json->decode($response->content);
            print "DOI: $doi_link\n";
            print "Title: $json_data->{title}\n";
            push @{$extracted_data{dois}}, { doi => $doi_link, title => $json_data->{title} };
        } else {
            warn "Error fetching DOI metadata: ", $response->status_line, "\n";
        }
    }

    # Extract arXiv links
    while ($file_content =~ /$arxiv_regex/g) {
        my $arxiv_link = $1;
        print "Fetching arXiv metadata for: $arxiv_link\n";
        my $response = $ua->get($arxiv_link);
        if ($response->is_success) {
            my $html_content = $response->content;
            if ($html_content =~ /<h1 class="title">\s*Title:\s*(.*?)\s*<\/h1>/) {
                my $title = $1;
                print "arXiv: $arxiv_link\n";
                print "Title: $title\n";
                push @{$extracted_data{arxivs}}, { arxiv => $arxiv_link, title => $title };
            } else {
                warn "Error parsing arXiv title\n";
            }
        } else {
            warn "Error fetching arXiv metadata: ", $response->status_line, "\n";
        }
    }

    return \%extracted_data;
}

# Function to find text files
sub find_text_files {
    my ($directory) = @_;
    my @text_files;

    find(sub {
        return if $File::Find::name eq 'index.pl';
        if (-f && /\.txt$/) {
            push @text_files, $File::Find::name;
        }
    }, $directory);

    print "Found ", scalar(@text_files), " text files.\n";
    return @text_files;
}

# Function to process files
sub process_files {
    my (@files) = @_;

    for my $file (@files) {
        print "Processing file: $file\n";
        open my $fh, '<', $file or die "Cannot open file $file: $!";
        my $file_content = do { local $/; <$fh> };
        close $fh;

        my $extracted_data = extract_and_store_metadata($file_content);

        # Write to individual JSON files
        my $output_file = $file;
        $output_file =~ s/\.txt$/_extracted.json/;
        open my $out_fh, '>', $output_file or die "Cannot open file $output_file: $!";
        print $out_fh $json->encode($extracted_data);
        close $out_fh;
        print "Extracted data from $file saved to $output_file\n";
    }
}

# Main function
sub main {
    my $help = 0;
    my $directory = '.';
    my $output_dir = '.';

    GetOptions(
        'help|?' => \$help,
        'dir=s' => \$directory,
        'output=s' => \$output_dir,
    ) or pod2usage(2);

    pod2usage(1) if $help;

    print "Starting program...\n";
    my @text_files = find_text_files($directory);

    if (@text_files) {
        print "Available files:\n";
        for my $i (0 .. $#text_files) {
            print "$i. $text_files[$i]\n";
        }

        # Write found files to a text file
        my $parent_dir = basename($directory);
        my $timestamp = md5_hex(gettimeofday);
        my $output_file = "$output_dir/$parent_dir\_$timestamp.txt";
        print "Writing found files to $output_file in directory $output_dir\n";
        open my $out_fh, '>', $output_file or die "Cannot open file $output_file: $!";
        print $out_fh join("\n", @text_files);
        close $out_fh;
        print "Found files written to $output_file\n";

        print "Enter the numbers of the files you want to process (e.g., 1-3, 5, 7-9): ";
        my $input = <STDIN>;
        chomp $input;

        my @selected_indices = parse_selection($input, scalar(@text_files));
        my @selected_files = @text_files[@selected_indices];

        process_files(@selected_files);
        print "Processing complete!\n";
        print "Found files written to $output_file in directory $output_dir\n";
    } else {
        print "No relevant files found.\n";
    }
}

# Function to parse user selection
sub parse_selection {
    my ($input, $max_index) = @_;
    print "Parsing user selection...\n";
    my @selections = split /,/, $input;
    my @indices;

    for my $selection (@selections) {
        if ($selection =~ /(\d+)-(\d+)/) {
            my ($start, $end) = ($1, $2);
            if ($start < 1 || $end > $max_index || $start > $end) {
                warn "Invalid selection: $selection\n";
                next;
            }
            push @indices, $start .. $end;
        } else {
            my $index = $selection;
            if ($index < 1 || $index > $max_index) {
                warn "Invalid selection: $selection\n";
                next;
            }
            push @indices, $index;
        }
    }

    print "Selected files: ", join(', ', @indices), "\n";
    return @indices;
}

# Run the main function
main();

__END__

=head1 NAME

metadata_extractor.pl - Extract metadata from DOI and arXiv links in text files

=head1 SYNOPSIS

metadata_extractor.pl [options]

Options:
  --help        Show this help message
  --dir=DIR     Directory to scan for text files (default: current directory)
  --output=DIR  Directory to write the output file (default: current directory)

=head1 DESCRIPTION

This script scans a directory for text files containing DOI and arXiv links,
extracts metadata from these links, and stores the metadata in individual JSON files.

=cut