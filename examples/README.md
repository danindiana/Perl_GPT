# Perl_GPT Examples

This directory contains example scripts demonstrating how to use various utilities and modules from the Perl_GPT repository.

## Available Examples

### 1. basic_file_search.pl
**Purpose**: Demonstrates file searching with keyword matching

**What it shows**:
- Non-recursive directory scanning
- Recursive file search with File::Find
- Pattern matching for file filtering
- Safe file operations

**Run it**:
```bash
perl examples/basic_file_search.pl
```

**Learn**:
- How to use the file_scanner.pl utility
- Different search strategies
- File::Find module usage
- Safe file handling practices

---

### 2. entropy_analysis.pl
**Purpose**: Demonstrates Shannon entropy calculation for text analysis

**What it shows**:
- Shannon entropy calculation
- Character frequency analysis
- Text quality assessment
- Distribution statistics

**Run it**:
```bash
perl examples/entropy_analysis.pl
```

**Learn**:
- Information theory basics
- Entropy-based text quality metrics
- When to use entropy_cleaner vs entropy_nlp
- Interpreting entropy values

**Output includes**:
- Entropy values for different text types
- Character distribution analysis
- Quality classifications
- Practical thresholds

---

### 3. jsonl_creation.pl
**Purpose**: Demonstrates JSONL format creation for ML pipelines

**What it shows**:
- Creating JSONL records
- Adding metadata
- Batch processing
- File validation
- 2GB rotation strategy

**Run it**:
```bash
perl examples/jsonl_creation.pl
```

**Learn**:
- JSONL format specifications
- Metadata best practices
- Large dataset handling
- Data validation techniques

**Use cases**:
- ML training data preparation
- Text classification datasets
- Document embedding pipelines

---

## Running the Examples

### Prerequisites

Make sure you have installed all dependencies:

```bash
# Install dependencies
make install

# Or use install script
./install.sh

# Or use cpanm directly
cpanm --installdeps .
```

### Run Individual Examples

```bash
# From repository root
perl examples/basic_file_search.pl
perl examples/entropy_analysis.pl
perl examples/jsonl_creation.pl
```

### Run All Examples

```bash
# Run all examples sequentially
for example in examples/*.pl; do
    echo "Running $example..."
    perl "$example"
    echo ""
done
```

## Example Output

Each example is designed to be educational and includes:

- **Clear sections** with headers
- **Commented code** explaining each step
- **Sample output** showing expected results
- **Usage tips** for related utilities
- **Best practices** and recommendations

## Creating Your Own Examples

When creating new examples, follow this template:

```perl
#!/usr/bin/env perl

=head1 NAME

example_name.pl - Brief description

=head1 SYNOPSIS

    perl examples/example_name.pl

=head1 DESCRIPTION

Detailed description of what this example demonstrates.

=cut

use strict;
use warnings;

# Your example code here

__END__

=head1 AUTHOR

Your Name

=head1 LICENSE

GPL-3.0

=cut
```

### Guidelines

1. **Self-contained**: Examples should run without additional setup
2. **Educational**: Include comments explaining concepts
3. **Safe**: Use temporary directories, avoid destructive operations
4. **Clear output**: Show what's happening with descriptive messages
5. **POD documentation**: Include proper documentation
6. **Follow standards**: Use strict, warnings, and coding standards

## Related Modules

Examples demonstrate these main modules:

- **tools/file_scanner.pl** - File searching and filtering
- **entropy_cleaner/** - File quality assessment
- **entropy_nlp/** - Advanced statistical analysis
- **jsonl_convertor/** - ML data format conversion
- **arxiv_doi_grabber/** - Academic metadata extraction

## Testing Examples

Examples can be tested with:

```bash
# Syntax check
perl -c examples/example_name.pl

# Run with verbose output
perl -w examples/example_name.pl

# Check for warnings
perl -Mwarnings=FATAL,all examples/example_name.pl
```

## Contributing Examples

Have a useful example to share?

1. Create your example following the guidelines
2. Add documentation
3. Test thoroughly
4. Update this README
5. Submit a pull request

See [CONTRIBUTING.md](../CONTRIBUTING.md) for details.

## Further Reading

- [Main README](../README.md) - Repository overview
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution guidelines
- [tools/README.md](../tools/README.md) - Utility tools documentation

## Support

Questions or issues with examples?

- Check the main README first
- Review the module's own documentation
- Open an issue on GitHub

---

**Last Updated**: November 2025
**Repository**: [Perl_GPT](https://github.com/danindiana/Perl_GPT)
