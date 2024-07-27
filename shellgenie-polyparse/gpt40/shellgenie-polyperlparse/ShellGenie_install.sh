#!/bin/bash

# ShellGenie Installation Script

# Define the base directory for ShellGenie
BASE_DIR="$HOME/programs/shell_genie/perl_poly_pars"

# Create the directory structure
echo "Creating directory structure..."
mkdir -p $BASE_DIR/lib
mkdir -p $BASE_DIR/test/t
mkdir -p $BASE_DIR/examples
mkdir -p $BASE_DIR/docs

# Create the ShellGenieParser module
echo "Creating ShellGenieParser module..."
cat << 'EOF' > $BASE_DIR/lib/ShellGenieParser.pm
package ShellGenieParser;

use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw(register_command parse_command);

my @command_registry;

# Register a new command with its pattern, action, and optional argument validation
sub register_command {
    my ($pattern, $action, $arg_validator) = @_;
    push @command_registry, { Pattern => $pattern, Action => $action, ArgValidator => $arg_validator };
}

# Parse the command and execute the corresponding action
sub parse_command {
    my ($command) = @_;
    foreach my $entry (@command_registry) {
        if ($command =~ $entry->{Pattern}) {
            my @matches = ($command =~ $entry->{Pattern});
            if ($entry->{ArgValidator}) {
                unless ($entry->{ArgValidator}->(@matches)) {
                    warn "Invalid arguments for command: $command\n";
                    return 0;
                }
            }
            eval {
                $entry->{Action}->(@matches);
            };
            if ($@) {
                warn "Error executing command: $@\n";
                return 0;
            }
            return 1;
        }
    }
    warn "No matching pattern for command: $command\n";
    return 0; # No pattern matched
}

1; # End of ShellGenieParser.pm
EOF

# Create the ShellGenieInterface module
echo "Creating ShellGenieInterface module..."
cat << 'EOF' > $BASE_DIR/lib/ShellGenieInterface.pm
package ShellGenieInterface;

use strict;
use warnings;
use Exporter 'import';
use JSON;
use LWP::UserAgent;
use ShellGenieParser qw(parse_command);

our @EXPORT_OK = qw(handle_user_input);

# Function to handle user input
sub handle_user_input {
    my ($input) = @_;
    
    # Call the language model API
    my $interpreted_command = call_language_model($input);
    
    if ($interpreted_command) {
        # Parse the interpreted command
        if (parse_command($interpreted_command)) {
            print "Command executed successfully.\n";
        } else {
            print "Failed to execute command: $interpreted_command\n";
        }
    } else {
        print "Failed to interpret input: $input\n";
    }
}

# Function to call the language model API
sub call_language_model {
    my ($input) = @_;
    
    my $ua = LWP::UserAgent->new;
    my $server_endpoint = 'http://localhost:8000/api';
    
    my $response = $ua->post(
        $server_endpoint,
        Content_Type => 'application/json',
        Content      => encode_json({ input => $input })
    );
    
    if ($response->is_success) {
        my $decoded = decode_json($response->decoded_content);
        return $decoded->{interpreted_command};
    } else {
        warn "Failed to call language model API: " . $response->status_line;
        return '';
    }
}

1; # End of ShellGenieInterface.pm
EOF

# Create example command file with validation
echo "Creating example commands with validation..."
cat << 'EOF' > $BASE_DIR/examples/example_with_validation.pm
use lib '../lib';
use ShellGenieParser qw(register_command parse_command);

# Command handler for `mkdir` command
sub handle_mkdir_command {
    my ($dirname) = @_;
    system("mkdir -p $dirname");
}

# Argument validator for `mkdir` command
sub validate_mkdir_args {
    my ($dirname) = @_;
    return $dirname =~ /^[a-zA-Z0-9_\-\/]+$/; # Simple validation for directory name
}

# Register the `mkdir` command pattern, action, and argument validator
register_command(qr/^mkdir\s+(.*)/, \&handle_mkdir_command, \&validate_mkdir_args);

# Parse an example command
my $command = 'mkdir test_dir';
parse_command($command);
EOF

# Create advanced commands example
echo "Creating advanced commands example..."
cat << 'EOF' > $BASE_DIR/examples/advanced_commands.pm
use lib '../lib';
use ShellGenieParser qw(register_command parse_command);

# Command handler for `grep` command
sub handle_grep_command {
    my ($pattern, $filename) = @_;
    system("grep '$pattern' $filename");
}

# Argument validator for `grep` command
sub validate_grep_args {
    my ($pattern, $filename) = @_;
    return ($pattern && $filename && $filename =~ /^[a-zA-Z0-9_\-\/\.]+$/);
}

# Register the `grep` command pattern, action, and argument validator
register_command(qr/^grep\s+'(.*)'\s+(\S+)/, \&handle_grep_command, \&validate_grep_args);

# Command handler for `echo` command
sub handle_echo_command {
    my ($message) = @_;
    system("echo '$message'");
}

# Argument validator for `echo` command
sub validate_echo_args {
    my ($message) = @_;
    return defined $message;
}

