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
