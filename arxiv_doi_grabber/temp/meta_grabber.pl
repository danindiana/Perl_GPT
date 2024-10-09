#!/usr/bin/env perl

use strict;
use warnings;
use LWP::UserAgent;
use JSON;
use File::Find;
use File::Basename;
use Getopt::Long;
use Time::HiRes qw(gettimeofday);
use Digest::MD5 qw(md5_hex);
use POSIX qw(strftime);

# Initialize LWP::UserAgent for HTTP requests
my $ua = LWP::UserAgent->new;
$ua->timeout(10);

# Initialize JSON parser
my $json = JSON->new->utf8;

# Define log file location
my $log_file = "meta_grabber_" . strftime("%Y%m%d_%H%M%S", localtime) . ".log";

# Redirect STDOUT and STDERR to log file
open(STDOUT, '>', $log_file) or die "Can't redirect STDOUT to $log_file: $!";
open(STDERR, '>&STDOUT') or die "Can't redirect STDERR to STDOUT: $!";

print "Logging output to $log_file\n";

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
            my $content_type = $response->header('Content-Type');
            if ($content_type =~ m{^(application/json|application/citeproc\+json)}) {
                my $json_data = eval { $json->decode($response->content) };
                if ($@) {
                    warn "Error parsing JSON for DOI $doi_link: $@";
                } else {
                    print "DOI: $doi_link\n";
                    print "Title: $json_data->{title}\n";
                    push @{$extracted_data{dois}}, { doi => $doi_link, title => $json_data->{title} };
                }
            } else {
                warn "Unexpected content type for DOI $doi_link: $content_type\n";
            }
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

            # Try to extract the title using multiple methods
            my $title;
            if ($html_content =~ /<h1 class="title">\s*Title:\s*(.*?)\s*<\/h1>/) {
                $title = $1;
            }
            elsif ($html_content =~ /<title>\s*(.*?)\s*<\/title>/) {
                $title = $1;
                $title =~ s/\s*\[\d+\]\s*$//;  # Remove any version number from title, e.g., "[v1]"
            }

            if ($title) {
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

# Function to find and process text files as they are found, accumulating data in a single hash
sub find_and_process_text_files {
    my ($directory, $all_extracted_data) = @_;

    find(sub {
        return if $File::Find::name eq 'index.pl';
        if (-f && /\.txt$/) {
            my $file = $File::Find::name;
            print "Processing file: $file\n";
            open my $fh, '<', $file or die "Cannot open file $file: $!";
            my $file_content = do { local $/; <$fh> };
            close $fh;

            my $extracted_data = extract_and_store_metadata($file_content);

            # Accumulate extracted data
            push @{$all_extracted_data->{dois}}, @{$extracted_data->{dois}};
            push @{$all_extracted_data->{arxivs}}, @{$extracted_data->{arxivs}};
        }
    }, $directory);
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
    ) or die "Error in command line arguments\n";

    if ($help) {
        print "Usage: $0 [--dir=DIR] [--output=DIR]\n";
        exit;
    }

    print "Starting program...\n";

    # Create output directory if it doesn't exist
    unless (-d $output_dir) {
        mkdir $output_dir or die "Cannot create output directory: $output_dir\n";
    }

    # Initialize a hash to store all extracted metadata
    my $all_extracted_data = { dois => [], arxivs => [] };

    # Start finding and processing files immediately
    find_and_process_text_files($directory, $all_extracted_data);

    # Generate a unique filename using timestamp
    my $timestamp = md5_hex(gettimeofday);
    my $output_file = "$output_dir/extracted_metadata_$timestamp.json";

    # Write accumulated data to a single JSON file
    open my $out_fh, '>', $output_file or die "Cannot open file $output_file: $!";
    print $out_fh $json->encode($all_extracted_data);
    close $out_fh;

    print "All extracted data saved to $output_file\n";
    print "Processing complete!\n";
}

# Run the main function
main();
