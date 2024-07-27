### ShellGenie Command Parser: Setup and Implementation

We'll start building the ShellGenie command parser by setting up the necessary directory structure and initial Perl script to handle the command parsing. 

### Step 1: Directory Structure

Create the following directory structure for the ShellGenie command parser:

```bash
mkdir -p ~/programs/shell_genie/perl_poly_pars/lib
mkdir -p ~/programs/shell_genie/perl_poly_pars/test/t
mkdir -p ~/programs/shell_genie/perl_poly_pars/examples
mkdir -p ~/programs/shell_genie/perl_poly_pars/docs
```

### Step 2: Initial Perl Script

Create the main parser module in the `lib` directory.

**File:** `lib/ShellGenieParser.pm`

```perl
package ShellGenieParser;

use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw(register_command parse_command);

my @command_registry;

# Register a new command with its pattern and action
sub register_command {
    my ($pattern, $action) = @_;
    push @command_registry, { Pattern => $pattern, Action => $action };
}

# Parse the command and execute the corresponding action
sub parse_command {
    my ($command) = @_;
    foreach my $entry (@command_registry) {
        if ($command =~ $entry->{Pattern}) {
            my @matches = ($command =~ $entry->{Pattern});
            $entry->{Action}->(@matches);
            return 1;
        }
    }
    return 0; # No pattern matched
}

1; # End of ShellGenieParser.pm
```

### Step 3: Example Command

Create an example command parser in the `examples` directory.

**File:** `examples/example_commands.pm`

```perl
use lib '../lib';
use ShellGenieParser qw(register_command parse_command);

# Example command handler for `ls -l`
sub handle_ls_command {
    my ($options) = @_;
    system("ls $options");
}

# Register the `ls` command pattern and action
register_command(qr/^ls\s+(.*)/, \&handle_ls_command);

# Parse an example command
my $command = 'ls -la';
parse_command($command);
```

### Step 4: Test the Setup

Create a test script in the `test/t` directory.

**File:** `test/t/test_parser.t`

```perl
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
```

### Step 5: Run the Test

Execute the test script to ensure everything is set up correctly.

```bash
cd ~/programs/shell_genie/perl_poly_pars
prove test/t/test_parser.t
```

### Documentation

**File:** `docs/README.md`

```markdown
# ShellGenie Command Parser

## Overview

The ShellGenie command parser uses Perl's dynamic typing and regular expression capabilities to achieve polymorphism in command parsing. This allows for flexible and extensible handling of various command formats.

## Directory Structure

- `lib/`: Contains the core Perl module files.
- `test/`: Holds unit tests to ensure the parser functions correctly.
- `examples/`: Provides illustrative examples of defining new command parsers.
- `docs/`: Houses documentation for the component.

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd shell_genie/perl_poly_pars
   ```

2. **Run the example command:**
   ```bash
   perl examples/example_commands.pm
   ```

3. **Run the tests:**
   ```bash
   prove test/t/test_parser.t
   ```

## Adding New Commands

To add a new command:
1. Define a new pattern and action in a Perl script.
2. Register the command using `register_command`.
3. Test the new command.

Example:

```perl
sub handle_new_command {
    my ($args) = @_;
    # Command handling logic here
}

register_command(qr/^new\s+command\s+(.*)/, \&handle_new_command);
```
```

This setup provides the foundation for the ShellGenie command parser. You can extend it by adding more command patterns and actions as needed.

### Step 6: Extending the Command Parser

Now that we have the basic structure set up, let's extend the command parser with more complex commands and add some more functionality to the parser, such as argument validation and error handling.

#### 1. Enhanced Command Registration

Modify `lib/ShellGenieParser.pm` to include argument validation and error handling.

**File:** `lib/ShellGenieParser.pm`

```perl
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
            $entry->{Action}->(@matches);
            return 1;
        }
    }
    warn "No matching pattern for command: $command\n";
    return 0; # No pattern matched
}

1; # End of ShellGenieParser.pm
```

#### 2. Adding Argument Validation

Create a new example with argument validation in `examples`.

**File:** `examples/example_with_validation.pm`

```perl
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
```

#### 3. Improved Error Handling and Logging

Enhance error handling and logging in `lib/ShellGenieParser.pm`.

**File:** `lib/ShellGenieParser.pm`

```perl
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
```

#### 4. Additional Commands and Tests

Add more example commands and corresponding tests.

**File:** `examples/additional_commands.pm`

```perl
use lib '../lib';
use ShellGenieParser qw(register_command parse_command);

# Command handler for `rm` command
sub handle_rm_command {
    my ($filename) = @_;
    system("rm -f $filename");
}

# Argument validator for `rm` command
sub validate_rm_args {
    my ($filename) = @_;
    return $filename =~ /^[a-zA-Z0-9_\-\/\.]+$/; # Simple validation for filename
}

# Register the `rm` command pattern, action, and argument validator
register_command(qr/^rm\s+(.*)/, \&handle_rm_command, \&validate_rm_args);

# Parse example commands
parse_command('rm test_file.txt');
```

**File:** `test/t/test_additional_commands.t`

```perl
use Test::More tests => 4;
use lib '../../lib';
use ShellGenieParser qw(register_command parse_command);

# Mock command handlers for testing
sub mock_mkdir_handler {
    pass("mkdir command handler executed");
}
sub mock_rm_handler {
    pass("rm command handler executed");
}

