# Contributing to Perl_GPT

Thank you for your interest in contributing to Perl_GPT! This document provides guidelines and best practices for contributing to this repository.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Requirements](#documentation-requirements)
- [Pull Request Process](#pull-request-process)
- [Commit Message Guidelines](#commit-message-guidelines)

## Code of Conduct

This project follows a simple code of conduct:

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other contributors

## Getting Started

### Prerequisites

- Perl 5.34 or higher
- Git
- A GitHub account
- cpanm or cpan (for installing dependencies)

### Initial Setup

1. **Fork the repository** on GitHub

2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Perl_GPT.git
   cd Perl_GPT
   ```

3. **Install dependencies**:
   ```bash
   ./install.sh
   # OR
   make install
   ```

4. **Verify installation**:
   ```bash
   make deps-check
   make syntax-check
   ```

5. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/danindiana/Perl_GPT.git
   ```

## Development Workflow

### Creating a Feature Branch

```bash
# Ensure you're on the latest main branch
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
```

### Branch Naming Conventions

- **Feature branches**: `feature/descriptive-name`
- **Bug fixes**: `fix/bug-description`
- **Documentation**: `docs/what-changed`
- **Refactoring**: `refactor/component-name`

### Making Changes

1. Make your changes in your feature branch
2. Test your changes thoroughly
3. Run code quality checks
4. Update documentation as needed

```bash
# Check syntax
make syntax-check

# Run tests
make test

# Run Perl::Critic
make critic
```

## Coding Standards

### General Perl Best Practices

#### 1. Always Use Strict and Warnings

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use 5.034;  # Minimum version
```

#### 2. File Header Template

Every Perl script should begin with:

```perl
#!/usr/bin/env perl

# Script Name: example.pl
# Purpose: Brief description of what this script does
# Author: Your Name
# Created: YYYY-MM-DD
# Last Modified: YYYY-MM-DD

use strict;
use warnings;
use 5.034;

# Your code here
```

#### 3. Naming Conventions

- **Variables**: `$lowercase_with_underscores`
- **Constants**: `$UPPERCASE_WITH_UNDERSCORES`
- **Subroutines**: `lowercase_with_underscores`
- **Packages**: `CamelCase`
- **File names**: `lowercase_with_underscores.pl`

```perl
# Good
my $file_count = 0;
my $MAX_RETRIES = 3;
sub process_file { ... }

# Bad
my $fileCount = 0;
my $maxRetries = 3;
sub ProcessFile { ... }
```

#### 4. Indentation and Spacing

- Use **4 spaces** for indentation (no tabs)
- One blank line between subroutines
- Space after commas and around operators

```perl
# Good
my @files = ( 'file1.txt', 'file2.txt', 'file3.txt' );
my $result = $x + $y;

# Bad
my @files=('file1.txt','file2.txt','file3.txt');
my $result=$x+$y;
```

#### 5. Error Handling

Always check system calls and provide meaningful error messages:

```perl
# Good
open my $fh, '<', $filename
    or die "Cannot open '$filename' for reading: $!\n";

# Also good with context
open my $fh, '<', $filename
    or die "ERROR: Cannot open '$filename' for reading: $!\n" .
           "  CWD: " . Cwd::getcwd() . "\n" .
           "  Ensure the file exists and you have read permissions.\n";

# Bad
open my $fh, '<', $filename;
```

#### 6. Use Meaningful Variable Names

```perl
# Good
my $total_file_count = 0;
my $bytes_processed = 0;

# Bad
my $tfc = 0;
my $bp = 0;
```

### Perl::Critic Compliance

All code must pass Perl::Critic at severity level 3:

```bash
make critic
# OR
perlcritic --severity 3 your_script.pl
```

Common policies to follow:

1. **No bareword filehandles** - Use lexical filehandles
   ```perl
   # Good
   open my $fh, '<', $file;

   # Bad
   open FH, '<', $file;
   ```

2. **No two-argument open** - Use three-argument form
   ```perl
   # Good
   open my $fh, '<', $filename;

   # Bad
   open my $fh, $filename;
   ```

3. **Check all syscalls**
   ```perl
   close $fh or warn "Cannot close filehandle: $!\n";
   ```

4. **Use proper scoping**
   ```perl
   # Good - lexical variables
   my $count = 0;

   # Bad - package variables without declaration
   $count = 0;
   ```

### Documentation Standards

#### POD Documentation

All modules and significant scripts should include POD documentation:

```perl
=head1 NAME

script_name.pl - Brief description

=head1 SYNOPSIS

    perl script_name.pl [options] <arguments>

=head1 DESCRIPTION

Detailed description of what the script does, its purpose,
and any important behavioral notes.

=head1 OPTIONS

=over 4

=item B<--help>

Display help message and exit

=item B<--verbose>

Enable verbose output

=back

=head1 EXAMPLES

    # Example 1: Basic usage
    perl script_name.pl input.txt

    # Example 2: With options
    perl script_name.pl --verbose input.txt

=head1 AUTHOR

Your Name <your.email@example.com>

=head1 LICENSE

GPL-3.0

=cut
```

#### Inline Comments

- Use comments to explain **why**, not **what**
- Keep comments up-to-date with code changes
- Use TODO/FIXME/NOTE markers for future work

```perl
# Good - explains reasoning
# Use buffered I/O to improve performance on large files
my $buffer_size = 4096;

# Bad - states the obvious
# Set buffer size to 4096
my $buffer_size = 4096;

# TODO: Add support for compressed files
# FIXME: This regex fails on Unicode characters
# NOTE: This approach is faster but uses more memory
```

## Testing Guidelines

### Test Structure

Create tests in the `t/` directory:

```
t/
├── 00-load.t           # Module loading tests
├── 01-basic.t          # Basic functionality
├── 02-edge-cases.t     # Edge cases and error conditions
└── 99-critic.t         # Perl::Critic tests
```

### Writing Tests

Use Test::More for all tests:

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 5;

# Test 1: Module loads
use_ok('My::Module');

# Test 2: Function exists
can_ok('My::Module', 'my_function');

# Test 3: Basic functionality
my $result = My::Module::my_function(42);
is($result, 84, 'Function doubles input correctly');

# Test 4: Edge case
$result = My::Module::my_function(0);
is($result, 0, 'Function handles zero correctly');

# Test 5: Error handling
eval { My::Module::my_function('invalid') };
like($@, qr/numeric/, 'Function rejects non-numeric input');

done_testing();
```

### Running Tests

```bash
# Run all tests
make test

# Run specific test file
prove t/01-basic.t

# Run tests with verbose output
make test-verbose
```

### Test Coverage

Aim for at least 70% code coverage for new code:

```bash
make coverage
# View report in cover_db/coverage.html
```

## Documentation Requirements

### README Updates

When adding new functionality:

1. Update the main README.md
2. Add entry to the appropriate table
3. Update Mermaid diagrams if structural changes
4. Add usage examples

### Module Documentation

Each module directory should contain:

- `readme.md` - Overview and usage
- Inline POD in the main script
- Examples of usage
- List of dependencies (if module-specific)

### Changelog

Significant changes should be documented in commit messages and pull request descriptions.

## Pull Request Process

### Before Submitting

1. **Ensure all tests pass**:
   ```bash
   make all
   ```

2. **Check code quality**:
   ```bash
   make critic
   ```

3. **Update documentation**:
   - Update README.md if adding new features
   - Add/update POD documentation
   - Include usage examples

4. **Clean up your commits**:
   ```bash
   # Squash multiple commits if needed
   git rebase -i HEAD~3
   ```

### Submitting the Pull Request

1. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create PR on GitHub** with:
   - Clear title describing the change
   - Detailed description of what changed and why
   - Reference any related issues
   - Screenshots/examples if applicable

3. **PR Description Template**:
   ```markdown
   ## Description
   Brief description of changes

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Code refactoring
   - [ ] Performance improvement

   ## Testing Done
   - [ ] All existing tests pass
   - [ ] New tests added
   - [ ] Perl::Critic checks pass
   - [ ] Manual testing performed

   ## Checklist
   - [ ] Code follows the style guidelines
   - [ ] Documentation updated
   - [ ] No new warnings introduced
   - [ ] Commit messages are clear

   ## Related Issues
   Fixes #123
   ```

### PR Review Process

- Maintainers will review your PR
- Address any feedback or requested changes
- Once approved, your PR will be merged

## Commit Message Guidelines

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

```
feat(entropy): Add KL divergence calculation

Implement Kullback-Leibler divergence calculation for comparing
probability distributions. This complements the existing Shannon
entropy and JS divergence calculations.

Closes #42
```

```
fix(metadata): Handle missing DOI gracefully

Previously, the script would crash when encountering documents
without DOI identifiers. Now it logs a warning and continues
processing.

Fixes #38
```

```
docs(readme): Update installation instructions

Add troubleshooting section for common dependency issues on
Ubuntu 24.04 and macOS Sonoma.
```

## Project Structure Conventions

### Directory Organization

```
Perl_GPT/
├── examples/          # Example scripts and demonstrations
├── tools/             # Utility scripts
├── modules/           # Organized functional modules
├── t/                 # Test files
├── docs/              # Additional documentation
├── .github/           # GitHub configuration
│   └── workflows/     # CI/CD pipelines
└── lib/               # Reusable Perl modules (if any)
```

### File Organization

- Keep related functionality together
- Avoid deeply nested directories
- Use clear, descriptive names
- Include a readme.md in each module directory

## Questions or Issues?

- Open an issue on GitHub for bugs or feature requests
- Start a discussion for questions or ideas
- Check existing issues before creating new ones

## Attribution

Contributors will be acknowledged in:
- Git commit history
- GitHub contributors page
- Special mentions in release notes for significant contributions

---

Thank you for contributing to Perl_GPT! Your efforts help make this project better for everyone.