# Register the `echo` command pattern, action, and argument validator
register_command(qr/^echo\s+'(.*)'/, \&handle_echo_command, \&validate_echo_args);

# Parse example commands
parse_command("grep 'hello' test_file.txt");
parse_command("echo 'Hello, World!'");
EOF

# Create test script for ShellGenieParser
echo "Creating test scripts..."
cat << 'EOF' > $BASE_DIR/test/t/test_parser.t
use Test::More tests => 2;
use lib '../../lib';
use ShellGenieParser qw(register_command parse_command);

# Mock command handler for testing
sub mock_command_handler {
    pass("Command handler executed");
}

# Register a mock command
register_command(qr/^mock\s+command/, \&mock_command_handler);

# Test: Successful command parsing
ok(parse_command('mock command'), "Command parsed successfully");

# Test: Unsuccessful command parsing
ok(!parse_command('unknown command'), "Unknown command not parsed");
EOF

# Create test script for advanced commands
cat << 'EOF' > $BASE_DIR/test/t/test_advanced_commands.t
use Test::More tests => 6;
use lib '../../lib';
use ShellGenieParser qw(register_command parse_command);

# Mock command handlers for testing
sub mock_grep_handler {
    pass("grep command handler executed");
}
sub mock_echo_handler {
    pass("echo command handler executed");
}

# Argument validators for testing
sub mock_grep_validator {
    my ($pattern, $filename) = @_;
    return ($pattern eq 'test' && $filename eq 'test_file.txt');
}
sub mock_echo_validator {
    my ($message) = @_;
    return $message eq 'Hello, World!';
}

# Register mock commands
register_command(qr/^grep\s+'(.*)'\s+(\S+)/, \&mock_grep_handler, \&mock_grep_validator);
register_command(qr/^echo\s+'(.*)'/, \&mock_echo_handler, \&mock_echo_validator);

# Test: Successful grep command parsing
ok(parse_command("grep 'test' test_file.txt"), "grep command parsed successfully");

# Test: Unsuccessful grep command parsing due to invalid arguments
ok(!parse_command("grep 'test' invalid/file!"), "Invalid grep command not parsed");

# Test: Successful echo command parsing
ok(parse_command("echo 'Hello, World!'"), "echo command parsed successfully");

# Test: Unsuccessful echo command parsing due to invalid arguments
ok(!parse_command("echo"), "Invalid echo command not parsed");

# Test: Unsuccessful echo command parsing due to empty message
ok(!parse_command("echo ''"), "Empty echo command not parsed");

# Test: Unknown command parsing
ok(!parse_command("unknown command"), "Unknown command not parsed");
EOF

# Create a main script to run the system
echo "Creating main script..."
cat << 'EOF' > $BASE_DIR/main.pl
use lib './lib';
use ShellGenieInterface qw(handle_user_input);

# Load advanced commands
require 'examples/advanced_commands.pm';

# Example user inputs
my @inputs = (
    'list all files',
    'create test directory',
    'grep \'hello\' test_file.txt',
    'echo \'Hello, World!\'',
    'unknown command',
);

foreach my $input (@inputs) {
    print "User input: $input\n";
    handle_user_input($input);
}
EOF

# Create local language model server for testing
echo "Creating local language model server..."
cat << 'EOF' > $BASE_DIR/local_language_model_server.pl
#!/usr/bin/perl

use strict;
use warnings;
use HTTP::Daemon;
use HTTP::Status;
use JSON;

my $d = HTTP::Daemon->new(
    LocalAddr => 'localhost',
    LocalPort => 8000,
) || die "Failed to start server: $!";

print "Server running at: ", $d->url, "\n";

while (my $c = $d->accept) {
    while (my $r = $c->get_request) {
        if ($r->method eq 'POST' and $r->uri->path eq '/api') {
            my $content = $r->content;
            my $decoded = decode_json($content);
            my $input = $decoded->{input};
            
            my $interpreted_command = interpret_input($input);
            
            my $response = encode_json({ interpreted_command => $interpreted_command });
            $c->send_response(HTTP::Response->new(RC_OK, 'OK', ['Content-Type' => 'application/json'], $response));
        } else {
            $c->send_error(RC_FORBIDDEN)
        }
    }
    $c->close;
    undef($c);
}

sub interpret_input {
    my ($input) = @_;
    return 'ls -la' if $input eq 'list all files';
    return 'mkdir test_dir' if $input eq 'create test directory';
    return '';
}
EOF

# Create README documentation
echo "Creating README documentation..."
cat << 'EOF' > $BASE_DIR/docs/README.md
# ShellGenie Command Parser

## Overview

The ShellGenie command parser uses Perl's dynamic typing and regular expression capabilities to achieve polymorphism in command parsing. This allows for flexible and extensible handling of various command formats.

## Directory Structure

- `lib/`: Contains the core Perl module files.
- `test/`: Holds unit tests to ensure the parser functions correctly.
- `examples/`: Provides illustrative examples of defining new command parsers.
- `docs/`: Houses documentation for the component.

## Getting Started

1. **Run the local language model server:**
   ```bash
   perl local_language_model_server.pl