# Argument validators for testing
sub mock_mkdir_validator {
    my ($dirname) = @_;
    return $dirname eq 'test_dir';
}
sub mock_rm_validator {
    my ($filename) = @_;
    return $filename eq 'test_file.txt';
}

# Register mock commands
register_command(qr/^mkdir\s+(.*)/, \&mock_mkdir_handler, \&mock_mkdir_validator);
register_command(qr/^rm\s+(.*)/, \&mock_rm_handler, \&mock_rm_validator);

# Test: Successful mkdir command parsing
ok(parse_command('mkdir test_dir'), "mkdir command parsed successfully");

# Test: Unsuccessful mkdir command parsing due to invalid arguments
ok(!parse_command('mkdir invalid/dir!'), "Invalid mkdir command not parsed");

# Test: Successful rm command parsing
ok(parse_command('rm test_file.txt'), "rm command parsed successfully");

# Test: Unsuccessful rm command parsing due to invalid arguments
ok(!parse_command('rm invalid_file!'), "Invalid rm command not parsed");
```

### Conclusion

With the enhanced ShellGenie command parser setup, we have:

1. A flexible and extensible parser using Perl's dynamic capabilities.
2. Argument validation for ensuring command integrity.
3. Improved error handling and logging for better reliability.
4. Additional example commands and corresponding tests to validate the parser functionality.

This setup allows for easy expansion by adding new command patterns, actions, and validators. The parser can handle a wide variety of commands, making it a powerful component of the ShellGenie system.

### Step 7: Integrating the Language Model

To complete the ShellGenie system, we need to integrate the command parser with the language model. This will involve setting up the interface that communicates with the language model, processes the interpreted commands, and forwards them to the parser.

#### 1. Setting Up the ShellGenie Interface

Create the ShellGenie interface module in the `lib` directory.

**File:** `lib/ShellGenieInterface.pm`

```perl
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
    
    # Parse the interpreted command
    if (parse_command($interpreted_command)) {
        print "Command executed successfully.\n";
    } else {
        print "Failed to execute command.\n";
    }
}

# Function to call the language model API
sub call_language_model {
    my ($input) = @_;
    
    # Example for calling a local language model API
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
```

#### 2. Testing the ShellGenie Interface

Create a test script for the ShellGenie interface in the `test/t` directory.

**File:** `test/t/test_interface.t`

```perl
use Test::More tests => 2;
use lib '../../lib';
use ShellGenieInterface qw(handle_user_input);

# Mock the call_language_model function
{
    no warnings 'redefine';
    *ShellGenieInterface::call_language_model = sub {
        my ($input) = @_;
        return 'ls -la' if $input eq 'list all files';
        return '';
    };

    # Test: Successful command interpretation and execution
    ok(handle_user_input('list all files'), "Command interpreted and executed successfully");

    # Test: Unsuccessful command interpretation
    ok(!handle_user_input('unknown command'), "Failed to interpret and execute command");
}
```

#### 3. Configuring the Local Language Model

Set up a simple local language model API server using a placeholder script. This script simulates a language model for testing purposes.

**File:** `local_language_model_server.pl`

```perl
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
```

Run this server script in a separate terminal:

```bash
perl local_language_model_server.pl
```

#### 4. Putting It All Together

Create a main script to bring everything together and demonstrate the functionality.

**File:** `main.pl`

```perl
use lib './lib';
use ShellGenieInterface qw(handle_user_input);

# Example user inputs
my @inputs = (
    'list all files',
    'create test directory',
    'unknown command',
);

foreach my $input (@inputs) {
    print "User input: $input\n";
    handle_user_input($input);
}
```

Run the main script:

```bash
perl main.pl
```

### Conclusion

With these steps, we have:

1. Created the ShellGenie interface to handle user input and communicate with the language model.
2. Integrated the command parser with the language model.
3. Set up a simple local language model server for testing.
4. Tested the entire setup to ensure it works as expected.

This completes the basic implementation of the ShellGenie system. You can now extend it by adding more commands, improving the language model, and refining the command parser as needed.

### Step 8: Enhancing the Language Model Integration

To make the ShellGenie system more robust, let's enhance the language model integration by adding more features such as:

1. Improved language model query handling.
2. More sophisticated command patterns.
3. Comprehensive tests to cover various edge cases.

#### 1. Improved Language Model Query Handling

Enhance the `ShellGenieInterface` module to handle more complex interactions with the language model.

**File:** `lib/ShellGenieInterface.pm`

```perl
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
```

#### 2. More Sophisticated Command Patterns

Add more sophisticated command patterns and handlers in the `examples` directory.

**File:** `examples/advanced_commands.pm`

```perl
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
```

#### 3. Comprehensive Tests

Create more comprehensive tests to cover various edge cases in the `test/t` directory.

**File:** `test/t/test_advanced_commands.t`

```perl
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
```

### Running All Tests

To ensure all tests pass and the system works as expected, run the following command:

```bash
prove test/t
```

### Running the Enhanced System

Modify the `main.pl` script to include the advanced commands and demonstrate the enhanced functionality.

**File:** `main.pl`

```perl
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
```

Run the main script:

```bash
perl main.pl
```

### Conclusion

With these enhancements, the ShellGenie system is now more robust and capable of handling more complex commands. The integration with the language model is improved, allowing for more sophisticated interactions. The comprehensive tests ensure that the system behaves as expected in various scenarios. 

You can continue to expand the system by adding more commands, refining the language model, and improving the command parser to handle even more complex user inputs.
