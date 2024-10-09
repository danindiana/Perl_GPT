#!/usr/bin/env perl

use strict;
use warnings;
use LWP::UserAgent;
use JSON;
use File::Find;
use File::Basename;
use Getopt::Long;
use Time::HiRes qw(gettimeofday sleep);
use Digest::MD5 qw(md5_hex);
use POSIX qw(strftime);
use XML::Simple;
use List::Util qw(shuffle);

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

# Global retry queue
my @retry_queue;

# Function to extract and store metadata using the arXiv API with non-blocking retries
sub extract_arxiv_metadata {
    my ($arxiv_id) = @_;
    my $url = "http://export.arxiv.org/api/query?search_query=id:$arxiv_id";
    
    print "Fetching arXiv metadata for: $arxiv_id\n";
    my $response = $ua->get($url);

    if ($response->is_success) {
        my $xml_content = $response->decoded_content;

        # Parse the XML response
        my $xml = XML::Simple->new;
        my $data = $xml->XMLin($xml_content);

        # Extract title from the XML data
        if (exists $data->{entry}->{title}) {
            my $title = $data->{entry}->{title};
            $title =~ s/\n//g;  # Clean up newlines in the title
            print "arXiv: $arxiv_id\n";
            print "Title: $title\n";
            return { arxiv => $arxiv_id, title => $title };
        } else {
            warn "Error fetching metadata for $arxiv_id\n";
            return;
        }
    } else {
        warn "Error fetching arXiv API: ", $response->status_line, "\n";
        push @retry_queue, { arxiv_id => $arxiv_id, retries => 0, last_attempt => time() };
        return;
    }
}

# Function to retry failed arXiv requests in a non-blocking way
sub retry_failed_requests {
    my $max_retries = 5;
    my $retry_delay = 10;  # Retry every 10 seconds

    @retry_queue = shuffle(@retry_queue);  # Shuffle to avoid hammering the same requests in sequence

    for my $retry (@retry_queue) {
        my $arxiv_id = $retry->{arxiv_id};
        my $retries = $retry->{retries};
        my $last_attempt = $retry->{last_attempt};

        # Check if enough time has passed since the last attempt
        if (time() - $last_attempt >= $retry_delay) {
            print "Retrying arXiv metadata for: $arxiv_id (Attempt $retries)\n";

            my $result = extract_arxiv_metadata($arxiv_id);
            if ($result) {
                # Successfully fetched, remove from retry queue
                @retry_queue = grep { $_->{arxiv_id} ne $arxiv_id } @retry_queue;
            } else {
                # Increment retry count
                $retry->{retries}++;
                $retry->{last_attempt} = time();

                if ($retry->{retries} >= $max_retries) {
                    warn "Failed to fetch metadata for $arxiv_id after $max_retries attempts.\n";
                    @retry_queue = grep { $_->{arxiv_id} ne $arxiv_id } @retry_queue;
                }
            }
        }
    }
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

            # Extract arXiv links
            while ($file_content =~ /CRAWLING: (https:\/\/arxiv\.org\/abs\/([0-9]+\.[0-9]+))/g) {
                my $arxiv_link = $1;
                my $arxiv_id = $2;
                my $extracted_data = extract_arxiv_metadata($arxiv_id);

                if ($extracted_data) {
                    push @{$all_extracted_data->{arxivs}}, $extracted_data;
                }
            }

            # After processing each file, retry failed requests
            retry_failed_requests();
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
    my $all_extracted_data = { arxivs => [] };

    # Start finding and processing files immediately
    find_and_process_text_files($directory, $all_extracted_data);

    # Continue retrying failed requests after initial processing
    while (@retry_queue) {
        retry_failed_requests();
        sleep(1);  # Add a small sleep to avoid tight looping
    }

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
