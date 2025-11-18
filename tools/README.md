# Perl_GPT Utility Tools

This directory contains general-purpose utility scripts for file management, text processing, and data manipulation.

## Available Tools

### File Management

#### file_scanner.pl
**Purpose**: Search for files matching specified keywords with optional recursive scanning

**Features**:
- Keyword-based file searching
- Recursive directory scanning
- Interactive deletion of matched files
- Case-insensitive matching

**Usage**:
```bash
perl file_scanner.pl
# Follow interactive prompts
```

**Example**:
```
Enter the target directory: /path/to/search
Do you want to recursively scan all directories? (Y/N): Y
Do you want to list the matched files? (yes/no): yes
Do you want to delete these files? (yes/no): no
```

---

#### merge_directories.pl
**Purpose**: Safely merge files from source directory to destination directory

**Features**:
- Skips existing files (no overwrite)
- Handles symbolic links
- Displays transfer statistics
- Reports total data transferred

**Usage**:
```bash
perl merge_directories.pl
# Enter source and destination directories when prompted
```

---

#### file_deletion_tool.pl
**Purpose**: Safe file deletion with confirmation

**Features**:
- Interactive file deletion
- Confirmation prompts
- Error handling

---

#### file_size_scanner.pl
**Purpose**: Analyze file sizes in a directory

**Features**:
- Recursive size calculation
- Size statistics
- Human-readable output

---

### Text Processing

#### concat_chunks.pl
**Purpose**: Concatenate text files into chunks of specified size

**Features**:
- Configurable chunk size
- Sequential processing
- Output file naming

---

#### remove_whitespace.pl
**Purpose**: Normalize whitespace in text files

**Features**:
- Removes extra whitespace
- Normalizes line endings
- Preserves file structure

---

#### remove_repeats_html.pl
**Purpose**: Remove duplicate content from HTML files

**Features**:
- HTML-aware processing
- Duplicate detection
- Clean output

---

### Data Mutation

#### perl_mutator.pl
**Purpose**: Convert URLs to UUID format

**Features**:
- UUID generation
- URL processing
- Format conversion

**Dependencies**:
- Data::UUID

---

#### perl_mutator2.pl
**Purpose**: Advanced URL mutation with random data

**Features**:
- Random data generation
- Multiple mutation strategies
- Configurable output

**Dependencies**:
- Data::Random

---

### System Utilities

#### clean_bash_history.pl
**Purpose**: Sanitize and clean bash history files

**Features**:
- Duplicate removal
- Privacy-preserving filtering
- Safe history modification

---

## General Usage Pattern

Most tools follow this pattern:

1. **Run the script**:
   ```bash
   perl tools/script_name.pl
   ```

2. **Provide input** when prompted (directory paths, options, etc.)

3. **Review output** and confirm actions if required

4. **Check results** in the specified output location

## Dependencies

All tools require:
- Perl 5.34+
- Core modules (included with Perl)

Some tools require additional CPAN modules:
- **perl_mutator.pl**: Data::UUID
- **perl_mutator2.pl**: Data::Random

Install dependencies with:
```bash
cpanm Data::UUID Data::Random
# OR from repository root
make install
```

## Safety Features

All tools include:
- Input validation
- Error handling
- Confirmation prompts for destructive operations
- Informative error messages
- Safe defaults (no automatic deletion)

## Best Practices

1. **Test on sample data first** before running on production files
2. **Back up important data** before using destructive operations
3. **Review output** before confirming deletions or modifications
4. **Check disk space** for operations that create new files
5. **Use absolute paths** to avoid confusion about working directory

## Contributing

When adding new tools:

1. Follow naming convention: `descriptive_name.pl`
2. Include proper error handling
3. Add usage documentation (POD or comments)
4. Provide examples in this README
5. Test thoroughly with edge cases
6. Follow the coding standards in CONTRIBUTING.md

## Support

For issues or questions:
- Check the main repository README
- Review CONTRIBUTING.md for coding standards
- Open an issue on GitHub

---

**Last Updated**: November 2025
